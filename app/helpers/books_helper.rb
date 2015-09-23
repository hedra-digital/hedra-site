module BooksHelper
  def book_team(book)
    book.participations.inject({}) do |result, element|
      result[element.role.name] ||= []
      result[element.role.name] << element.person.name
      result
    end
  end

  def authors(book)
    formatted_list(book_team(book)["Texto"].to_a + book_team(book)["Autoria"].to_a + book_team(book)["Autor"].to_a)
  end

  def book_stats(book)
    [
      ['Número de páginas', book.pages],
      ['ISBN', book.isbn],
      ['Idiomas', book.language_list],
      ['Encadernação', book.binding_name],
      ['Dimensões', book.dimensions],
      ['Peso', book.weight_with_unit],
      ['Ano de lançamento', book.release_year]
    ].inject([]){ |sum, obj| obj[1].nil? ? sum : sum << stats_item(obj[0], obj[1]) }.join.html_safe
  end

  def book_tags(book)
    book.tags.map(&:name).inject([]) { |sum, obj| sum << content_tag(:li, link_to(obj, tag_page_path(obj))) }.join.html_safe
  end

  def description_lead(book)
    raw(book.description.split('</p>')[0] + '</p>') rescue truncate_html(book.description, :length => 450, :omission => '...')
  end

  # only one interface
  def show_price(book, book_type)
    case book_type
    when :print
      return book_print_price(book)
    when :ebook
      return book.price_ebook
    when :packet
      return nil if book_print_price(book) == nil || book.price_ebook == nil
      return (1 - book.packet_discount) * (book_print_price(book) + book.price_ebook)
    end
  end

  def show_discount(promotion, book)
    return promotion.discount * 100 if promotion.discount
    (book.price_print - promotion.price) * 100 / book.price_print
  end

  # only one interface
  def find_promotion(book)
    site_promotion = Promotion.where("book_id is null and tag_id is null and category_id is null and publisher_id = ? and ? between started_at and ended_at and (slug is null or slug = '')", book.publisher_id, Time.now).order("created_at").last
    return site_promotion if site_promotion

    partner_promotion = find_partner_promotion(book)
    return partner_promotion if partner_promotion
    return find_private_promotion(book) if find_private_promotion(book)
    return find_public_promotion(book) if find_public_promotion(book)
  end

  private

  def find_partner_promotion(book)
    key_value_cookie = cookies.find { |k,v| k == 'current_campaign' }

    return nil unless key_value_cookie

    promotion_id = key_value_cookie.last.split('_').first.to_i
    return Promotion.where('id = ? and ? between started_at and ended_at', promotion_id, Time.now).last
  rescue => e
    Rails.logger.error e.message
  end

  # promotion priority: book > tag > category > site
  def find_private_promotion(book)
    coupons = []

    cookies.each_entry do |c|
      coupons << c.last if c.first.starts_with?("coupon_") 
    end
  
    return nil if coupons.size == 0

    book_promotion = Promotion.where("book_id = ? and ? between started_at and ended_at and slug in (?)", book.id, Time.now, coupons).order("created_at").last
    return book_promotion if book_promotion

    tag_promotion = Promotion.where("tag_id in (?) and publisher_id = ? and ? between started_at and ended_at and slug in (?)", book.tags.map(&:id), book.publisher_id, Time.now, coupons).order("created_at").last
    return tag_promotion if tag_promotion

    category_promotion = Promotion.where("category_id = ? and publisher_id = ? and ? between started_at and ended_at and slug in (?)", book.category_id, book.publisher_id, Time.now, coupons).order("created_at").last
    return category_promotion if category_promotion

    site_promotion = Promotion.where("book_id is null and tag_id is null and category_id is null and publisher_id = ? and ? between started_at and ended_at and slug in (?)", book.publisher_id, Time.now, coupons).order("created_at").last
    return site_promotion if site_promotion

    nil
  end

  # promotion priority: book > tag > category
  def find_public_promotion(book)
    book_promotion = Promotion.where("book_id = ? and ? between started_at and ended_at and (slug is null or slug = '')", book.id, Time.now).order("created_at").last
    return book_promotion if book_promotion

    tag_promotion = Promotion.where("tag_id in (?) and publisher_id = ? and ? between started_at and ended_at and (slug is null or slug = '')", book.tags.map(&:id), book.publisher_id, Time.now).order("created_at").last
    return tag_promotion if tag_promotion
    category_promotion = Promotion.where("category_id = ? and publisher_id = ? and ? between started_at and ended_at and (slug is null or slug = '')", book.category_id, book.publisher_id, Time.now).order("created_at").last
    return category_promotion if category_promotion

    nil
  end

  def stats_item(title, data)
    render :partial => 'stats_item', :locals => { :title => title, :data => data }
  end

  private

  def book_print_price(book)
    return nil if book.price_print.nil?

    promotion = find_promotion(book)

    return book.price_print if promotion.nil?
    return promotion.price if promotion.price and promotion.book_id == book.id
    return (1 - promotion.discount) * book.price_print
  end
end

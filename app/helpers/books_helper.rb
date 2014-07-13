# -*- encoding : utf-8 -*-

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
    ].inject([]) { |sum, obj| obj[1].nil? ? sum : sum << stats_item(obj[0], obj[1]) }.join.html_safe
  end

  def book_tags(book)
    book.tags.map(&:name).inject([]) { |sum, obj| sum << content_tag(:li, link_to(obj, tag_page_path(obj))) }.join.html_safe
  end

  def description_lead(book)
    raw(book.description.split('</p>')[0] + '</p>') rescue truncate_html(book.description, :length => 450, :omission => '...')
  end


  def promotion_price(book)
    promotion = book.find_promotion

    return nil if promotion.nil?

    return promotion.price if promotion.price

    (1 - promotion.discount) * book.price_print
  end

  def show_discount(promotion, book)
    return promotion.discount * 100 if promotion.discount
    (book.price_print - promotion.price) * 100 / book.price_print
  end


  private

  def stats_item(title, data)
    render :partial => 'stats_item', :locals => { :title => title, :data => data }
  end

end

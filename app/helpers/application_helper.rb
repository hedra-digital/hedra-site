module ApplicationHelper

  def current_publisher
    Publisher.find(session[:publisher])
  end

  def publisher_logo
    "background: url('#{Publisher.find(session[:publisher]).logo.url}') no-repeat; background-size: 100% 100%;"
  end

  def publisher_logo_img
    Publisher.find(session[:publisher]).logo.url
  end
  
  def publisher_nameli
    "#{Publisher.find(session[:publisher]).name}"
  end

  def publisher_contact
    "#{Publisher.find(session[:publisher]).contact}"
  end

  def publisher_about
    "#{Publisher.find(session[:publisher]).about}".html_safe
  end

  def publisher_distributors
    "#{Publisher.find(session[:publisher]).distributors}".html_safe
  end

  def flash_message
    messages = ""
    types = { :notice => 'success', :alert => 'error', :info => 'info' }
    flash.each do |type, content|
      messages = content_tag :div, :class => 'container' do
        content_tag :div, :class => "alert alert-#{types[type]}" do
          concat button_tag('&#215;'.html_safe, :type => 'button', :class => 'close', :'data-dismiss' => 'alert', :name => nil)
          concat content.html_safe
        end
      end
    end
    messages
  end

  def page_data(options={})
    content_for :og do
      [
        ['og:title', options[:title]],
        ['og:type', options[:type]],
        ['og:url', "#{request.protocol}#{request.host_with_port}#{request.fullpath}"],
        ['og:description', options[:description]],
        ['og:image', options[:image]],
        ['fb:admins', '694928618'],
        ['fb:admins', '534302953'],
        ['og:site_name', 'Editora Hedra']
      ].inject([]) { |sum, obj| obj[1].nil? ? sum : sum << tag(:meta, { :property => obj[0], :content => obj[1]}) }.join.html_safe
    end
    if options[:title].presence
      content_for(:h1, content_tag(:h1, options[:title]))
      content_for(:title, content_tag(:title, "#{options[:title]} | #{publisher_name}"))
    end
    if options[:description].presence
      content_for(:meta_tags, tag(:meta, { :name => 'description', :content => options[:description] }))
    end
  end

  def meta_cleanup(description)
    truncate description.gsub(/(<p>|<i>|<\/i>|<b>|<\/b>|<em>|<\/em>|\r\n|\n\r|^\s+)/, ""), :length => 156, :separator => ' '
  end

  def formatted_list(array)
    array.to_sentence(:two_words_connector => ' e ', :last_word_connector => ' e ') rescue ""
  end

  def book_in_cart_for(book, book_type)
    tags = ""
    tags << content_tag(:div, image_tag(book.cover_url.to_s), :class => 'cart-book-cover')
    tags << content_tag(:div, content_tag(:p, book.long_title(book_type), :class => 'cart-book-title') + content_tag(:p, authors(book), :class => 'cart-book-authors'), :class => 'cart-book-data')
    tags << content_tag(:div, number_to_currency(show_price(book, book_type)), :class => 'cart-book-price')
    tags.html_safe
  end

  def cart_total
    return 0 if session[:cart] == nil
    total = 0

    session[:cart].each{ |h| total += h[:quantity] * show_price(Book.find(h[:book_id]), h[:book_type]) }
    total
  end

  def publisher_name
    Publisher.find(session[:publisher]).name
  end

  def blog_count
    Post.joins(:book).where("books.publisher_id = #{session[:publisher]}").count
  end

  def options_for_installment(total)
    options = [
      ["1 x #{number_to_currency(total/1)} = #{number_to_currency(total)}  (Sem juros)", 1],
      ["2 x #{number_to_currency(total/2)} = #{number_to_currency(total)}  (Sem juros)", 2],
      ["3 x #{number_to_currency(total/3)} = #{number_to_currency(total)}  (Sem juros)", 3]
    ]

    (4..12).each do |i|
      t = total_after_installment(total,i)
      options << ["#{i} x #{number_to_currency(t/i)} = #{number_to_currency(t)} (Taxa de parcelamento #{number_to_currency(t - total)})", i]
    end

    options
  end

  private

  def total_after_installment(total, installment)
    installment_fee = {4 => 0.05, 5 => 0.06, 6 => 0.08, 7 => 0.09, 8 => 0.1, 9 => 0.11, 10 => 0.13, 11 => 0.14, 12 => 0.15}
    total * (1 - 0.07) / (1 - 0.07 - installment_fee[installment])
  end

end

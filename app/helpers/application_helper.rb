module ApplicationHelper

  def flash_message
    messages = ""
    flash.each do |type, content|
      messages = content_tag :div, :class => 'container' do
        content_tag :div, :class => "alert alert-#{ type == :notice ? "success" : "error" }" do
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
      content_for(:title, content_tag(:title, "#{options[:title]} | Editora Hedra"))
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

  def book_in_cart_for(book_id)
    book = Book.find(book_id)
    [
      [image_tag(book.cover_url.to_s), 'cart-book-cover'],
      [book.title, 'cart-book-title'],
      [number_to_currency(book.price_print), 'cart-book-price'],
      [link_to("x", remove_from_cart_path(book.id), :method => :post), 'cart-book-remove'],
    ].inject([]) { |sum, obj| sum << content_tag(:div, obj[0], :class => obj[1]) }.join.html_safe
  end

  def cart_image
    cart_empty? ? image_tag('cart.png') : link_to(image_tag('cart_full.png'), '#', :class => 'dropdown-toggle', 'data-toggle' => 'dropdown')
  end

  def cart_empty?
    session['cart'].nil? || session['cart'].empty?
  end

  def total_cart_items
    session['cart'] ||= []
    session['cart'].size unless session['cart'].empty?
  end
end

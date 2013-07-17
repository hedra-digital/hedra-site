# -*- encoding : utf-8 -*-
module ApplicationHelper

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

  def book_in_cart_for(book)
    tags = ""
    tags << content_tag(:div, image_tag(book.cover_url.to_s), :class => 'cart-book-cover')
    tags << content_tag(:div, content_tag(:p, book.title, :class => 'cart-book-title') + content_tag(:p, authors(book), :class => 'cart-book-authors'), :class => 'cart-book-data')
    tags << content_tag(:div, number_to_currency(book.price_print), :class => 'cart-book-price')
    tags.html_safe
  end

  def cart_image
    cart_empty? ? image_tag('cart.png') : link_to(image_tag('cart_full.png'), '#', :class => 'dropdown-toggle', 'data-toggle' => 'dropdown')
  end

  def cart_empty?
    @cart_items.nil? || @cart_items.empty?
  end
end

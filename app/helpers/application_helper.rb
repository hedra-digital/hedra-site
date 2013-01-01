module ApplicationHelper

  def flash_message
    messages = ""
    flash.each do |type, content|
      button = button_tag('&#215;'.html_safe, :type => 'button', :class => 'close', :'data-dismiss' => 'alert', :name => nil) + content
      messages = content_tag(:div, button, :class => "alert alert-#{ type == :notice ? "success" : "error" }")
    end
    messages
  end

  def page_data(options={})
    content_for :og do
      data = ""
      data << tag(:meta, { :property => 'og:title', :content => options[:title] }) if options[:title].present?
      data << tag(:meta, { :property => 'og:type', :content => options[:type] }) if options[:type].present?
      data << tag(:meta, { :property => 'og:url', :content => "#{request.protocol}#{request.host_with_port}#{request.fullpath}"})
      data << tag(:meta, { :property => 'og:description', :content => options[:description] }) if options[:description].present?
      data << tag(:meta, { :property => 'og:image', :content => options[:image] }) if options[:image].present?
      data << tag(:meta, { :property => 'fb:admins', :content => '694928618' })
      data << tag(:meta, { :property => 'fb:admins', :content => '534302953' })
      data << tag(:meta, { :property => 'og:site_name', :content => 'Editora Hedra' })
      raw(data)
    end
    content_for(:h1, content_tag(:h1, options[:title]))
    content_for(:title, content_tag(:title, "#{options[:title]} | Editora Hedra")) if options[:title].present?
    content_for(:meta_tags, tag(:meta, { :name => 'description', :content => options[:description] })) if options[:description].present?
  end

  def meta_cleanup(description)
    truncate description.gsub(/(<p>|<i>|<\/i>|<b>|<\/b>|<em>|<\/em>|\r\n|\n\r|^\s+)/, ""), :length => 156, :separator => ' '
  end

  def formatted_list(array)
    array.to_sentence(:two_words_connector => ' e ', :last_word_connector => ' e ') rescue ""
  end
  
  def book_in_cart_for(b)
    book = Book.find(b)
    book.title
  end

  def cart_image
    cart_empty? ? image_tag('cart.png') : image_tag('cart_full.png')
  end

  def cart_empty?
    session['cart'].nil? || session['cart'].empty?
  end

  def total_cart_items
    session['cart'] ||= []
    session['cart'].size unless session['cart'].empty?
  end
end

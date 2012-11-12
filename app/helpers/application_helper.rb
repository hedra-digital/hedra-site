module ApplicationHelper

  def flash_message
    messages = ""
    flash.each do |type, content|
      button = button_tag('&#215;'.html_safe, :type => 'button', :class => 'close', :'data-dismiss' => 'alert', :name => nil) + content
      messages = content_tag(:div, button, :class => "alert alert-#{ type == :notice ? "success" : "error" }")
    end
    messages
  end

  def title(page_title)
    content_for(:h1, content_tag(:h1, page_title))
    content_for(:title, content_tag(:title, page_title << ' | Editora Hedra'))
  end

  def formatted_list(array)
    array.to_sentence(:two_words_connector => ' e ', :last_word_connector => ' e ')
  end

end

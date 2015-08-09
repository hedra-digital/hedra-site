class NotifierPreview
  def order_post_tracking
    Notifier.order_post_tracking order
  end


  def mail_to_trello
    Notifier.mail_to_trello order
  end


  def send_ebook
    Notifier.send_ebook order
  end


  def order_created
    Notifier.order_created Order.last
  end


  def order_completed
    Notifier.order_completed Order.last
  end


  def order_failed
    Notifier.order_failed order
  end
end

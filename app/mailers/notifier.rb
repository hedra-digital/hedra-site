class Notifier < ActionMailer::Base
  default from: "editora@hedra.com.br"

  def order_post_tracking(order)
  	@order = order
    mail(to: order.user.email, subject: "seu pedido #{order.id} foi enviado")
  end

  def mail_to_trello(order)
  	@order = order
    mail(to: APP_CONFIG["trello_mail"], subject: "Due at #{(@order.transactions.last.updated_at + APP_CONFIG["trello_mail_add_date"].days).strftime("%Y-%m-%d")}, #{@order.id}, #{@order.user.email}")
  end

  def send_ebook(order)
  	@order = order

  	order.order_items.each do |i|
  		attachments["#{i.book.title}.epub"] = File.read(i.book.ebook.path) if i.book_type == Book::EBOOK or i.book_type == Book::PACKET
    end

    mail(to: order.user.email, subject: "Seu ebook está chegando!")
  end

end


class Notifier < ActionMailer::Base
  default from: "editora@hedra.com.br"

  def order_post_tracking(order)
  	@order = order
    mail(to: order.user.email, subject: "seu pedido #{order.id} foi enviado")
  end

  def mail_to_trello(order)
  	@order = order
    mail(to: APP_CONFIG["trello_mail"], subject: "Due at #{(@order.transactions.last.updated_at + 10.days).strftime("%Y-%m-%d")}, #{@order.id}, #{@order.user.email}")
  end
end


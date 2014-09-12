class Notifier < ActionMailer::Base
  default from: "editora@hedra.com.br"

  def order_post_tracking(order)
  	@order = order
    mail(to: order.user.email, subject: "seu pedido #{order.id} foi enviado")
  end
end


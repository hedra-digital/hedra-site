class PartnershipMailer < ActionMailer::Base
  default from: "editora@hedra.com.br"

  def weekly(data)
  	return unless data[:partner_email].present?
  	@data = data
    mail(
      to: data[:partner_email], 
      subject: "Hedra - Relatório Semanal Parcerias", 
      cc: 'parceiros@hedra.com.br'
    )
  end

  def order_completed(order)
    return unless order.try(:promotion).try(:partner).try(:email).present?
    @order = order
    @partner = order.promotion.partner
    mail(
      to: @partner.email, 
      subject: "Hedra - Notificação de Novo Pedido", 
      cc: 'parceiros@hedra.com.br'
    )
  end
end



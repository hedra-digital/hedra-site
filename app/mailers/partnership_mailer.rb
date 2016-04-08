class PartnershipMailer < ActionMailer::Base
  default from: "editora@hedra.com.br"

  def weekly(data)
  	return unless data[:partner_email].present?
  	@data = data
    mail(
      to: data[:partner_email], 
      subject: "Parceiros Hedra - Relatório Semanal Parcerias", 
      cc: 'parceiros@hedra.com.br'
    )
  end

  def order_completed(order)
    return unless order.try(:promotion).try(:partner).try(:email).present?
    @order           = order
    @promotion       = @order.promotion
    @partner         = @promotion.partner
    @total           = @order.order_items.map{|item| item.price * item.quantity}.inject(:+)
    @total_comission = @total * @partner.comission
    mail(
      to: @partner.email, 
      subject: "Parceiros Hedra - Notificação de Novo Pedido", 
      cc: 'parceiros@hedra.com.br'
    )
  end

  def promotion_created(promotion)
    return unless promotion.try(:partner).try(:email).present?
    @promotion = promotion
    @partner = @promotion.partner
    mail(
      to: @partner.email, 
      subject: "Parceiros Hedra - Link Promocional Exclusivo", 
      cc: 'parceiros@hedra.com.br'
    )
  end
end



# -*- encoding : utf-8 -*-
module CheckoutHelper
 def get_setup_purchase_params(order, request, items)
    return to_cents(order.total), {
      :ip => request.remote_ip,
      :return_url => url_for(:action => 'review', :only_path => false),
      :cancel_return_url => cart_url,
      :subtotal => to_cents(order.total),
      :header_background_color => 'ff0000',
      :allow_note =>  true,
      :email => current_user.email,
      :allow_guest_checkout => true,
      :locale => 'pt_BR',
      :currency => 'BRL',
      :payment_method => "credit_card",
      :items => items
      }
  end
   def get_purchase_params(order, request, items, params)
    return to_cents(order.total), {
      :ip => request.remote_ip,
      :token => params[:token],
      :payer_id => params[:PayerID],
      :subtotal => to_cents(order.total),
      :locale => 'pt_BR',
      :currency => 'BRL',
      :items => [:name => experience.title,:number => experience.id, :amount => to_cents(experience.price), :quantity => number_of_tickets]
    }
  end

  def to_cents(money)
    (money.to_f*100).round
  end
end
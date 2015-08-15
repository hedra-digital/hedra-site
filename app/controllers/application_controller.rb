class ApplicationController < ActionController::Base
  protect_from_forgery

  ERROR_MESSAGES = {
    empty_cart: "Não foi possível finalizar a sua compra, pois não há itens no seu carrinho de compras.",
    not_authenticated: "Por favor, autentique-se primeiro.",
    error_credit_card: "Por favor, verifique suas informações de cartão de crédito.",
    not_shipping_address: "Por favor, verifique su endereço para a entrega.",
    not_shipping_data: "Por favor, verifique su informações de frete."
  }

  before_filter :filter

protected

  def filter
    http_authenticate
    get_publisher
    get_categories
    get_cart_items
  end

  def http_authenticate
    if Rails.env == 'staging'
      authenticate_or_request_with_http_basic do |username, password|
        username == "teste" && password == "teste13"
      end
    end
  end

  def get_publisher
    publisher = Publisher.where("url LIKE ?", "%#{request.host}%").first
    if publisher.nil?
      session[:publisher] = Publisher.get_default.id
    else
      session[:publisher] = publisher.id
    end
  end

  def get_categories
    @category_list ||= Category.joins(:categories_publishers).where("categories_publishers.publisher_id = #{session[:publisher]}").order("categories.order ASC")
  end

  def get_cart_items
    session[:cart] ||= []

    out_of_stock = []

    session[:cart].each do |item|
      book = Book.find(item[:book_id])
      price = view_context.show_price(book, item[:book_type])
      out_of_stock << item if price.nil?
    end

    session[:cart] = session[:cart] - out_of_stock

    flash.alert = "Alguns livros em seus ware cartão de vender para fora agora." if out_of_stock.size > 0
  end

  def not_found
    raise ActiveRecord::RecordNotFound
  end

  def create_order(user, address_hash, cart, payment_method, cpf_cnpj, telephone, shipping_type=nil)
    return nil if cart.blank?
    order = nil

    shipping_cost_result = ShipmentCalculatorService.execute(cart, address_hash[:zip_code], shipping_type)
    raise ArgumentError if shipping_cost_result.nil? || shipping_cost_result.empty?

    shipping_cost = shipping_cost_result[shipping_type][:cost]
    shipping_time = shipping_cost_result[shipping_type][:shipping_time]

    ActiveRecord::Base.transaction do
      address_hash = address_hash.merge({user_id: user.id})

      address = Address.create(address_hash)

      order = Order.create(user_id: user.id,
        address: address,
        email: user.email,
        payment_state: 'Aguardando aprovação',
        shipment_state: 'Aguardando envio',
        cpf_cnpj: cpf_cnpj,
        telephone: telephone,
        shipping_type: shipping_type,
        shipping_cost: shipping_cost,
        shipping_time: shipping_time
        )

      total = 0

      cart.each do |item|
        book = Book.find(item[:book_id])
        total += view_context.show_price(book, item[:book_type]) * item[:quantity]
        OrderItem.create(order_id: order.id, book_id: item[:book_id], price: view_context.show_price(book, item[:book_type]), quantity: item[:quantity], book_type: item[:book_type])
      end

      total += shipping_cost

      Transaction.create(user_id: order.user_id, status: Transaction::CREATED, :order_id => order.id, :payment_method => payment_method)
      order.update_attributes(:total => total)
    end

    order
  end

  def order_validation_triggered_redirect?(check_credit_card_token = false)
    redirect_to "/",        alert: ERROR_MESSAGES[:empty_cart]            and return true if session[:cart].blank?
    redirect_to cart_path,  alert: ERROR_MESSAGES[:not_authenticated]     and return true unless current_user
    redirect_to cart_path,  alert: ERROR_MESSAGES[:error_credit_card]     and return true if check_credit_card_token && params[:token].blank?
    redirect_to cart_path,  alert: ERROR_MESSAGES[:not_shipping_address]  and return true if params[:address].blank? || params[:address][:zip_code].blank?
    redirect_to cart_path,  alert: ERROR_MESSAGES[:not_shipping_data]     and return true if params[:shipping_type].blank?

    return false
  end
end

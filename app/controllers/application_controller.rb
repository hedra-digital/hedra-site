class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :filter

protected

  def filter
    http_authenticate
    get_publisher
    get_categories
    get_cart_items
    get_cart_price
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
    if session[:carrinho]
      @cart_items ||= []
      session[:carrinho].each do |book_id, quantity|
        book = Book.includes(:participations => [:person, :role]).find(book_id)
        @cart_items << [book, quantity]
      end
    end
  end

  def get_cart_price
    if @cart_items
      @cart_price = @cart_items.inject(0) { |sum, ele| sum += (view_context.show_price(ele[0]) * ele[1]) }
    end
  end

  def not_found
    raise ActiveRecord::RecordNotFound
  end


  def create_order(user, address, cart, payment_method)
    return nil if cart.nil?
    order = Order.create(user_id: user.id, address: address, email: user.email, payment_state: 'Aguardando aprovação', shipment_state: 'Aguardando envio')
    total = 0
    cart.keys.each do |book_id|
      book = Book.find(book_id)
      total += view_context.show_price(book) * cart[book_id]
      OrderItem.create(order_id: order.id, book_id: book_id, price: view_context.show_price(book), quantity: cart[book_id])
    end
    Transaction.create(user_id: order.user_id, status: Transaction::CREATED, :order_id => order.id, :payment_method => payment_method)
    order.update_attributes(:total => total)
    order
  end


end

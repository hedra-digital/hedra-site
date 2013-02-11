class Cart
  extend ActiveModel::Naming

  attr_reader   :book, :quantity
  attr_writer   :quantity

  @@instance_collector = []
  @@total_price = 0

  def initialize(book)
    @@instance_collector << self
    @@total_price += book.price_print
    @book = book
    @quantity = 1
  end

  def self.all
    @@instance_collector
  end

  def self.find(param)
    all.detect { |cart_item| cart_item.book.id == param }
  end

  def self.update_or_initialize(options={})
    cart_item = Cart.find(options[:book_id])
    if cart_item
      cart_item.quantity = options[:quantity]
      @@total_price += (cart_item.book.price_print * cart_item.quantity)
    else
      book = Book.includes(:participations => [:person, :role]).find(options[:book_id])
      Cart.new(book)
    end
  end

  def self.total_price
    @@total_price
  end

  def persisted?
    false
  end

end

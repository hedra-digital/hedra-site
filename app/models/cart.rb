class Cart
  extend ActiveModel::Naming

  attr_reader   :book, :quantity
  attr_writer   :quantity

  @@instance_collector = []
  @@total_price = 0

  def initialize(book)
    unless Cart.find(book.id)
      @@instance_collector << self
      @@total_price += book.price_print
      @book = book
      @quantity = 1
    end
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
      @@total_price -= (cart_item.book.price_print * cart_item.quantity)
      cart_item.quantity = options[:quantity]
      @@total_price += (cart_item.book.price_print * options[:quantity])
    else
      book = Book.includes(:participations => [:person, :role]).find(options[:book_id])
      Cart.new(book) if book
    end
  end

  def delete
    @@total_price -= (self.book.price_print * self.quantity)
    self.instance_variables.each { |v| self.instance_variable_set(v, nil) }
    @@instance_collector.delete(self)
  end

  def self.total_price
    @@total_price
  end

  def persisted?
    false
  end

end

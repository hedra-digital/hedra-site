require 'correios-frete'

Package = Struct.new(:weight, :width, :length, :height, :declared_value)
DEFAULT_BOOK_WEIGHT = 0.3 #kg
DEFAULT_BOOK_WIDTH  = 12  #cm
DEFAULT_BOOK_LENGTH = 25  #cm
DEFAULT_BOOK_PAGES  = 100
DEFAULT_BOOK_PRICE  = 28.71 #reales

PRINT_BOOK_TYPE = :print

class ShipmentCalculatorService
  def self.execute(hashed_books, cep)
    package = calculate_rough_package_size(hashed_books)

    puts "="*50
    puts package
    puts "="*50

    {
      modico: { shipping_time: 1, cost: 16.10 },
      pac:    { shipping_time: 1, cost: 16.10 },
      sedex:  { shipping_time: 1, cost: 16.10 }
    } 

    # calculate_shipment_costs_for @default_address.zip_code
  end

  private
    def self.calculate_rough_package_size(hashed_books)
      package = Package.new(0, 0, 0, 0, 0)

      hashed_books.each do |data|
        next if data[:book_type] != PRINT_BOOK_TYPE

        book = Book.find(data[:book_id])

        book_weight = book.weight       || DEFAULT_BOOK_WEIGHT
        book_width  = book.width        || DEFAULT_BOOK_WIDTH
        book_length = book.height       || DEFAULT_BOOK_LENGTH # the book.height means length
        book_pages  = book.pages        || DEFAULT_BOOK_PAGES
        book_price  = book.price_print  || DEFAULT_BOOK_PRICE

        data[:quantity].times do
          package.weight += (book_weight * data[:quantity])
          package.width   = book_width  if package.width < book_width
          package.length  = book_length if package.length < book_length
          package.height += calculate_book_height(book_pages)
        end

        #TODO: it doesn't consider promotions.
        package.declared_value += (data[:quantity] * book_price)
      end

      package
    end

  # frete = ::Correios::Frete::Calculador.new cep_origem: "04094-050",
  #                                       cep_destino: cpf.gsub(/\.|\-/, ''),
  #                                       peso: 1.1,
  #                                       comprimento: 30,
  #                                       largura: 15,
  #                                       altura: 2
  private
    def self.calculate_book_height(pages)
      pages * 90 / 14400
    end
end

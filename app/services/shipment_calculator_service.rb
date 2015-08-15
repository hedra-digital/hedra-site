require 'correios-frete'

Package = Struct.new(:weight, :width, :length, :height, :declared_value)
DEFAULT_BOOK_WEIGHT = 0.3 #kg
DEFAULT_BOOK_WIDTH  = 12  #cm
DEFAULT_BOOK_LENGTH = 25  #cm
DEFAULT_BOOK_PAGES  = 100
DEFAULT_BOOK_PRICE  = 28.71 #reales


DEFAULT_PACKAGE_WIDTH   = 16 #cm
DEFAULT_PACKAGE_HEIGHT  =  2 #cm


PRINT_BOOK_TYPE     = :print
DEFAULT_ORIGIN_CEP  = "05416-011"

SUCCESS_CORREIOS_RESPONSE = "0"

class ShipmentCalculatorService
  def self.execute(hashed_books, destination_cep, choose_type=nil)
    return {} unless destination_cep

    package = calculate_rough_package_size(hashed_books)

    return nil unless package #is nil when there aren't printed books.

    frete = ::Correios::Frete::Calculador.new cep_origem: DEFAULT_ORIGIN_CEP,
                                        cep_destino: destination_cep,
                                        peso: package.weight,
                                        comprimento: package.width,
                                        largura: package.length,
                                        altura: package.height,
                                        valor_declarado: package.declared_value

    if choose_type
      shipment_service = frete.calcular choose_type.to_sym
      shipment_info = [[choose_type, { cost: shipment_service.valor, shipping_time: shipment_service.prazo_entrega } ]]
    else
      #TODO: check the errors.
      shipment_services_values = []

      begin
        shipment_services_values = frete.calcular(:pac, :sedex)
      rescue
        return nil
      end

      shipment_info = shipment_services_values.map do |service_key, service_value|
        return nil unless service_value.erro == SUCCESS_CORREIOS_RESPONSE
        [service_key, { cost: service_value.valor, shipping_time: service_value.prazo_entrega } ]
      end
    end

    Hash[shipment_info]
  end

  private
    def self.calculate_rough_package_size(hashed_books)
      package = nil

      hashed_books.each do |data|
        next if data[:book_type] != PRINT_BOOK_TYPE
        package ||= Package.new(0, DEFAULT_PACKAGE_WIDTH, 0, DEFAULT_PACKAGE_HEIGHT, 0)

        book = Book.find(data[:book_id])

        book_weight = book.weight       || DEFAULT_BOOK_WEIGHT
        book_width  = book.width        || DEFAULT_BOOK_WIDTH
        book_length = book.height       || DEFAULT_BOOK_LENGTH # the book.height means length
        book_pages  = book.pages        || DEFAULT_BOOK_PAGES
        book_price  = book.price_print  || DEFAULT_BOOK_PRICE

        package.weight += (book_weight * data[:quantity])
        package.width   = book_width  if package.width < book_width
        package.length  = book_length if package.length < book_length
        package.height += (calculate_book_height(book_pages) * data[:quantity])

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

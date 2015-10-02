require 'correios-frete'

Package = Struct.new(:weight, :width, :length, :height, :declared_value) #Weight on kilograms
DEFAULT_BOOK_WEIGHT = 0.3 #kg
DEFAULT_BOOK_WIDTH  = 12  #cm
DEFAULT_BOOK_LENGTH = 25  #cm
DEFAULT_BOOK_PAGES  = 100
DEFAULT_BOOK_PRICE  = 28.71 #reales


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

    if choose_type and choose_type.to_sym == :modico
      shipment_info = [[choose_type, { cost: ModicoTablePrices.for(package.weight * 1000), shipping_time: 15 } ]]
    elsif choose_type
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
      shipment_info.unshift [:modico, { cost: ModicoTablePrices.for(package.weight * 1_000), shipping_time: 15 }]
    end

    Hash[shipment_info]
  end

  private
    def self.calculate_rough_package_size(hashed_books)
      package = Package.new(0, 0, 0, 0, 0)

      hashed_books.each do |data|
        next unless data[:book_type] == PRINT_BOOK_TYPE

        book = Book.find(data[:book_id])

        package.weight          += (book.weight   || DEFAULT_BOOK_WEIGHT)                  * data[:quantity]
        package.width            = (book.width    || DEFAULT_BOOK_WIDTH)  if package.width.nil?  || (book.width    || DEFAULT_BOOK_WIDTH)  > package.width
        package.length           = (book.length   || DEFAULT_BOOK_LENGTH) if package.length.nil? || (book.length   || DEFAULT_BOOK_LENGTH) > package.length

        package.height          += (book.height   || calculate_book_height(book.pages || DEFAULT_BOOK_PAGES))   * data[:quantity]

        package.declared_value  += (book.price_print  || DEFAULT_BOOK_PRICE)               * data[:quantity] #TODO: it doesn't consider promotions.
      end

      package.height  = 2  if package.height < 2
      package.width   = 16 if package.width < 16
      package.length  = 11 if package.length < 11

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

module ModicoTablePrices
  def self.for(weight_on_grams)
    case weight_on_grams
    when 0..20
      0.85
    when 20..50
      1.30
    when 50..100
      1.75
    when 100..150
      2.15
    when 150..200
      2.50
    when 200..250
      2.90
    when 250..300
      3.30
    when 300..350
      3.70
    when 350..400
      4.10
    when 400..450
      4.50
    when 450..500
      4.90
    when 500..550
      5.20
    when 550..600
      5.60
    when 600..650
      5.95
    when 650..700
      6.25
    when 700..750
      6.60
    when 750..800
      6.95
    when 800..850
      7.30
    when 850..900
      7.70
    when 900..950
      8.05
    when 950..1000
      8.40
    else
      return 8.40 if weight_on_grams < 0
      return 8.40 + (weight_on_grams - 1000) / 1000 * 8.40 #Charge 8.4, for every additional kilogram
    end
  end
end

# encoding: utf-8

module BooksHelper

  def book_team(book)
    book.participations.inject({}) do |result, element|
      result[element.role.name] ||= []
      result[element.role.name] << element.person.name
      result
    end
  end

  def book_stats(book)
    [
      ['Número de páginas', book.pages],
      ['ISBN', book.isbn],
      ['Idiomas', book.language_list],
      ['Encadernação', book.binding_name],
      ['Dimensões', book.dimensions],
      ['Peso', book.weight_with_unit],
      ['Ano de lançamento', book.release_year]
    ].inject([]) { |sum, obj| obj[1].nil? ? sum : sum << stats_item(obj[0], obj[1]) }.join.html_safe
  end

  def list_price(book)
    render :partial => 'books/list_price', :locals => { :book => book } if book.has_price?
  end

  def description_lead(book)
    raw(book.description.split('</p>')[0] + '</p>')
  end

  def book_buttons(book)
    if book.price_print?
      content_tag :li do
        link_to add_to_cart_path(book), :method => :post, :class => 'btn btn-primary' do
          concat content_tag(:span, 'Livro', :class => 'type')
          concat content_tag(:span, number_to_currency(book.price_print), :class => 'price')
        end
      end
    end
  end

  private

  def stats_item(title, data)
    render :partial => 'stats_item', :locals => { :title => title, :data => data }
  end

end

# encoding: utf-8

module BooksHelper

  def book_team(book)
    book.participations.inject({}) do |result, element|
      result[element.role.name] ||= []
      result[element.role.name] << element.person.name
      result
    end
  end

  def book_supplementary_info(book)
    tags = ""
    tags = tags << content_tag(:dt, 'Número de páginas')
    tags = tags << content_tag(:dd, book.pages)
    tags = tags << content_tag(:dt, 'ISBN')
    tags = tags << content_tag(:dd, book.isbn)
    if book.languages.present? && book.languages.count > 1
      tags = tags << content_tag(:dt, 'Idiomas')
      tags = tags << content_tag(:dd, book.languages.map { |x| x.name.downcase }.join(", ").capitalize)
    end
    if book.binding_type.present?
      tags = tags << content_tag(:dt, 'Encadernação')
      tags = tags << content_tag(:dd, book.binding_type.name)
    end
    if book.width.present? && book.height.present?
      tags = tags << content_tag(:dt, 'Dimensões')
      tags = tags << content_tag(:dd, "#{book.width} &times; #{book.height} cm".html_safe)
    end
    if book.weight.present?
      tags = tags << content_tag(:dt, 'Peso')
      tags = tags << content_tag(:dd, book.weight)
    end
    if book.released_at.present?
      tags = tags << content_tag(:dt, 'Ano de lançamento')
      tags = tags << content_tag(:dd, book.released_at.year)
    end
    tags.html_safe
  end

end

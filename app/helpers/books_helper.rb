# encoding: utf-8

module BooksHelper

  def book_team(book)
    parts = book.participations.map { |e| [e.role.name, e.person.name] }
    parts
  end

  def book_authors(book)
    authors = book_team(book).select { |role, person| role == 'Autor' }.map { |role, person| person }
    return authors.join(', ')
  end

  def book_supplementary_info(book)
    urls = ""
    urls = urls << content_tag(:dt, 'Número de páginas')
    urls = urls << content_tag(:dd, book.pages)
    if book.languages.present? && book.languages.count > 1
      urls = urls << content_tag(:dt, 'Idiomas')
      urls = urls << content_tag(:dd, book.languages.map { |x| x.name.downcase }.join(", ").capitalize)
    end
    if book.binding_type.present?
      urls = urls << content_tag(:dt, 'Encadernação')
      urls = urls << content_tag(:dd, book.binding_type.name)
    end
    if book.width.present? && book.height.present?
      urls = urls << content_tag(:dt, 'Dimensões')
      urls = urls << content_tag(:dd, "#{book.width} &times; #{book.height} cm".html_safe)
    end
    if book.weight.present?
      urls = urls << content_tag(:dt, 'Peso')
      urls = urls << content_tag(:dd, book.weight)
    end
    if book.released_at.present?
      urls = urls << content_tag(:dt, 'Ano de lançamento')
      urls = urls << content_tag(:dd, book.released_at.year)
    end
    urls.html_safe
  end

end

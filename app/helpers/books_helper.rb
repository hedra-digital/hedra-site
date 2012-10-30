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

end

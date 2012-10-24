# encoding: utf-8

ActiveAdmin::Dashboards.build do
  section "Últimos livros" do
    table_for Book.order("created_at desc").limit(5) do
      column :title do |book|
        link_to book.title, admin_book_path(book)
      end
      column :created_at
    end
    strong { link_to "Ver todos os livros", admin_books_path }
  end
end
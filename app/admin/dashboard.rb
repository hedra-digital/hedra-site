# encoding: utf-8

ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    panel "Últimos livros cadastrados" do
      table_for Book.order("created_at desc").limit(5) do
        column :title do |book|
          link_to book.title, admin_book_path(book)
        end
        column :created_at
      end
      strong { link_to "Ver todos os livros", admin_books_path }
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end

  end # content
end

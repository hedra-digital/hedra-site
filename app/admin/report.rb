ActiveAdmin.register_page "Book Report" do
  menu :parent => "Report"

  controller do
    def index
      if params[:search]
        start_date = Date.parse(params[:search][:start_date]) unless params[:search][:start_date].blank?
        end_date = (Date.parse(params[:search][:end_date]) + 1.day) unless params[:search][:end_date].blank?
        title = params[:search][:title]
      end

      @books = Book.select("books.id, books.title, books.slug, count(books.id) as sold_count, sum(order_items.price) as total_price").
        joins(:order_items => [:order => :transactions]).
        where("transactions.status = 2").
        where(start_date ? ("transactions.created_at > '#{start_date}'") : "").
        where(end_date ? ("transactions.created_at < '#{end_date}'") : "").
        where(title.blank? ? "" : "books.title LIKE '%#{title}%'").
        group("books.id").
        order("count(books.id) desc")

      @total_sold_count = 0
      @total_amount = 0

      #TODO: cambiar por inject
      @books.each do |b|
        @total_sold_count += b.sold_count
        @total_amount += b.total_price
      end
    end
  end

  content do
    div class: 'panel_contents' do
      active_admin_form_for :search do |f|
        f.inputs "Search" do
          f.input :start_date, :as => :datepicker, :required => false
          f.input :end_date, :as => :datepicker, :required => false
          f.input :title, :required => false
        end
        f.actions
      end
    end


    div class: 'panel' do
      h3 "Sale Report, SOLD COUNT #{total_sold_count}, TOTAL PRICE #{number_to_currency(total_amount)}"
      div class: 'panel_contents' do

        paginated_collection books.per_page_kaminari(params[:page]).per(50) do
          table_for collection do
            column "title" do |book|
              link_to book.title, book_path(book)
            end
            column "sold count" do |book|
              book.sold_count
            end
            column "total price" do |book|
              number_to_currency(book.total_price)
            end
          end
        end

      end
    end

  end
end

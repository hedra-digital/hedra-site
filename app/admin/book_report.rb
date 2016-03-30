ActiveAdmin.register_page "Book Report" do
  menu :parent => "Report"

  controller do
    def index
      @search = Struct.new(:start_date, :end_date, :title, :campaign_name).new

      if params[:search]
        @search.start_date    = Date.parse(params[:search][:start_date])          unless params[:search][:start_date].blank?
        @search.end_date      = (Date.parse(params[:search][:end_date]) + 1.day)  unless params[:search][:end_date].blank?
        @search.title         = params[:search][:title]
        @search.campaign_name = params[:search][:campaign_name]
      end

      @books = Book.for_book_report(@search.start_date, @search.end_date, @search.title, @search.campaign_name)

      @total_sold_count = 0
      @total_amount = 0

      @books.each do |b|
        @total_sold_count += b.sold_count
        @total_amount     += b.total_price
      end
    end
  end

  content do
    div class: 'panel_contents' do
      active_admin_form_for :search, method: :get do |f|
        f.inputs "Search" do
          f.input :start_date, required: false, as: :datepicker
          f.input :end_date,   required: false, as: :datepicker
          f.input :title,      required: false
          f.input :campaign_name, as: :select, collection: Promotion.pluck(:name).uniq.reject(&:blank?)
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

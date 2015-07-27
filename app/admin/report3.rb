ActiveAdmin.register_page "Transaction Report" do
  menu :parent => "Report"

  controller do
    def index
      @search = Struct.new(:start_date, :end_date, :title).new

      if params[:search]
        @search.start_date = Date.parse(params[:search][:start_date]) unless params[:search][:start_date].blank?
        @search.end_date = (Date.parse(params[:search][:end_date]) + 1.day) unless params[:search][:end_date].blank?
        @search.title = params[:search][:title]
      end

      @books = Book.for_transaction_report(@search.start_date, @search.end_date, @search.title)

      @total_created_count    = 0
      @total_completed_count  = 0
      @total_failed_count     = 0

      @books.each do |b|
        @total_created_count   += b.created_count
        @total_completed_count += b.completed_count
        @total_failed_count    += b.failed_count
      end
    end
  end

  content do
    div class: 'panel_contents' do
      active_admin_form_for :search, method: :get  do |f|
        f.inputs "Search" do
          f.input :start_date, :as => :datepicker, :required => false
          f.input :end_date, :as => :datepicker, :required => false
          f.input :title, :required => false
        end
        f.actions
      end
    end


    div class: 'panel' do
      h3 "Sale Report, CREATED COUNT #{total_created_count.to_i}, COMPLETED COUNT #{total_completed_count.to_i}, FAILED COUNT #{total_failed_count.to_i}"
      div class: 'panel_contents' do

        paginated_collection books.per_page_kaminari(params[:page]).per(50) do
          table_for collection do
            column "title" do |book|
              link_to book.title, book_path(book)
            end
            column "created count" do |book|
              book.created_count.to_i
            end
            column "completed count" do |book|
              book.completed_count.to_i
            end
            column "failed count" do |book|
              book.failed_count.to_i
            end
          end
        end

      end
    end

  end
end

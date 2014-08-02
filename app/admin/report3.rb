ActiveAdmin.register_page "Transaction Report" do
  menu :parent => "Report"

  controller do
    def index

	    if params[:search]
	      start_date = Date.parse(params[:search][:start_date]) unless params[:search][:start_date].blank?
	      end_date = (Date.parse(params[:search][:end_date]) + 1.day) unless params[:search][:end_date].blank?
	      title = params[:search][:title]
	    end

	    @books = Book.select("books.id, books.title, books.slug,
	     sum(if(transactions.status = 1, 1, 0)) as created_count, 
	     sum(if(transactions.status = 2, 1, 0)) as completed_count,
	     sum(if(transactions.status = 3, 1, 0)) as failed_count").
		    joins(:order_items => [:order => :transactions]).
		    where(start_date ? ("transactions.updated_at > '#{start_date}'") : "").
		    where(end_date ? ("transactions.updated_at < '#{end_date}'") : "").
		    where(title.blank? ? "" : "books.title LIKE '%#{title}%'").
		    group("books.id").
		    order("completed_count desc")

      @total_created_count = 0
      @total_completed_count = 0
      @total_failed_count = 0

      @books.each do |b|
      	@total_created_count += b.created_count
      	@total_completed_count += b.completed_count
      	@total_failed_count += b.failed_count
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
		  h3 "Sale Report, CREATED COUNT #{total_created_count.to_i}, COMPLETED COUNT #{total_completed_count.to_i}, FAILED COUNT #{total_failed_count.to_i}"
		  div class: 'panel_contents' do

				table_for books do
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


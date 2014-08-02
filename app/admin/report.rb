ActiveAdmin.register_page "Report" do

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
		    where(start_date ? ("transactions.updated_at > '#{start_date}'") : "").
		    where(end_date ? ("transactions.updated_at < '#{end_date}'") : "").
		    where(title.blank? ? "" : "books.title LIKE '%#{title}%'").
		    group("books.id").
		    order("count(books.id) desc")

      @total_sold_count = 0
      @total_amount = 0

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

				table_for books do
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



ActiveAdmin.register_page "Report2" do

  controller do
    def index

	    if params[:search]
	      start_date = Date.parse(params[:search][:start_date]) unless params[:search][:start_date].blank?
	      end_date = (Date.parse(params[:search][:end_date]) + 1.day) unless params[:search][:end_date].blank?
	      user_name = params[:search][:user_name]
	      user_email = params[:search][:user_email]
	    end

		  @transactions = Transaction.joins(:user).joins(:order).
		    where(start_date ? ("transactions.updated_at > '#{start_date}'") : "").
		    where(end_date ? ("transactions.updated_at < '#{end_date}'") : "").
		    where(user_name.blank? ? "" : "users.name like '%#{user_name}%'").
		    where(user_email.blank? ? "" : "users.email like '%#{user_email}%'").
		    order("transactions.user_id, transactions.updated_at")
    end
  end

  content do
    div class: 'panel_contents' do
		  active_admin_form_for :search do |f|
		    f.inputs "Search" do
		      f.input :start_date, :as => :datepicker, :required => false
		      f.input :end_date, :as => :datepicker, :required => false
		      f.input :user_name, :required => false
		      f.input :user_email, :required => false
		    end
		    f.actions
		  end
		end


		div class: 'panel' do
		  h3 'Buying Report'
		  div class: 'panel_contents' do

				table_for transactions do
				  column "user" do |t|
				    "#{t.user.name}"
				  end
				  column "email" do |t|
				    "#{t.user.email}"
				  end
				  column "amount" do |t|
				    number_to_currency(t.order.total)
				  end
				  column "date" do |t|
				    t.updated_at
				  end
				  column "status" do |t|
				    case t.status
				    when 1
		  		    status_tag('warn', :label => 'CREATED')
				    when 2
		  		    status_tag('ok', :label => 'COMPLETED')
				    when 3
		  		    status_tag('error', :label => 'FAILED')
				    end
				  end
				end

		  end
		end

  end
end



ActiveAdmin.register_page "Report3" do

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



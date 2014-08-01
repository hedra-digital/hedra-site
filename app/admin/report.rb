ActiveAdmin.register_page "Report" do

  controller do
    def index

	    if params[:search]
	      start_date = Date.parse(params[:search][:start_date]) unless params[:search][:start_date].blank?
	      end_date = (Date.parse(params[:search][:end_date]) + 1.day) unless params[:search][:end_date].blank?
	      title = params[:search][:title]
	    end

	    @books = Book.select("books.id, books.title, books.slug, count(books.id) as sell_count, sum(order_items.price) as total_price").
		    joins(:order_items => [:order => :transactions]).
		    where("transactions.status = 2").
		    where(start_date ? ("transactions.updated_at > '#{start_date}'") : "").
		    where(end_date ? ("transactions.updated_at < '#{end_date}'") : "").
		    where(title.blank? ? "" : "books.title LIKE '%#{title}%'").
		    group("books.id").
		    order("count(books.id) desc")
    end
  end

  content do
    render "index"
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
    render "index"
  end
end





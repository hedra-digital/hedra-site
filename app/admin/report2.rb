
ActiveAdmin.register_page "Buying Report" do
  menu :parent => "Report"

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


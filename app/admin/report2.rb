
ActiveAdmin.register_page "Buying Report" do
  menu :parent => "Report"

  controller do
    def index
      @search = Struct.new(:start_date, :end_date, :user_name, :user_email).new

      if params[:search]
        @search.start_date = Date.parse(params[:search][:start_date]) unless params[:search][:start_date].blank?
        @search.end_date = (Date.parse(params[:search][:end_date]) + 1.day) unless params[:search][:end_date].blank?
        @search.user_name = params[:search][:user_name]
        @search.user_email = params[:search][:user_email]
      end

      @transactions = Transaction.for_buying_report(@search.start_date, @search.end_date, @search.user_name, @search.user_email)
    end
  end

  content do
    div class: 'panel_contents' do
      active_admin_form_for :search, method: :get do |f|
        f.inputs "Search" do
          f.input :start_date,  :required => false, :as => :datepicker
          f.input :end_date,    :required => false, :as => :datepicker
          f.input :user_name,   :required => false
          f.input :user_email,  :required => false
        end
        f.actions
      end
    end


    div class: 'panel' do
      h3 'Buying Report'
      div class: 'panel_contents' do

        paginated_collection transactions.page(1, 10) do
          table_for collection do
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
              t.created_at
            end
            column "payment_method" do |t|
              t.payment_method
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
end

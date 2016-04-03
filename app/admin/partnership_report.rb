ActiveAdmin.register_page "Partnership Report" do
  
  menu :parent => "Report"
  
  controller do
    def index
      @promotion = Promotion.joins(:partner, :orders).group("promotions.id")
      search params[:search]
    end

    private
    def search(params)
      return if params.nil?
      @search = Struct.new(:start_date, :end_date, :partner_name, :partner_email).new
      @search.start_date = parse_date params[:start_date] if params[:start_date].present?
      @search.end_date = parse_date(params[:end_date])    if params[:end_date].present?
      
      if @search.start_date.present? && @search.end_date.present?
        @promotion = @promotion.where(
          " orders.completed_at between ? and ? ", @search.start_date, (@search.end_date + 1.day)
        )
      elsif @search.start_date.present?
        @promotion = @promotion.where(" orders.completed_at >= ? ", @search.start_date)
      elsif @search.end_date.present?
        @promotion = @promotion.where(" orders.completed_at <= ? ", @search.end_date + 1.day)
      end

      if @search.partner_name = params[:partner_name].presence
        @promotion = @promotion.where(" partners.name like ? ", "%#{@search.partner_name}%")
      end 

      if @search.partner_email = params[:partner_email].presence
        @promotion = @promotion.where(" partners.email like ? ", "%#{@search.partner_email}%")
      end
    end

    def parse_date(date)
      DateTime.parse("#{date} 00:00:00")
    end
  end
  
  content do
    div do
      active_admin_form_for :search, method: :get do |f|
        f.inputs "Search" do
          f.input :start_date,  :required => false, :as => :datepicker
          f.input :end_date,    :required => false, :as => :datepicker
          f.input :partner_name,   :required => false
          f.input :partner_email,  :required => false
        end
        f.actions
      end
    end

    div class: 'panel' do
      h3 'Partnership Report'
      div class: 'panel_contents' do

        paginated_collection promotion.per_page_kaminari(params[:page]).per(50) do
          table_for collection do
            
            column "Name" do |promotion|
              promotion.partner.name
            end
            column "Email" do |promotion|
              promotion.partner.email
            end
            column "Promotion" do |promotion|
              promotion.name
            end

            column "Comission" do |promotion|
              promotion.partner.comission
            end

            column "Order Revenue" do |promotion|
              promotion.orders.completed.map{ |order| 
                order.order_items.inject(0){ |_, order| order.price * order.quantity}
              }.inject(&:+)
            end

            column "Comission Due" do |promotion|
              promotion.orders.completed.map{ |order| 
                order.order_items.inject(0){ |_, order| 
                  order.price * order.quantity * promotion.partner.comission}
              }.inject(&:+)
            end
          end
        end
      end
    end
  end
end

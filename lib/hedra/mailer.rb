module Hedra
  class Mailer < ActionMailer::Base
    def send_notification(params={})
      @order = Order.where(:id => params[:order_id]).includes([:order_items => :book]).first

      publisher = @order.order_items.first.book.publisher
      
      mail(:from => "#{publisher.name}<#{publisher.contact_email}>", :to => params[:to], :subject => params[:subject],
        :template_path => params[:template_path],
        :template_name => params[:template_name],
        :bcc => params[:bcc])
    end
  end
end

# -*- encoding : utf-8 -*-
module Hedra
  class Mailer < ActionMailer::Base
    default :from => "Editora Hedra<services@hedra.com.br>"

    def send_notification(params={})
      @order = Order.where(:id => params[:order_id]).includes([:order_items => :book]).first
      mail(:to => params[:to], :subject => params[:subject],
        :template_path => params[:template_path],
        :template_name => params[:template_name],
        :bcc => params[:bcc])
    end
  end
end

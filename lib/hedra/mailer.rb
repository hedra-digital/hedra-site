# -*- encoding : utf-8 -*-
module Hedra
  class Mailer < ActionMailer::Base
    default :from => "Editora Hedra<services@hedra.com.br>"

    def send_notification(params={})
      mail(:to => params[:to], :subject => params[:subject],
        :template_path => params[:template_path],
        :template_name => params[:template_name],
        :cc => params[:cc], :order => params[:order])
    end
  end
end

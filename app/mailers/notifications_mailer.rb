# -*- encoding : utf-8 -*-
class NotificationsMailer < ActionMailer::Base
  default :from => "editora@hedra.com.br"
  default :to => "editora@hedra.com.br"

  def new_message(message, publisher_id)
    @message = message
    if publisher_id.nil?
    	mail(:subject => "[Site Hedra - Contato] #{message.subject}", :bcc => "fabricio@vizir.com.br, jorge@hedra.com.br, fellipe@vizir.com.br")
    else
    	mail(:to => Publisher.find(publisher_id).contact_email, :subject => "[Site Hedra - Contato] #{message.subject}", :bcc => "fabricio@vizir.com.br, jorge@hedra.com.br, fellipe@vizir.com.br")	
    end
  end
end

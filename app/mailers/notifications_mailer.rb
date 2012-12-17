class NotificationsMailer < ActionMailer::Base
  default :from => "editora@hedra.com.br"
  default :to => "editora@hedra.com.br"

  def new_message(message)
    @message = message
    mail(:subject => "[Site Hedra - Contato] #{message.subject}")
  end
end

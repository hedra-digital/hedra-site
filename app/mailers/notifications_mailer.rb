class NotificationsMailer < ActionMailer::Base
  default :from => "editora@hedra.com.br"
  default :to => "marcelo.polli@gmail.com"

  def new_message(message)
    @message = message
    mail(:subject => "[Site Hedra - Contato] #{message.subject}")
  end
end

class ReportsMailer < ActionMailer::Base
  default from: "editora@hedra.com.br"

  def partnership(data)
  	return unless data[:partner_email].present?
  	@data = data
    mail(
      to: data[:partner_email], 
      subject: "Hedra - Relatório Semanal Parcerias", 
      cc: 'parceiros@hedra.com.br'
    )
  end
end



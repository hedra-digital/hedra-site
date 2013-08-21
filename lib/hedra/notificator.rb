# -*- encoding : utf-8 -*-
module Hedra
  class Notificator

    attr_accessor :transaction_id

    def initialize(transaction_id)
      self.transaction_id = transaction_id
    end

    def send
      transaction = Transaction.where(:id => transaction_id).includes([:order]).first
      case transaction.status
      when Transaction::CREATED
        subject = I18n.t('notifications.created.subject')
        template_name = 'created'
      when Transaction::COMPLETED
        subject = I18n.t('notifications.completed.subject')
        template_name = 'completed'
      when Transaction::FAILED
        subject = I18n.t('notifications.failed.subject')
        template_name = 'failed'
      end
      Mailer.send_notification(:to => transaction.order.email, :subject => subject, :template_path => 'notifications/checkout',
        :template_name => template_name, :order_id => transaction.order_id,
        :bcc => 'fabricio@vizir.com.br, fabio@hedra.com.br').deliver
    end

  end
end
# -*- encoding : utf-8 -*-
class MailWorker
  include Sidekiq::Worker

  def perform(transaction_id=nil)
    Hedra::Notificator.new(transaction_id).send
  end

end

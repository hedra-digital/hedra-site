class Transaction < ActiveRecord::Base
  attr_accessible :user, :order, :user_ip, :paypal_token, :paypal_payer_id, :completed, :paypal_transaction_id, :paypal_payment_date, :paypal_fee_amount, :paypal_pending_reason, :paypal_reason_code, :status

end

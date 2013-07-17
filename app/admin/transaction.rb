ActiveAdmin.register Transaction do
  menu :parent => "eCommerce"
  scope :completed, :default => true
  scope :created
  scope :failed

  index do                            
    column :user
    column :user_ip
    column :order
    column :completed
    column :status
    column :paypal_payer_id
    column :paypal_fee_amount
    default_actions                   
  end                                 
end

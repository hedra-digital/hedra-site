# -*- encoding : utf-8 -*-
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
    column :payment_method
    column :created_at
    default_actions                   
  end                                 
end

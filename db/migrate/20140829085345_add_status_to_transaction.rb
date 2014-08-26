class AddStatusToTransaction < ActiveRecord::Migration
  def change
  	add_column :transactions, :payment_method, :string
  	add_column :transactions, :payment_status, :string

  	Transaction.reset_column_information
    Transaction.all.each do |t|
      t.update_attribute(:payment_method, "paypal")
    end

  end
end

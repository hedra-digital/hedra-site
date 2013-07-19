class AddCustomerIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :customer_ip, :string
  end
end

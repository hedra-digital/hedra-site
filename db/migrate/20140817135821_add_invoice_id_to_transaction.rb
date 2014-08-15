class AddInvoiceIdToTransaction < ActiveRecord::Migration
  def change
  	add_column :transactions, :invoice_id, :string
  end
end

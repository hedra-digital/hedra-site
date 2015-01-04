class AddBankSlipUrlToTransaction < ActiveRecord::Migration
  def change
  	add_column :transactions, :bank_slip_url, :string
  end
end

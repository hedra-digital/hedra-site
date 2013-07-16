class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user
      t.references :order
      t.string :user_ip
      t.string :paypal_token
      t.string :paypal_payer_id
      t.boolean :completed
      t.string :paypal_transaction_id
      t.date :paypal_payment_date
      t.float :paypal_fee_amount
      t.string :paypal_pending_reason
      t.string :paypal_reason_code
      t.integer :status

      t.timestamps
    end
    add_index :transactions, :user_id
    add_index :transactions, :order_id
  end
end

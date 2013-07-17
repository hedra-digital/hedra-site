# -*- encoding : utf-8 -*-
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal    :item_total,                         :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal    :total,                              :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.integer     :state
      t.datetime   :completed_at
      t.integer     :shipment_state
      t.integer     :payment_state
      t.string     :email
      t.text       :special_instructions
      t.references :user
      t.references :address
      t.timestamps
    end
  end
end

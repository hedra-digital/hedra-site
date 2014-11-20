class UpdateBooktypeInOrderItem < ActiveRecord::Migration
  def change
  	OrderItem.all.each do |i|
      i.update_attribute(:book_type, "print") if i.book_type.blank?
    end
  end
end

class FillPassedCompletedAtOrderField < ActiveRecord::Migration
  def up
  	Transaction.completed.find_each do |transaction| 
  	  if transaction.order.completed_at.blank?
  	    transaction.order.update_attributes(completed_at: transaction.created_at) 
  	  end
  	end
  end

  def down
  end
end

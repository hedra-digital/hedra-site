class Partner < ActiveRecord::Base
   attr_accessible :name, :email, :comission

   def sym_attributes
     attributes.symbolize_keys!
   end
end

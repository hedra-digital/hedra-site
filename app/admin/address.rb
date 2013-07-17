ActiveAdmin.register Address do     
  menu :parent => "eCommerce"
  index do                            
    column :user
    column :zip_code
    column :address
    column :number
    column :complement
    column :district
    column :city
    column :state
    column :country
    default_actions                   
  end                                 
end   
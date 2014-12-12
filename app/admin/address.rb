# -*- encoding : utf-8 -*-
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

  csv do
    column :id
    column ("user") {|a| a.user.name}
    column ("email") {|a| a.user.email}
    column :zip_code
    column :address
    column :number
    column :complement
    column :district
    column :city
    column :state
    column :country
  end                             
end   

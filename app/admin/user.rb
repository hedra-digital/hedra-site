ActiveAdmin.register User do     
  menu :parent => "eCommerce"
  index do                            
    column :username
    column :name
    column :email                     
    column :current_sign_in_at        
    column :last_sign_in_at           
    column :sign_in_count             
    default_actions                   
  end                                 

  filter :email
  filter :name
  filter :username

  form do |f|                         
    f.inputs "User Details" do       
      f.input :username
      f.input :name
      f.input :email                  
      f.input :password               
      f.input :password_confirmation  
    end                               
    f.buttons                         
  end                                 
end                                   

# -*- encoding : utf-8 -*-
ActiveAdmin.register Order do
  menu :parent => "eCommerce"

  show do
    panel "Itens" do
      table_for(order.order_items) do |t|
        t.column("Livro") {|item| auto_link item.book }
        t.column("Quantidade") {|item| item.quantity }
        t.column("Preco Unitario") {|item| number_to_currency item.price }
        t.column("Preco Total") {|item| number_to_currency item.price * item.quantity }
        tr :class => "odd" do
          td :style => "text-align: center;", :colspan => 3 do
            strong do
              "Total"
            end
          end
          td do
            strong do
              number_to_currency(order.total)
            end
          end
        end
      end
    end
    active_admin_comments
  end

  sidebar :order_status, :only => :show do
    attributes_table_for order do
      row("state") {order.state_to_s}
    end
  end

  sidebar :customer_information, :only => :show do
    attributes_table_for order.user do
      row("User") { auto_link order.user }
      row :name
      row :email
    end
  end

  sidebar :shipping_address, :only => :show do
    attributes_table_for order.address do
      row :address
      row :city
      row :complement
      row :district
      row :number
      row :state
      row :zip_code
    end
  end

end

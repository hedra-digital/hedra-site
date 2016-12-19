require 'zip'

ActiveAdmin.register Order do
  menu :parent => "eCommerce"

  actions :all, :except => [:destroy]

  scope :completed, :default => true do |order|
    order.joins(:transactions).where("transactions.status = ?", Transaction::COMPLETED).reorder("transactions.updated_at desc")
  end

  scope :created do |order|
    order.joins(:transactions).where("transactions.status = ?", Transaction::CREATED).reorder("transactions.updated_at desc")
  end

  scope :failed do |order|
    order.joins(:transactions).where("transactions.status = ?", Transaction::FAILED).reorder("transactions.updated_at desc")
  end


  index do   
    selectable_column                        
    column :id, :sortable => false
    column "User" do |o|
      o.user.email
    end
    column "Name" do |o|
      o.user.name
    end
    column "Amount" do |o|
      number_to_currency o.total
    end
    column "Payment method" do |o|
      o.transactions.last.payment_method
    end
    column :post_tracking_code, :sortable => false
    column "Created at" do |o|
      o.created_at
    end
    column "Paid at" do |o|
      o.transactions.last.updated_at if o.transactions.last.status == Transaction::COMPLETED
    end
    default_actions                   
  end 

  batch_action :labels , if: proc { @current_scope.id == "completed" } do |selection|
    folder_name = SecureRandom.uuid
    Dir.mkdir "tmp/#{folder_name}"
    books_txt = File.open(Rails.root.join("tmp", folder_name, "books.txt"), "w+")
    uniq_books_txt = File.open(Rails.root.join("tmp", folder_name, "uniq_books.txt"), "w+")

    # books_txt
    Order.find(selection).each do |order|
      books_txt.puts("")
      books_txt.puts("")
      books_txt.puts("#{order.user.name} [#{order.id}]")
      books_txt.puts("")
      books_txt.puts("#{order.address.address}, #{order.address.number}, #{order.address.complement}")
      books_txt.puts("#{order.address.city}, #{order.address.state}, #{order.address.zip_code}")
      books_txt.puts("")

      order.order_items.each do |item|
        books_txt.puts("[#{item.quantity}X]  #{item.book.nil? ? "One book missed" : item.book.long_title(item.book_type.to_sym)}")
      end

      books_txt.puts("")
      books_txt.puts("")
      books_txt.puts("------------------------------------------------------------------")
    end
    books_txt.close

    # uniq_books_txt
    books = Book.select("books.id, books.title, count(books.id) as sold_count").
      joins(:order_items => [:order]).
      where("orders.id in (?)", selection).
      where("order_items.book_type != 'ebook' ").
      group("books.id").
      order("books.title")

    uniq_books_txt.puts("")
    uniq_books_txt.puts("")
    uniq_books_txt.puts("")

    books.each do |b|
      uniq_books_txt.puts("[#{b.sold_count}X] #{b.title}")
      uniq_books_txt.puts("")
    end

    uniq_books_txt.close


    # send zip file
    folder = Rails.root.join("tmp", folder_name).to_s
    zipfile_name = Rails.root.join("tmp", folder_name, "books.zip")

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      ["books.txt", "uniq_books.txt"].each do |filename|
        zipfile.add(filename, folder + '/' + filename)
      end
    end

    send_data(File.read(zipfile_name), :type => 'application/zip', :filename => "books.zip")
  end

 
  filter :id
  filter :user_email, :as => :string
  filter :user_name, :as => :string
  filter :address_zip_code, :as => :string, :label => "CEP"
  filter :post_tracking_code

  form do |f|
    f.inputs do
      f.input :post_tracking_code
    end
    f.buttons
  end


  show do
    panel "Itens" do
      table_for(order.order_items) do |t|
        t.column("Livro") {|item| item.book.nil? ? "One book missed" : auto_link(item.book, item.book.long_title(item.book_type.to_sym)) }
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
    attributes_table_for order do
      row :cpf_cnpj
      row :telephone
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

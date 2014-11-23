class AddCpfToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :cpf_cnpj, :string
  end
end

class AddTaxNumberToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :tax_number, :string
  end
end

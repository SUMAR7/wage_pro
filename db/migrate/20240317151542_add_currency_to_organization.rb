class AddCurrencyToOrganization < ActiveRecord::Migration[7.1]
  def change
    add_column :organizations, :currency, :string, default: 'USD'
  end
end

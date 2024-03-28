class AddBankDetailsToUserProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :user_profiles, :bank_name, :string
    add_column :user_profiles, :bank_account_number, :string
    add_column :user_profiles, :bank_account_name, :string
  end
end

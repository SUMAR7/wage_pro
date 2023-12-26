class AddAdminUserToOrganization < ActiveRecord::Migration[7.1]
  def change
    add_reference :organizations, :admin_user, foreign_key: { to_table: :users }, null: false
  end
end

class AddSalaryDistributionDateToOrganization < ActiveRecord::Migration[7.1]
  def change
    add_column :organizations, :salary_distribution_day, :integer, default: 1, null: false
    add_column :organizations, :salary_distribution_type, :string, default: 'monthly'
  end
end

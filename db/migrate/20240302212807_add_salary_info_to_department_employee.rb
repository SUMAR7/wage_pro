class AddSalaryInfoToDepartmentEmployee < ActiveRecord::Migration[7.1]
  def change
    add_column :department_employees, :base_salary, :bigint, default: 0
    add_column :department_employees, :tax, :bigint, default: 0
    add_column :department_employees, :other_deductions, :bigint, default: 0
    add_column :department_employees, :bonus, :bigint, default: 0
  end
end

class RolifyCreateDepartmentRoles < ActiveRecord::Migration[7.1]
  def change
    create_table(:department_roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:department_employees_department_roles, :id => false) do |t|
      t.references :department_employee
      t.references :department_role
    end
    
    add_index(:department_roles, [ :name, :resource_type, :resource_id ])
    add_index(:department_employees_department_roles, [ :department_employee_id, :department_role_id ])
  end
end

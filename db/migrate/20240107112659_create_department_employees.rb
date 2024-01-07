class CreateDepartmentEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :department_employees do |t|
      t.references :department, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :designation
      t.text :description

      t.timestamps
    end
  end
end

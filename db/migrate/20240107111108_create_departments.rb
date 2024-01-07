class CreateDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :departments do |t|
      t.string :name
      t.text :description
      t.integer :employees_count, default: 0


      t.references :organization, null: false, foreign_key: true
      t.timestamps
    end
  end
end

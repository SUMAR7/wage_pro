class CreateSalarySlips < ActiveRecord::Migration[7.1]
  def change
    create_table :salary_slips do |t|
      t.datetime :for_month
      t.datetime :issue_date
      t.bigint :basic_salary, default: 0
      t.bigint :total_deductions, default: 0
      t.bigint :total_bonus, default: 0
      t.string :currency, default: 'USD'
      t.bigint :net_salary, default: 0

      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.timestamps
    end
  end
end

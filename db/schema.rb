# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_17_151542) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "department_employees", force: :cascade do |t|
    t.bigint "department_id", null: false
    t.bigint "user_id", null: false
    t.string "designation"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "base_salary", default: 0
    t.bigint "tax", default: 0
    t.bigint "other_deductions", default: 0
    t.bigint "bonus", default: 0
    t.index ["department_id"], name: "index_department_employees_on_department_id"
    t.index ["user_id"], name: "index_department_employees_on_user_id"
  end

  create_table "department_employees_department_roles", id: false, force: :cascade do |t|
    t.bigint "department_employee_id"
    t.bigint "department_role_id"
    t.index ["department_employee_id", "department_role_id"], name: "idx_on_department_employee_id_department_role_id_0721b23dd7"
    t.index ["department_employee_id"], name: "idx_on_department_employee_id_aa11246f7b"
    t.index ["department_role_id"], name: "idx_on_department_role_id_442bab93a8"
  end

  create_table "department_roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "idx_on_name_resource_type_resource_id_717ae92bc9"
    t.index ["resource_type", "resource_id"], name: "index_department_roles_on_resource"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "employees_count", default: 0
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_departments_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "admin_user_id", null: false
    t.integer "salary_distribution_day", default: 1, null: false
    t.string "salary_distribution_type", default: "monthly"
    t.string "currency", default: "USD"
    t.index ["admin_user_id"], name: "index_organizations_on_admin_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "salary_slips", force: :cascade do |t|
    t.datetime "for_month"
    t.datetime "issue_date"
    t.bigint "basic_salary", default: 0
    t.bigint "total_deductions", default: 0
    t.bigint "total_bonus", default: 0
    t.string "currency", default: "USD"
    t.bigint "net_salary", default: 0
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_salary_slips_on_organization_id"
    t.index ["user_id"], name: "index_salary_slips_on_user_id"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.date "birthday"
    t.string "gender"
    t.text "address"
    t.string "nationality"
    t.boolean "is_local_resident", default: true
    t.string "identification_type"
    t.string "identification_number"
    t.string "phone"
    t.boolean "is_disable", default: false
    t.string "disability_description"
    t.string "alternate_email"
    t.string "alternate_phone"
    t.string "emergency_contact_name"
    t.string "emergency_contact_phone"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bank_name"
    t.string "bank_account_number"
    t.string "bank_account_name"
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "api_key"
    t.string "tax_number"
    t.index ["api_key"], name: "index_users_on_api_key", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "department_employees", "departments"
  add_foreign_key "department_employees", "users"
  add_foreign_key "departments", "organizations"
  add_foreign_key "organizations", "users", column: "admin_user_id"
  add_foreign_key "salary_slips", "organizations"
  add_foreign_key "salary_slips", "users"
  add_foreign_key "user_profiles", "users"
end

class CreateUserProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :user_profiles do |t|
      t.date :birthday
      t.string :gender

      t.text :address
      t.string :nationality
      t.boolean :is_local_resident, default: true

      t.string :identification_type
      t.string :identification_number

      t.string :phone

      t.boolean :is_disable, default: false
      t.string :disability_description

      t.string :alternate_email
      t.string :alternate_phone

      t.string :emergency_contact_name
      t.string :emergency_contact_phone

      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end

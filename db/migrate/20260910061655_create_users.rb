class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_enum :user_role, %w[member admin]

    create_table :users do |t|
      t.string :full_name, null: false
      t.string :email_address, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.enum :role, enum_type: :user_role, default: "member", null: false

      t.timestamps
    end
  end
end

class AddAvatarUrlAndImportDefaults < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :avatar_url, :string

    change_column_default :user_imports, :status, from: nil, to: "pending"
    change_column_default :user_imports, :total_rows, from: nil, to: 0
    change_column_default :user_imports, :processed_rows, from: nil, to: 0
    change_column_default :user_imports, :successful_rows, from: nil, to: 0
    change_column_default :user_imports, :failed_rows, from: nil, to: 0
    change_column_default :user_imports, :error_messages, from: nil, to: []

    reversible do |direction|
      direction.up do
        UserImport.where(status: nil).update_all(status: "pending")
        UserImport.where(total_rows: nil).update_all(total_rows: 0)
        UserImport.where(processed_rows: nil).update_all(processed_rows: 0)
        UserImport.where(successful_rows: nil).update_all(successful_rows: 0)
        UserImport.where(failed_rows: nil).update_all(failed_rows: 0)
        UserImport.where(error_messages: nil).update_all(error_messages: [])
      end
    end
  end
end

class AddSearchAndActiveImportIndexes < ActiveRecord::Migration[8.1]
  def change
    enable_extension "pg_trgm" unless extension_enabled?("pg_trgm")

    add_index :users, :full_name, using: :gin, opclass: :gin_trgm_ops,
      name: "index_users_on_full_name_trigram"
    add_index :user_imports, %i[user_id status created_at], order: { created_at: :desc },
      name: "index_user_imports_on_user_status_created_at"
  end
end

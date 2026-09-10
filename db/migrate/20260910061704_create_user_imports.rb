class CreateUserImports < ActiveRecord::Migration[8.1]
  def change
    create_table :user_imports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.integer :total_rows
      t.integer :processed_rows
      t.integer :successful_rows
      t.integer :failed_rows
      t.jsonb :error_messages

      t.timestamps
    end
  end
end

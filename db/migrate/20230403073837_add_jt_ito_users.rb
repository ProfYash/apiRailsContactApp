class AddJtItoUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :jti, :string, null: false
    add_column :customers, :full_name, :string
    add_column :customers, :is_admin, :boolean, default: false, null: false
    add_column :customers, :is_active, :boolean, default: true, null: false
    add_index :customers, :jti, unique: true
  end
end

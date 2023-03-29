class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, unique: true, null: false
      t.string :password, null: false
      t.string :full_name, null: false
      t.boolean :is_admin, default: false, null: false
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end
  end
end

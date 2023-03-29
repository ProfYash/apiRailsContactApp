class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :full_name, null: false
      t.references :user, null: false, foreign_key: true
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end
  end
end

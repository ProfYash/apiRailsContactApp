class CreateContactInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_infos do |t|
      t.string :category, null: false
      t.string :number, null: false
      t.references :contact, null: false, foreign_key: true
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end
  end
end

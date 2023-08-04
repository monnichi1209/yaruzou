class CreateFamilyLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :family_links do |t|
      t.integer :parent_id, foreign_key: { to_table: :users }
      t.integer :child_id, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

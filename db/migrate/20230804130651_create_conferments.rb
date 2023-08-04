class CreateConferments < ActiveRecord::Migration[6.1]
  def change
    create_table :conferments do |t|
      t.references :badge, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

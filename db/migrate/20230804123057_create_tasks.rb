class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.string :status
      t.date :due_on
      t.integer :user_id
      t.integer :reward

      t.timestamps
    end
  end
end

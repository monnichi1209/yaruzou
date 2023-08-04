class CreateManualVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :manual_videos do |t|
      t.integer :task_id
      t.string :title
      t.string :url, limit: 1000
      t.text :description

      t.timestamps
    end
  end
end

class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.string :library_id
      t.string :guid
      t.string :title
      t.boolean :captions, default: false

      t.timestamps
    end
  end
end

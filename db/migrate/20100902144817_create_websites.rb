class CreateWebsites < ActiveRecord::Migration
  def self.up
    create_table :websites do |t|
      t.string :url
      t.string :screenshot_file_name
      t.string :screenshot_content_type
      t.string :screenshot_file_size
      t.string :screenshot_updated_at
      t.integer :station_id
      t.text :content
      t.integer :color
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :websites
  end
end

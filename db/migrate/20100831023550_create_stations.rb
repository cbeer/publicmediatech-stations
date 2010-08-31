class CreateStations < ActiveRecord::Migration
  def self.up
    create_table :stations do |t|
      t.string :name
      t.string :call_letters
      t.string :frequency
      t.string :website
      t.string :city
      t.string :state
      t.float :lat
      t.float :long

      t.boolean :radio
      t.boolean :television

      t.string :home_file_name
      t.string :home_content_type
      t.string :home_file_size
      t.string :home_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :stations
  end
end

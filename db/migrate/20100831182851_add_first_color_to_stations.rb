class AddFirstColorToStations < ActiveRecord::Migration
  def self.up
    add_column :stations, :cached_color, :integer
  end

  def self.down
    remove_column :stations, :cached_color
  end
end

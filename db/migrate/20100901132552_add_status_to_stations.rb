class AddStatusToStations < ActiveRecord::Migration
  def self.up
    add_column :stations, :status, :integer
    add_column :stations, :primary, :boolean
    add_column :stations, :published, :boolean
  end

  def self.down
    remove_column :stations, :published
    remove_column :stations, :primary
    remove_column :stations, :status
  end
end

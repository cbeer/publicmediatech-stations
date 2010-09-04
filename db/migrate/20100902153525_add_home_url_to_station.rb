class AddHomeUrlToStation < ActiveRecord::Migration
  def self.up
    add_column :stations, :home_url, :string
  end

  def self.down
    remove_column :stations, :home_url
  end
end

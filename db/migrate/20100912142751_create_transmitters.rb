class CreateTransmitters < ActiveRecord::Migration
  def self.up
    create_table :transmitters do |t|
      t.integer :station_id
      t.float :lat
      t.float :long
      t.text :address
      t.string :frequency
      t.string :erp
      t.string :kind
      t.string :call_letters

      t.timestamps
    end
  end

  def self.down
    drop_table :transmitters
  end
end

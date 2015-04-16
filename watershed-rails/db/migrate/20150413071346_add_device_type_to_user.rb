class AddDeviceTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :device_type, :int
  end
end

class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.integer :device_id
      t.string :email
      t.text :message
      t.timestamp :last_message_time
      t.string :device_ip

      t.timestamps
    end
  end
end

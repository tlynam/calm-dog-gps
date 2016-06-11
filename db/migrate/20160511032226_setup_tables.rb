class SetupTables < ActiveRecord::Migration
  def up
    create_table 'raspberry_pis' do |t|
      t.string 'name', null: false, default: 'Raspberry Pi'
      t.boolean 'enabled', null: false, default: true
      t.integer 'volume', null: false, default: 50
      t.integer 'duration', null: false, default: 180
      t.text 'audio_file_paths'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end

    create_table 'phones' do |t|
      t.belongs_to :raspberry_pi, index: true
      t.string 'icloud_device_name', null: false
      t.string 'icloud_username', null: false
      t.string 'icloud_password', null: false
      t.decimal 'lat'
      t.decimal 'lng'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.datetime 'location_updated_at'
    end

    create_table 'locations' do |t|
      t.belongs_to :raspberry_pi, index: true
      t.string 'type', null: false
      t.string 'address', null: false
      t.integer 'radius', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
  end

  def down
    drop_table :raspberry_pis
    drop_table :phones
    drop_table :locations
  end
end

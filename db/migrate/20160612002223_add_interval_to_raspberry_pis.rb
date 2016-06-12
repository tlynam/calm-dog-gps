class AddIntervalToRaspberryPis < ActiveRecord::Migration
  def change
    add_column :raspberry_pis, :interval, :integer, null: false, default: 5
  end
end

class AddIsHomeToPhones < ActiveRecord::Migration
  def change
    add_column :phones, :is_home, :boolean, null: false, default: false
  end
end

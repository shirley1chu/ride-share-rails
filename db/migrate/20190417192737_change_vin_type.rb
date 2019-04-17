class ChangeVinType < ActiveRecord::Migration[5.2]
  def change
    change_column :drivers, :vin, :string
  end
end

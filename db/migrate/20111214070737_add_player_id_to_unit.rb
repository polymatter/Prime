class AddPlayerIdToUnit < ActiveRecord::Migration
  def change
    add_column :units, :player_id, :integer
  end
end

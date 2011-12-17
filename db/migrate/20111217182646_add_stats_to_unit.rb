class AddStatsToUnit < ActiveRecord::Migration
  def change
    add_column :units, :red, :integer
    add_column :units, :blue, :integer
    add_column :units, :green, :integer
  end
end

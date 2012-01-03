class CreateTurnLogs < ActiveRecord::Migration
  def change
    create_table :turn_logs do |t|
      t.string :desc
      t.text :notes
      t.datetime :when
      t.integer :unit_id

      t.timestamps
    end
  end
end

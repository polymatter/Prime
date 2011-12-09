class CreateNodeLinks < ActiveRecord::Migration
  def change
    create_table :node_links do |t|
      t.integer :node_id
      t.integer :linked_node_id

      t.timestamps
    end
  end
end

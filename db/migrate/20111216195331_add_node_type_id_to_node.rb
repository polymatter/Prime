class AddNodeTypeIdToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :node_type_id, :integer
  end
end

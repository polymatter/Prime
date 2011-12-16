class CreateNodeTypes < ActiveRecord::Migration
  def change
    create_table :node_types do |t|
      t.string :name
      t.string :reachable_img

      t.timestamps
    end
  end
end

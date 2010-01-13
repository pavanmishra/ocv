class CreatePositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.string :title
      t.string :span
      t.integer :member_id

      t.timestamps
    end
  end

  def self.down
    drop_table :positions
  end
end

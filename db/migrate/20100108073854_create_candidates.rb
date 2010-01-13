class CreateCandidates < ActiveRecord::Migration
  def self.up
    create_table :candidates do |t|
      t.string :state_code
      t.string :state
      t.string :constituency
      t.string :name
      t.string :sex
      t.string :address_line_1
      t.string :address_line_2
      t.string :city_town_village
      t.string :age
      t.string :category
      t.string :party
      t.string :symbol_no
      t.integer :postal_votes
      t.integer :evm_votes
      t.integer :total_votes

      t.timestamps
    end
  end

  def self.down
    drop_table :candidates
  end
end

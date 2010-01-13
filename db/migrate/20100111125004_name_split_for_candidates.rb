class NameSplitForCandidates < ActiveRecord::Migration
  def self.up
    change_table(:candidates) do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name        
      t.string :salutation
    end
  end

  def self.down
    change_table(:candidates) do |t|
      t.remove :first_name, :middle_name, :last_name, :salutation
    end
  end
end

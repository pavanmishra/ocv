class CreateCandidateMembers < ActiveRecord::Migration
  def self.up
    create_table :candidate_members do |t|
      t.integer :candidate_id
      t.integer :member_id

      t.timestamps
    end
  end

  def self.down
    drop_table :candidate_members
  end
end

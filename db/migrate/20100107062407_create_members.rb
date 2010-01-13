class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.text :source
      t.string :birth_place
      t.string :email
      t.text :countries_visited
      t.string :mothers_name
      t.string :party_name
      t.string :name
      t.string :present_address
      t.integer :no_of_daughters
      t.integer :no_of_sons
      t.text :profession
      t.string :party_code
      t.text :books_published
      t.text :other_information
      t.text :recreation_activities
      t.text :special_interests
      t.string :marital_status
      t.date :birth_date
      t.date :marriage_date
      t.text :permanent_address
      t.text :education
      t.string :fathers_name
      t.string :spouse_name
      t.string :constituency
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end

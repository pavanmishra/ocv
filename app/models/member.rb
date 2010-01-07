class Member < ActiveRecord::Base
  has_many :positions
  
  def self.create_member_having_profile mp_no, member_hash
    positions = member_hash.delete('positions')
    #puts member_hash.inspect
    
    member = self.create! member_hash
    positions.each do |span, titles|
      titles.each do |title|
        member.positions.create :title => title, :span => span
      end
    end
  end
end

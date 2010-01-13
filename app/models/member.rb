class Member < ActiveRecord::Base
  has_many :positions
  has_many :candidate_members
  has_many :candidates, :through => :candidate_members
  def self.split_names
    self.all.each do |members|
=begin      
       	 Botcha Lakshmi,Dr. (Smt.) Jhansi
       	 Beg,Dr. Mirza Mehboob
       	 Besra,Shri Devidhan
       	 Bhadana,Shri Avtar Singh
=end      
      names = candidate.name.split(' ')
      middle_name, salutation = nil, nil
      if names.first.eql?('DR.')
        salutation = 'Dr'
        names = names[1..5]
        if name.length.eql?(2)
          first_name, last_name = names
        else
          first_name, middle_name, last_name = names
        end
      else
        if name.length.eql?(2)
          last_name, first_name = names
        else
          last_name, first_name, middle_name = names
        end
      end
      candidate.update_attributes(:salutation => salutation, :first_name => first_name, :middle_name => middle_name, :last_name => last_name)
    end
  end
  
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

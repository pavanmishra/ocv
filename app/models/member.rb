class Member < ActiveRecord::Base
  has_many :positions
  has_many :candidate_members
  has_many :candidates, :through => :candidate_members
  def self.split_names
    self.all.each do |member|
      name = member.name
#      first, second = name.split(',')
#      name = [second, first].join(' ')
      # 80% cases of salutation
      if name.include?('.)')
        salutation = name[/.+\.\)/]
        remaining = name[(name.index('.)')+2)..(name.length)]
      else
        salutation = name.split(' ').first
        remaining = name.split(' ').slice(1, 20).join(' ')
      end
      name_components = remaining.split(' ')
      first_name = middle_name = nil
      case name_components.length
      when 1
        first_name = name
      when 2
        first_name, last_name = name_components
      when 3
        first_name, middle_name, last_name = name_components
      else
        first_name, middle_name= name_components
        last_name = name_components[2, name_components.length].join(' ')
      end
      puts "#{name} => s:#{salutation} f:#{first_name} m:#{middle_name} l:#{last_name}"
      member.update_attributes({:name => name, :first_name => first_name, :middle_name => middle_name, :last_name => last_name, :salutation => salutation})
    end
    1
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
  
  def self.create_member_of_no_profile mp_no
    self.create! :no_profile => true, :source => mp_no.to_s
  end
  
  def self.create_member_of_old_profile mp_no, doc
    self.create! :old_profile => true, :source => "http://164.100.47.132/LssNew/Members/former_Biography.aspx?mpsno=#{mp_no}" , :old_profile_data => doc.to_s 
  end
end

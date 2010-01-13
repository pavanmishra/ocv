class CandidateMember < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :member
  
  def self.associate_candidates_profile
    constituencies = Candidate.all.collect{|candidate| candidate.constituency }.uniq.collect{|constituency| [constituency, constituency.titleize]}
    constituencies.each do |constituency, constituency_titleized|
      puts constituency
      member = Member.first(:conditions => {:constituency => constituency_titleized}) rescue nil
      candidate = Candidate.all(:conditions => {:constituency => constituency}).max{|a, b| a.total_votes <=> b.total_votes}
      if member
        member.candidates << candidate
        member.save
      else
        CandidateMember.create :candidate_id => candidate.id
      end
    end
  end
end

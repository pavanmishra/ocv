class Candidate < ActiveRecord::Base
  has_many :candidate_members
  has_many :members, :through => :candidate_members
  
  def self.split_names
    self.all.each do |candidate|
      middle_name, salutation = nil, nil
      if candidate.name.index('DR.').eql?(0)
        salutation = 'Dr'
        name = candidate.name.sub('DR.', '')
      else 
        name = candidate.name
      end
      names = name.split(' ')
      if salutation
        if names.length.eql?(2)
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
      puts name
      puts last_name, first_name, middle_name
      candidate.update_attributes(:salutation => salutation, :first_name => first_name, :middle_name => middle_name, :last_name => last_name)
    end
    1
  end
  def self.upload_the_available_csvs
    [2004, 1999, 1998].each do |year|
      upload_from_eci_csv year
    end
  end
  
  def self.upload_from_eci_csv year
    require 'fastercsv'
    FasterCSV.foreach("#{RAILS_ROOT}/public/csvs/#{year}_election.csv", :headers => true, :header_converters => lambda{|header|
      case header
      when /st_code/i
        :state_code
      when /st_name/i
        :state
      when /pc_name/i
        :constituency
      when /month/i
        :election_month
      when /year/i
        :election_year
      when /cand_name/i
        :name
      when /sex/i
        :sex
      when /party/i
        :party
      when /totvotpol/i
        :total_votes
      when /pc_type/i
        :category
      else
        header.downcase
      end
      }) do |row|
      row.delete_if{ |header, field|  
          [ 'cand_category', nil ].include?(header)
          }
      Candidate.create!(row.to_hash)
    end
  end
  def self.upload_from_csv
    require 'fastercsv'
    FasterCSV.foreach("#{RAILS_ROOT}/public/csvs/all_candidates_info.csv", :headers => true, :header_converters => lambda{|header| 
      case header
      when /state code$/i
        :state_code
      when /state$/i
        :state
      when /cand name/i
        :name
      when /1/
        :address_line_1
      when /2/
        :address_line_2
      when /town/i
        :city_town_village
      when /category/i
        :category
      when /postal/i
        :postal_votes
      when /evm/i
        :evm_votes
      when /total/i
          :total_votes
      when /parliamentary/i
          :constituency
      when /pc no/i
        :pc_no
      else
        header.downcase
      end}) do |row|
        # deleting not so informative data
        row.delete_if{ |header, field|  
          ['pc no', 'cand sl no' ].include?(header)
          }
        Candidate.create!(row.to_hash)
      end
    end
end

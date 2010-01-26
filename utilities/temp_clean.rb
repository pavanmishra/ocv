=begin
[
  'Alagiri,Shri M. K.',
  'Azad,Shri Kirti (Jha)', 
  'Baalu,Thiru Thalikkottai Rajuthevar', 
  'Bajwa,Sardar Partap Singh', 
  'Baghel,Smt. Sarika Devendra Singh',
  'Baliram,Dr.',
  'Bhonsle,Shri Shrimant Ch. Udyanraje Pratapsinhmaharaj',
  'Botcha Lakshmi,Dr. (Smt.) Jhansi',
  'Chinta Mohan,Dr.',
  'De(Nag),Dr. Ratna',
  'Chakravarty,Smt. Bijoya',
  'Badal,Smt. Harsimrat Kaur',
  'Ajnala,Dr. Rattan Singh',
  'Adhikari ,Shri Sisir Kumar',
  'Abdullah ,Dr. Farooq',
  'Maran,Thiru Dayanidhi',
  'Mohammad,Maulana Asrarul Haque',
  'Natrajan,Km. Meenakshi',
  'Nishad,Capt.(Retd.) Jainarain Prasad',
  'Panda,Shri Baijayant "Jay"',
  'Abdul Rahman,Shri',
  'Patasani,Dr. (Prof.) Prasanna Kumar',
  'Pawar,Shri Sharad Chandra Govindrao',
  'Ram Shankar,Prof.(Dr.)',
  'Ramkishun,Shri',
  'Rana (Raju Rana),Shri Rajendrasinh Ghanshyamsinh',
  'Reddy,Shri S.P.Y.', 
  'Roy,Prof. Saugata',
  'Selja,Kumari ',
  'Shivakumar ,Shri K. @ J.K. Ritheesh',
  'Singh,Rajkumari Ratna',
  'Takam Sanjoy,Shri ',
  'Thomas,Prof. K.V.',
  'Vyas,Dr.(Kum.) Girija',
  'Aaron Rashid,Shri J.M.'].each do |name|
      first, second = name.split(',')
      name = [second, first].join(' ')
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

    end
=end

require 'rubygems'
require 'couchrest'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
CandidateAttributes = ['name', 'sex', 'address_line_1', 'address_line_2', 'city_town_village', 
  'first_name', 'middle_name', 'last_name', 'salutation', 'source', 'birth_place', 'email',
   'countries_visited', 'mothers_name', 'party_name', 'present_address', 'no_of_daughters',
    'no_of_sons', 'profession', 'party_code', 'books_published', 'other_information', 'recreation_activities', 
    'special_interests', 'marital_status', 'birth_date', 'marriage_date', 'permanent_address', 'education',
  'fathers_name', 'spouse_name']
ElectionAttributes = ['state_code', 'state', 'constituency', 'election_month', 'election_year', 'total_votes', 'evm_votes', 'postal_votes', 'party', 'symbol_no', 'position']
db = CouchRest.database!('http://10.0.0.3:5984/opencivic_works')

Candidate.all.each do |candidate|
  puts candidate.id
  candidate_hash = {:type => 'Candidate'}
  election_hash = {:type => 'General Election'}
  election_hash[:term] = case candidate.election_year
  when '2009'
    14
  when '2004'
    13
  when '1999'
    12
  when '1998'
    11
  end
  candidate_hash[:year_of_birth] = Date.today.years_ago(candidate.age.to_i).year unless candidate.age.blank?
  if candidate.members.blank?
    combined_hash =  candidate.attributes.update(:member => false)
  else
    combined_hash = candidate.attributes.update(candidate.members.first.attributes).update(:member => true)  
  end
  election_hash.update(Hash[*combined_hash.select{|key, value| ElectionAttributes.include?(key)}.flatten])
  candidate_hash.update(Hash[*combined_hash.select{|key, value| CandidateAttributes.include?(key)}.flatten])
  # store the candidate 
  candidate_doc = db.save_doc(candidate_hash)
  election_doc = db.save_doc(election_hash.update(:candidate_id => candidate_doc['id']))
end

=begin
  unless candidate.candidate_members.blank?
    puts election_hash.inspect
    puts candidate_hash.inspect 
    break
  end
end 
=end

=begin
Member.all.each do |m|
  m.update_attribute(:constituency, m.constituency.gsub('-', ' '))
end

Candidate.find_by_sql('select distinct constituency, state from candidates').each do |cs|
  Constituency.create :name => cs.constituency, :state => State.find_by_name(cs.state)
end
=end
=begin
def clean_summary summary
  new_summary = {}
  summary.each do |key, value|
    case key
    when /party/i
      value.slice!(')')
      name, code = value.split('(')
      new_summary['party_name'] = name
      new_summary['party_code'] = code
    when /email/i
      new_summary['email'] = value
    when /constituency/i
      constituency, state = value.gsub('(SC)', '').delete(')').split('(')
      new_summary['constituency'] = constituency.strip
      new_summary['state'] = state.strip
    end
  end
  return new_summary
end
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rubygems'
require 'open-uri'
require 'nokogiri'

css_profile_selector = 'Bioprofile1'
summary_header_path = '//table[@id="ctl00_ContPlaceHolderMain_'+ css_profile_selector +'_Datagrid1"]//td[@class="darkerb"]'
summary_data_path = '//table[@id="ctl00_ContPlaceHolderMain_'+ css_profile_selector +'_Datagrid1"]//td[@class="griditem2"]'

Member.all(:conditions => {:state => 'SC'}).each do |member|
	doc = Nokogiri::HTML(open(member.source))
	
  member_summary_header = doc.xpath(summary_header_path).collect{|node| node.content.strip}
  member_summary_data = doc.xpath(summary_data_path).collect{|node| node.content.strip}
  member_summary = member_summary_header.zip(member_summary_data)
  summary_dict = {}
  member_summary.each do |head, data|
    summary_dict[head] = data
  end
  summary_dict = clean_summary(summary_dict)
  puts summary_dict['state']
  member.update_attribute(:state, summary_dict['state'])
#	extract the state, 
#	update
end
=end
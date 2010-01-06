require 'rubygems'
require 'open-uri'
require 'nokogiri'

biography_template_url = "http://164.100.47.132/LssNew/Members/former_Biography.aspx?mpsno="

# there are 4253 profiles to be read lets do that in batches of 30
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
      value.slice!(')')
      constituency, state = value.split('(')
      new_summary['constituency'] = constituency
      new_summary['state'] = state.strip
    end
  end
  return new_summary
end

def clean_bio bio
  new_bio = {}
  bio.each do |key, value|
    case key
    when /marital status/i
      new_bio['marital_status'] = value
    when /date of birth/i
      # may need convrsion to date
      new_bio['birth_date'] = value
    when /date of marriage/i
      new_bio['marriage_date'] = value
    when /no\.of daughters/i
      new_bio['no_of_daughters'] = value
    when /no. of sons/i
      new_bio['no_of_sons'] = value
    when /spouse/i
      new_bio['spouse_name'] = value
    when /father/i
      new_bio['fathers_name'] = value
    when /mother/i
      new_bio['mothers_name'] = value
    when /place of birth/i
      new_bio['birth_place'] = value
    when /profession/i
      new_bio['proffession'] = value.split("\r\n").collect{|profession| profession.strip}.select{|profession| !profession.eql?('')}.join(', ')
    when /present address/i
      new_bio['present_address'] = value.split("\r\n").collect{|profession| profession.strip}.select{|profession| !profession.eql?('')}.join(' ')
    when /permanent address/i
      new_bio['permanent_address'] = value.split("\r\n").collect{|profession| profession.strip}.select{|profession| !profession.eql?('')}.join(' ')
    when /education/i
      new_bio['education'] = value.split("\r\n").collect{|profession| profession.strip}.select{|profession| !profession.eql?('')}.join(' ')
    end
  end
  return new_bio
end

def store_member member
 # puts member.inspect
end

def clean_positions positions
  new_positions = {}
  positions.each do |key, value|
    new_positions[key] = value.select{ |position| !position.eql?('')}
  end
  return new_positions
end

(12..30).each do |i|
  biography_url = biography_template_url + i.to_s
  doc = Nokogiri::HTML(open(biography_url))
  puts("No profile exists for #{i}") and next unless doc.xpath("//p[@align='center']").empty?
  puts("Profile in old format for #{i}") and next unless doc.xpath("//title").first.content.strip.eql?("Lok Sabha")
  puts 'Processing info for ' + i.to_s
  # hash storing the member info unless ready to be stored in database
  member_dict={ :name => doc.xpath('//td[@class="gridheader1"]').first.content.strip }
  # extracted the data from first grid, having the parliament information
  member_summary_header = doc.xpath('//table[@id="ctl00_ContPlaceHolderMain_Former_biography1_Datagrid1"]//td[@class="darkerb"]').collect{|node| node.content.strip}
  member_summary_data = doc.xpath('//table[@id="ctl00_ContPlaceHolderMain_Former_biography1_Datagrid1"]//td[@class="griditem2"]').collect{|node| node.content.strip}
  member_summary = member_summary_header.zip(member_summary_data)
  summary_dict = {}
  member_summary.each do |head, data|
    summary_dict[head] = data
  end
  summary_dict = clean_summary(summary_dict)
  # extracting the data from second grid, having general bio info
  bio_dict = {}
  doc.xpath('//table[@id="ctl00_ContPlaceHolderMain_Former_biography1_DataGrid2"]//td[@class="darkerb"]').each do |node|
    header = node.content.strip
    content = node.parent.children[2].content.strip rescue nil
    bio_dict[header] = content
  end
  bio_dict = clean_bio(bio_dict)
  # need to collect the information on positions held by the member
  current_position_header = ''
  positions_dict ={}
  doc.xpath('//table[@id="ctl00_ContPlaceHolderMain_Former_biography1_Datagrid3"]//td[@class="griditem2"]').each_with_index do |node, index|
    # can have header
    if (index % 2 == 0) and !node.content.strip.eql?('')
      current_position_header = node.content.strip
      positions_dict[current_position_header] = []
    elsif !current_position_header.eql?('')
      data = node.content.strip 
      positions_dict[current_position_header] << data if data
    end
  end
  positions_dict = clean_positions(positions_dict)
  # need to collect other information
  headers = doc.xpath('//table[@id="ctl00_ContPlaceHolderMain_Former_biography1_Datagrid4"]//td[@class="darkerb"]').collect{|node| node.content.strip}.select{|node| !node.eql?('')}  
  # the other path for selecting the typo in assigning the class to other information data
  data = doc.xpath('//table[@id="ctl00_ContPlaceHolderMain_Former_biography1_Datagrid4"]//td[@class="griditem2"] | //td[@class="grditem2"]').collect{|node| node.content.strip}.select{|node| !node.eql?('')}  
  other_information = headers.zip(data)
  other_dict = {}
  other_information.each do |head, data|
    other_dict[head] = data
  end
  [summary_dict, positions_dict, bio_dict, other_dict].each do |dict| member_dict.merge! dict end
  store_member(member_dict)
  break
end
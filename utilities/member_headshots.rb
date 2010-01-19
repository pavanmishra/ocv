require 'uri'
require 'net/http'
response = Net::HTTP.get(URI.parse("http://164.100.24.208/ls/lsmember/13biodata/#{mp_no}.jpg"))

require 'open-uri'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
start_with = 1
end_at = 4573
(start_with..end_at).each do |mp_no|
  begin
    # here we try to pic the headshots of recent members
    puts 'New headshot for', mp_no
    image_content = open("http://164.100.24.208/ls/lsmember/13biodata/#{mp_no}.jpg", 'rb')
    File.new("#{RAILS_ROOT}/public/headshots/new/#{mp_no}.jpg", 'wb').write(image_content)
  rescue OpenURI::HTTPError
    begin
      puts 'old headshot', mp_no
      image_content = open("http://164.100.47.132/LssNew/biodata_1_12/#{mp_no}.GIF")
      File.new("#{RAILS_ROOT}/public/headshots/old/#{mp_no}.jpg", 'wb').write(image_content)
      break
    rescue OpenURI::HTTPError
      puts 'No image for', mp_no
    end
  end

end
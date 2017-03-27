require File.join(File.dirname(__FILE__), 'lib', 'parser')

URL = "http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml"

task :default  do
  parser = Parser.new
  
  begin
    speakers = parser.parse_url_content(URL)
    
    speakers.each { |k, v| puts "#{v} #{k}" }
  rescue => e
    puts e.message
  end
end
require 'download_manager'
require 'nokogiri'

class Parser
  
  INVALID_URL_CONTENT_ERROR_MESSAGE = "The content of this url is invalid."
  NOT_XML_CONTENT_ERROR_MESSAGE = "The url didn't return a xml content."
  
  def parse_url_content(url)
    
    raise ArgumentError if url.nil?
    
    raise ArgumentError if not (url.instance_of? String)
    raise ArgumentError if url.empty?
    
    download_manager = DownloadManager.new
    url_content = download_manager.get_url_content(url)
    
    raise Exception.new(INVALID_URL_CONTENT_ERROR_MESSAGE) if url_content.nil?
    
    begin
      xml_content = parse_xml_content(url_content)
    rescue
    end
    
    raise Exception.new(NOT_XML_CONTENT_ERROR_MESSAGE) if xml_content.nil?
    
  end
  
  private
  
  def parse_xml_content(content)
    Nokogiri::XML(content) do |config|
        config.strict.noblanks
    end
  end
end
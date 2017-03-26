require 'download_manager'

class Parser
  
  INVALID_URL_CONTENT_ERROR_MESSAGE = "The content of this url is invalid."
  def parse_url_content(url)
    
    raise ArgumentError if url.nil?
    
    raise ArgumentError if not (url.instance_of? String)
    raise ArgumentError if url.empty?
    
    download_manager = DownloadManager.new
    url_content = download_manager.get_url_content(url)
    
    raise Exception.new(INVALID_URL_CONTENT_ERROR_MESSAGE) if url_content.nil?
  end
end
class Parser
  
  def parse_url_content(url)
    
    raise ArgumentError if url.nil?
    
    raise ArgumentError if not (url.instance_of? String)
    raise ArgumentError if url.empty?
    
  end
end
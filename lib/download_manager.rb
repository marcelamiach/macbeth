require 'socket'
require 'uri'
require 'net/http'

class DownloadManager
  
  SOCKET_ERROR_MESSAGE = "Failed to connect to server."
  INVALID_URI_ERROR_MESSAGE = "This is not valid url."
  STANDARD_ERROR_MESSAGE = "Something went wrong when downloading file."
  
  HTTP_RESPONSE_ERROR_MESSAGE = "The server response was not successful."
  HTTP_RESPONSE_BODY_EMPTY = "The server returned an empty body."

  def get_url_content(url)
    
    raise ArgumentError if url.nil?
    begin
      response = run_get_request(url)
    rescue SocketError
      raise SOCKET_ERROR_MESSAGE
    rescue URI::InvalidURIError
      raise INVALID_URI_ERROR_MESSAGE
    rescue
      raise STANDARD_ERROR_MESSAGE
    end
    
    return if response.nil?
    
    raise Exception.new(HTTP_RESPONSE_ERROR_MESSAGE) if response.code != "200"
    raise Exception.new(HTTP_RESPONSE_BODY_EMPTY) if response.body.nil?
    
    response.body
  end
  
  private
  
  def run_get_request(url)
    uri = URI(url)
    Net::HTTP.get_response(uri)
  end
end
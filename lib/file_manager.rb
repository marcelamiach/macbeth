require 'socket'
require 'uri'
require 'net/http'

class FileManager
  
  SOCKET_ERROR_MESSAGE = "Failed to connect to server."
  INVALID_URI_ERROR_MESSAGE = "This is not valid url."
  STANDARD_ERROR_MESSAGE = "Something went wrong when downloading file."
  
  HTTP_RESPONSE_ERROR_MESSAGE = "The server response was not successful."
  def get(url)
    begin
      response = open(url)
    rescue SocketError
      raise SOCKET_ERROR_MESSAGE
    rescue URI::InvalidURIError
      raise INVALID_URI_ERROR_MESSAGE
    rescue
      raise STANDARD_ERROR_MESSAGE
    end
    
    return if response.nil?
    
    raise Exception.new(HTTP_RESPONSE_ERROR_MESSAGE) if response.code != "200"
  end
  
  def open(url)
    uri = URI(url)
    Net::HTTP.get_response(uri)
  end
end
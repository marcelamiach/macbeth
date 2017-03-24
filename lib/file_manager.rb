require 'socket'
require 'uri'

class FileManager
  
  SOCKET_ERROR_MESSAGE = "Failed to connect to server."
  INVALID_URI_ERROR_MESSAGE = "This is not valid url."
  
  def get(url)
    begin
      response = open(url)
    rescue SocketError
      raise SOCKET_ERROR_MESSAGE
    rescue URI::InvalidURIError
      raise INVALID_URI_ERROR_MESSAGE
    end
  end
end
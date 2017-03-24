require 'socket'

class FileManager
  
  SOCKET_ERROR_MESSAGE = "Failed to connect to server."
  
  def get(url)
    begin
      response = open(url)
    rescue SocketError
      raise SOCKET_ERROR_MESSAGE
    end
  end
end
require 'spec_helper'
 
describe FileManager do
  before do
    @file_manager = FileManager.new
    WebMock.disable_net_connect!(allow_localhost: true)
  end
  
  it 'makes sure there is a class called FileManager' do
    expect(@file_manager).not_to be_nil
  end

  it 'FileManager should have method get to make get http requests' do
    is_expected.to respond_to(:get).with(1).argument
  end
  
  it 'method get should raise exception with SOCKET_ERROR_MESSAGE when handling SocketError' do
    message = FileManager::SOCKET_ERROR_MESSAGE
    allow(@file_manager).to receive(:open).and_raise(SocketError)
    expect { @file_manager.get(instance_of(String)) }.to raise_error(message)
  end
  
  it 'method get should raise exception with INVALID_URI_ERROR_MESSAGE when handling InvalidURIError' do
    message = FileManager::INVALID_URI_ERROR_MESSAGE
    allow(@file_manager).to receive(:open).and_raise(URI::InvalidURIError)
    expect { @file_manager.get(instance_of(String)) }.to raise_error(message)
  end

  it 'method get should raise exception with STANDARD_ERROR_MESSAGE when handling StandardError' do
    message = FileManager::STANDARD_ERROR_MESSAGE
    allow(@file_manager).to receive(:open).and_raise(StandardError)
    expect { @file_manager.get(instance_of(String)) }.to raise_error(message)
  end
  
  it 'method open should return Net::HTTPResponse object' do
    url = "http://www.example.com"
    stub_request(:get, url)
    
    response = @file_manager.open(url)
    
    expect(response).to be_kind_of(Net::HTTPResponse)
  end
end
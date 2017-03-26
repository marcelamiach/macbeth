require 'spec_helper'
 
describe DownloadManager do
  before do
    @download_manager = DownloadManager.new
    WebMock.disable_net_connect!(allow_localhost: true)
  end
  
  it 'makes sure there is a class called DownloadManager' do
    expect(@download_manager).not_to be_nil
  end

  it 'DownloadManager should have method get_url_content to make get http requests' do
    is_expected.to respond_to(:get_url_content).with(1).argument
  end
  
  it 'method get_url_content should raise ArgumentError if argument is nil' do
    expect { @download_manager.get_url_content(nil) }.to raise_error(ArgumentError)
  end
  
  it 'method get_url_content should raise ArgumentError if it does not receive string' do
    argument1 = [1, 2, 3, 4, 5, 6]
    argument2 = 6
    argument3 = {:first => "first", :second => "second" }
    
    expect { @download_manager.get_url_content(argument1) }.to raise_error(ArgumentError)
    expect { @download_manager.get_url_content(argument2) }.to raise_error(ArgumentError)
    expect { @download_manager.get_url_content(argument3) }.to raise_error(ArgumentError)
  end
  
  it 'method get_url_content should raise ArgumentError if string is empty' do
    argument = ""
    
    expect { @download_manager.get_url_content(argument) }.to raise_error(ArgumentError)
  end
  
  it 'method get_url_content should raise exception with SOCKET_ERROR_MESSAGE when handling SocketError' do
    argument = "This is a random string"
    message = DownloadManager::SOCKET_ERROR_MESSAGE
    
    allow(@download_manager).to receive(:run_get_request).and_raise(SocketError)
    
    expect { @download_manager.get_url_content(argument) }.to raise_error(message)
  end
  
  it 'method get_url_content should raise exception with INVALID_URI_ERROR_MESSAGE when handling InvalidURIError' do
    argument = "This is another random string"
    message = DownloadManager::INVALID_URI_ERROR_MESSAGE
    
    allow(@download_manager).to receive(:run_get_request).and_raise(URI::InvalidURIError)
    
    expect { @download_manager.get_url_content(argument) }.to raise_error(message)
  end

  it 'method get_url_content should raise exception with STANDARD_ERROR_MESSAGE when handling StandardError' do
    message = DownloadManager::STANDARD_ERROR_MESSAGE
    allow(@download_manager).to receive(:run_get_request).and_raise(StandardError)
    expect { @download_manager.get_url_content(instance_of(String)) }.to raise_error(message)
  end
  
  it 'method run_get_request should return Net::HTTPResponse object' do
    url = "http://www.example.com"
    stub_request(:get, url)
    
    response = @download_manager.send(:run_get_request, url)
    
    expect(response).to be_kind_of(Net::HTTPResponse)
  end
  
  it 'method get_url_content should raise exception if response status code is not 200' do
    url = "http://www.example.com"
    stub_request(:get, url).to_return(:status => 404)

    expect { @download_manager.get_url_content(url) }.to raise_error(DownloadManager::HTTP_RESPONSE_ERROR_MESSAGE)
  end
  
  it 'method get_url_content should return string if response status code is 200 and body not blank' do
    url = "http://www.example.com"
    stub_request(:get, url).to_return(:body => "abc", :status => 200)
    
    get_url_content_return = @download_manager.get_url_content(url)
    
    expect(get_url_content_return).to be_kind_of(String)
  end
  
  it 'method get_url_content should raise exception if response status code is 200 but body is empty' do
    url = "http://www.example.com"
    stub_request(:get, url).to_return(:body => "", :status => 200)
    
    expect { @download_manager.get_url_content(url) }.to raise_error(DownloadManager::HTTP_RESPONSE_BODY_EMPTY)
  end
end
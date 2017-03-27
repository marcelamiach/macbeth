require 'spec_helper'
 
describe Parser do
  before do
    @parser = Parser.new
  end
  
  context "When testing Parser class structure" do
  
    it 'makes sure there is a class called Parser' do
      expect(@parser).not_to be_nil
    end
  
    it 'Parser should have method parse_url_content to parse content from url' do
      is_expected.to respond_to(:parse_url_content).with(1).argument
    end
  end
  
  context "When testing parse_url_content url argument" do
    
    it 'method parse_url_content should raise ArgumentError if argument is nil' do
      expect { @parser.parse_url_content(nil) }.to raise_error(ArgumentError)
    end
  
    it 'method parse_url_content should raise ArgumentError if it does not receive string' do
      argument1 = [1, 2, 3, 4, 5, 6]
      argument2 = 6
      argument3 = {:first => "first", :second => "second" }

      expect { @parser.parse_url_content(argument1) }.to raise_error(ArgumentError)
      expect { @parser.parse_url_content(argument2) }.to raise_error(ArgumentError)
      expect { @parser.parse_url_content(argument3) }.to raise_error(ArgumentError)
    end

    it 'method get_url_content should raise ArgumentError if string is empty' do
      argument = ""

      expect { @parser.parse_url_content(argument) }.to raise_error(ArgumentError)
    end
  end
  
  context "When testing integration with DownloadManager" do
    
    it 'parse_url_content should raise exeception if DownloadManager#get_url_content returns nil' do
      url = "www.example.com"
      
      allow_any_instance_of(DownloadManager).to receive(:get_url_content).with(url).and_return(nil)
      
      expect { @parser.parse_url_content(url) }.to raise_error(Parser::INVALID_URL_CONTENT_ERROR_MESSAGE)
    end
  
    it 'parse_url_content should raise exception if response body is not a xml content' do
      url = "http://www.example.com"

      allow_any_instance_of(DownloadManager).to receive(:get_url_content).and_return("I'm not a xml content.")
      
      expect { @parser.parse_url_content(url) }.to raise_error(Parser::NOT_XML_CONTENT_ERROR_MESSAGE)
    end
  end
end

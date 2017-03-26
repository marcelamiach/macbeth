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
  end
end

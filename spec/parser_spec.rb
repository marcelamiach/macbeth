require 'spec_helper'
 
describe Parser do
  before do
    @parser = Parser.new
    @url = "www.example.com"
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
      allow_any_instance_of(DownloadManager).to receive(:get_url_content).with(@url).and_return(nil)
      
      expect { @parser.parse_url_content(@url) }.to raise_error(Parser::INVALID_URL_CONTENT_ERROR_MESSAGE)
    end
  end
  
  context "When testing url content" do
  
    it 'parse_url_content should raise exception if response body is not a xml content' do
      allow_any_instance_of(DownloadManager).to receive(:get_url_content).and_return("I'm not a xml content.")
      
      expect { @parser.parse_url_content(@url) }.to raise_error(Parser::NOT_XML_CONTENT_ERROR_MESSAGE)
    end
    
    it 'parse_url_content should raise exception if xml content is not a play' do      
      xml_content = "<blah></blah>"

      allow_any_instance_of(DownloadManager).to receive(:get_url_content).and_return(xml_content)
      
      expect { @parser.parse_url_content(@url) }.to raise_error(Parser::NOT_PLAY_CONTENT_ERROR_MESSAGE)
    end
    
    it 'parse_url_content should raise exception if xml content has not a title' do
      xml_content = "<PLAY></PLAY>"
      
      allow_any_instance_of(DownloadManager).to receive(:get_url_content).and_return(xml_content)
      
      expect { @parser.parse_url_content(@url) }.to raise_error(Parser::NO_TITLE_TAG_ERROR_MESSAGE)
    end

    it 'parse_url_content should raise exception if xml content has not at least one act node' do
      xml_content = "<PLAY><TITLE></TITLE></PLAY>"
      
      allow_any_instance_of(DownloadManager).to receive(:get_url_content).and_return(xml_content)
      
      expect { @parser.parse_url_content(@url) }.to raise_error(Parser::NO_ACT_TAG_ERROR_MESSAGE)
    end

    it 'parse_url_content should raise exception if xml content has not at least one scene inside act nodes' do
      xml_content = "<PLAY><TITLE></TITLE><ACT></ACT></PLAY>"
      
      allow_any_instance_of(DownloadManager).to receive(:get_url_content).and_return(xml_content)
      
      expect { @parser.parse_url_content(@url) }.to raise_error(Parser::NO_SCENE_TAG_ERROR_MESSAGE)
    end
    
    it 'parse_url_content should raise exception if xml content has not at least one speech inside scene nodes' do
      xml_content = "<PLAY><TITLE></TITLE><ACT><SCENE></SCENE></ACT></PLAY>"
      
      allow_any_instance_of(DownloadManager).to receive(:get_url_content).and_return(xml_content)
      
      expect { @parser.parse_url_content(@url) }.to raise_error(Parser::NO_SPEECH_TAG_ERROR_MESSAGE)
    end

    it 'parse_url_content should raise exception if xml content has not at least one speaker inside speech nodes' do
      xml_content = "<PLAY><TITLE></TITLE><ACT><SCENE><SPEECH></SPEECH></SCENE></ACT></PLAY>"
      
      allow_any_instance_of(DownloadManager).to receive(:get_url_content).and_return(xml_content)
      
      expect { @parser.parse_url_content(@url) }.to raise_error(Parser::NO_SPEAKER_TAG_ERROR_MESSAGE)
    end
    
    it 'parse_url_content should return hash of speakers counting: keys are speakers and values are couting' do
      xml_content = valid_play_xml
      expected_hash = 
        {"First Speaker" => 3, "Second Speaker" => 2, "Third Speaker" => 2,
          "Fourth Speaker" => 1, "Fifth Speaker" => 2, "6th Speaker" => 1 }
      
      # Speaker "ALL" should be ignored
      
      allow_any_instance_of(DownloadManager).to receive(:get_url_content).and_return(xml_content)
      hash = @parser.parse_url_content(@url)
      
      expect(expected_hash).to eq(hash)
    end
    
    def valid_play_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.PLAY {
          xml.TITLE "This is the title"
          xml.ACT {
            xml.SCENE {
              xml.SPEECH {
                xml.SPEAKER "First Speaker"
                xml.LINE "First line"
                xml.LINE "Second line"
              }
              xml.SPEECH {
                xml.SPEAKER "Second Speaker"
                xml.LINE "His first line"
                xml.LINE "His second line"
                xml.LINE "His third line"
              }
              xml.SPEECH {
                xml.SPEAKER "Third Speaker"
                xml.LINE "Just this line"
              }
              xml.SPEECH {
                xml.SPEAKER "ALL"
                xml.LINE "We are all together talking"
              }
            }
            xml.SCENE {
              xml.SPEECH {
                xml.SPEAKER "Fourth Speaker"
                xml.LINE "A new line"
              }
              xml.SPEECH {
                xml.SPEAKER "First Speaker"
                xml.LINE "He speaks again"
              }
              xml.SPEECH {
                xml.SPEAKER "Third Speaker"
                xml.LINE "He is also talking again"
              }
            }
          }
          xml.ACT {
            xml.SCENE {
              xml.SPEECH {
                xml.SPEAKER "Fifth Speaker"
                xml.LINE "It's my turn"
              }
              xml.SPEECH {
                xml.SPEAKER "Second Speaker"
                xml.LINE "It's me again"
              }
              xml.SPEECH {
                xml.SPEAKER "6th Speaker"
                xml.LINE "I'm new here"
              }
              xml.SPEECH {
                xml.SPEAKER "First Speaker"
                xml.LINE "I'm here again"
                xml.LINE "Let me talk a little bit"
              }
            }
          }
          xml.ACT {
            xml.SCENE {
              xml.SPEECH {
                xml.SPEAKER "Fifth Speaker"
                xml.LINE "This act is a monologue"
              }
            }
          }
        }
      end
      builder.to_xml
    end
  end
end
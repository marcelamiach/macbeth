require File.join(File.dirname(__FILE__), 'download_manager')
require File.join(File.dirname(__FILE__), 'invalid_xml_content_error')
require 'nokogiri'

class Parser
  
  INVALID_URL_CONTENT_ERROR_MESSAGE = "The content of this url is invalid."
  NOT_XML_CONTENT_ERROR_MESSAGE = "The url didn't return a xml content."
  NOT_PLAY_CONTENT_ERROR_MESSAGE = "This xml file is not a play."
  NO_TITLE_TAG_ERROR_MESSAGE = "This xml file has not a play title."
  NO_ACT_TAG_ERROR_MESSAGE = "This xml file does not contain ACT tags."
  NO_SCENE_TAG_ERROR_MESSAGE = "This xml file does not contain SCENE tags."
  NO_SPEECH_TAG_ERROR_MESSAGE = "This xml file does not contain SPEECH tags."
  NO_SPEAKER_TAG_ERROR_MESSAGE = "This xml file does not contain SPEAKER tags"
  
  def parse_url_content(url)
    
    raise ArgumentError if url.nil?
    
    raise ArgumentError if not (url.instance_of? String)
    raise ArgumentError if url.empty?
    
    download_manager = DownloadManager.new
    url_content = download_manager.get_url_content(url)
    
    raise InvalidXmlContentError.new(INVALID_URL_CONTENT_ERROR_MESSAGE) if url_content.nil?
    
    begin
      xml_content = parse_xml_content(url_content)
    rescue
    end
    
    raise InvalidXmlContentError.new(NOT_XML_CONTENT_ERROR_MESSAGE) if xml_content.nil?
    raise InvalidXmlContentError.new(NOT_PLAY_CONTENT_ERROR_MESSAGE) if is_not_a_play?(xml_content)
    raise InvalidXmlContentError.new(NO_TITLE_TAG_ERROR_MESSAGE) if has_not_title?(xml_content)
    raise InvalidXmlContentError.new(NO_ACT_TAG_ERROR_MESSAGE) if has_not_act?(xml_content)
    raise InvalidXmlContentError.new(NO_SCENE_TAG_ERROR_MESSAGE) if has_not_scene?(xml_content)
    raise InvalidXmlContentError.new(NO_SPEECH_TAG_ERROR_MESSAGE) if has_not_speech?(xml_content)
    raise InvalidXmlContentError.new(NO_SPEAKER_TAG_ERROR_MESSAGE) if has_not_speaker?(xml_content)
    
    hash = Hash.new
    
    speakers = xml_content.xpath("//PLAY//ACT//SCENE//SPEECH//SPEAKER")
  
    speakers.each do |speaker|
      next if speaker.content == "ALL"
      
      if hash.keys.include?("#{speaker.content}")
        hash["#{speaker.content}"] = hash["#{speaker.content}"] + 1
      else
        hash.merge!("#{speaker.content}" => 1)
      end
    end
  
    hash
  end
  
  private
  
  def parse_xml_content(content)
    Nokogiri::XML(content) do |config|
        config.strict.noblanks
    end
  end
    
  def is_not_a_play?(xml_content)
    xml_content.xpath("//PLAY").empty?
  end
  
  def has_not_title?(xml_content)
    xml_content.xpath("//PLAY//TITLE").empty?
  end
  
  def has_not_act?(xml_content)
    xml_content.xpath("//PLAY//ACT").empty?
  end
  
  def has_not_scene?(xml_content)
    xml_content.xpath("//PLAY//ACT//SCENE").empty?
  end
  
  def has_not_speech?(xml_content)
    xml_content.xpath("//PLAY//ACT//SCENE//SPEECH").empty?
  end
  
  def has_not_speaker?(xml_content)
    xml_content.xpath("//PLAY//ACT//SCENE//SPEECH//SPEAKER").empty?
  end
end
require 'spec_helper'
 
describe FileManager do
  before do
    @file_manager = FileManager.new
  end
  
  it 'makes sure there is a class called FileManager' do
    expect(@file_manager).not_to be_nil
  end

  it 'FileManager should have method get to make get http requests' do
    is_expected.to respond_to(:get).with(1).argument
  end
end
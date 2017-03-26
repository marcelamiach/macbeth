require 'spec_helper'
 
describe Parser do
  it 'makes sure there is a class called Parser' do
    parser  = Parser.new
    expect(parser).not_to be_nil
  end
end
$: << File.join(File.dirname(__FILE__), '..', 'lib')
 
require 'pry'
require 'socket'
require 'uri'
require 'download_manager'
require 'webmock/rspec'
require 'net/http'
require 'parser'
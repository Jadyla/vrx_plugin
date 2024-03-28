require 'net/http'
require 'uri'
require_relative 'utils'

module Sketchup
  module VRX

    require_relative "VRX_main"
    Sketchup::VRX::MonitorCommands.start_monitoring
    url = URI.parse("#{$api_ruby_protocol}://#{$api_ruby_server}:#{$api_ruby_port}/set_model_open?is_model_open=true")
    Net::HTTP.get_response(url)
  end
end

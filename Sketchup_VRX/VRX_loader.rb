module Sketchup
  module VRX

    require "#{FOLDER}/VRX_main.rb"
    Sketchup::VRX::Connect.receive_command()

  end
end

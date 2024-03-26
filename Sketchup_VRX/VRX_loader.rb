module Sketchup
  module VRX

    require_relative "VRX_main"
    Sketchup::VRX::MonitorCommands.start_monitoring
  end
end

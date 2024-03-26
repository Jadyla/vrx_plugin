require 'sketchup.rb'
require 'extensions.rb'
require 'langhandler.rb'
require 'json'

module Sketchup
  module VRX
    unless file_loaded?(__FILE__)
      extension = SketchupExtension.new('VRX', 'Sketchup_VRX/VRX_loader')
      extension.version = '1.0'
      extension.copyright = '2024, All Rights Reserved.'
      extension.creator = 'Amoradev'
      extension.description = 'Extension to VRX App that manipulate Sketchup in application window.'

      Sketchup.register_extension(extension, true)

      file_loaded(__FILE__)
    end
  end
end # module Sketchup::VRX

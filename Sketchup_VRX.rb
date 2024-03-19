require 'sketchup.rb'
require 'extensions.rb'
require 'langhandler.rb'
require 'json'
require_relative 'utils'

module Sketchup
  module VRX
    class MonitorCommands
      def self.initialize()
      end

      def self.start_monitoring
        last_modification = self.get_modification_time
        UI.start_timer(1.0, true) do
          time_modification = self.check_file_modification(last_modification)
          last_modification = time_modification
        end
      end

      def self.check_file_modification(last_modification)
        current_modified_time = self.get_modification_time
        if current_modified_time > last_modification
          last_modification = current_modified_time
          puts "O arquivo foi modificado!"
          self.read_command_file
        else
          puts "Sem modificação!"
        end
        return last_modification
      end

      def self.read_command_file
        File.open($command_file, 'r') do |file|
          file.each_line do |line|
            eval(line)
          end
        end
      end

      def self.get_modification_time
        return File.mtime($command_file)
      end
    end

    class CustomizeModel
      def self.paint(color, entity_attr)
        new_material = ::Sketchup.active_model.materials.add("New color")
        new_material.color = color
        apply_for_all_entity_faces(entity_attr, new_material)
      end

      def self.apply_texture(texture, entity_attr)
        new_material = ::Sketchup.active_model.materials.add('Joe')
        new_material.texture = 'C:\Users\Amoradev\AppData\Roaming\SketchUp\SketchUp 2021\SketchUp\Materials\\' + texture
        apply_for_all_entity_faces(entity_attr, new_material)
      end

      private
      def self.apply_for_all_entity_faces(entity_attr, new_material)
        ::Sketchup.active_model.entities.each do |entity|
          if entity.attribute_dictionaries
            attribute = entity.get_attribute($entities_dict, $entities_dict_key)
            if attribute && attribute == entity_attr
              if entity.respond_to?(:material)
                entity.material = new_material
              elsif entity.is_a?(::Sketchup::Group) || entity.is_a?(::Sketchup::ComponentInstance)
                entity.definition.entities.grep(::Sketchup::Face).each { |face| face.material = new_material }
              end
            end
          end
        end
      end
    end
  end
end # module Sketchup::VRX

Sketchup::VRX::MonitorCommands.start_monitoring

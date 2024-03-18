require 'sketchup.rb'
require 'extensions.rb'
require 'langhandler.rb'

module Sketchup
  module VRX
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

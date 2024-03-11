require 'net/http'
require 'json'
require 'uri'
require_relative 'utils'

# Define o caminho para o script que você deseja carregar automaticamente ao abrir um modelo no sketchup
html_content = File.read(File.join(File.dirname(__FILE__), 'index.html'))
cfg = JSON.parse(File.read(File.join(File.dirname(__FILE__), 'cfg.json')))
SCRIPT_PATH = cfg['script_path']
URI_PATH = cfg['uri_path']
PRINT_PATH = cfg['print_path']

#Variáveis ruby
PRINT_WIDTH = cfg['print_width']
PRINT_HEIGHT = cfg['print_height']
WINDOW_WIDTH = cfg['window_width']
WINDOW_HEIGHT = cfg['window_height']
#/Variáveis Ruby

class CustomizeModel
  def initialize (model, materials, entities)
    @model = model
    @materials = materials
    @entities = entities
  end

  def paint(color, entity_attr)
    new_material = @materials.add("New color")
    new_material.color = color
    apply_for_all_entity_faces(entity_attr, new_material)
  end

  def apply_texture(texture, entity_attr)
    new_material = @materials.add('Joe')
    new_material.texture = texture
    apply_for_all_entity_faces(entity_attr, new_material)
  end

  private
  def apply_for_all_entity_faces(entity_attr, new_material)
    @entities.each do |entity|
      if entity.attribute_dictionaries
        attribute = entity.get_attribute($entities_dict, $entities_dict_key)
        if attribute && attribute == entity_attr
          if entity.respond_to?(:material)
            entity.material = new_material
          elsif entity.is_a?(Sketchup::Group) || entity.is_a?(Sketchup::ComponentInstance)
            entity.definition.entities.grep(Sketchup::Face).each { |face| face.material = new_material }
          end
        end
      end
    end
  end
end


class ModelObserver < Sketchup::ModelObserver
  def onOpenModel(model)
    load SCRIPT_PATH
  end
end

module YourPluginNamespace # TODO: Mudar o nome para o plugin
  class CloseSketchUp
    def initialize
    end

    def activate
      UI.messagebox("Fechando o SketchUp...")
      # TODO: Verificar com a vivian se é necessário fechar o SketchUp
      Sketchup.quit
    end
  end

  class WindowImage
    @@plan = $plan
    @@plans_camera_pos = $plans_camera_pos

    def screenshot_sketchup()
      camera_pos = @@plans_camera_pos[@@plan]

      eye = Geom::Point3d.new(camera_pos['eye']['x'] * camera_pos['eye']['factor'],
      camera_pos['eye']['y'] * camera_pos['eye']['factor'],
      camera_pos['eye']['z'] * camera_pos['eye']['factor'])

      target = Geom::Point3d.new(camera_pos['target']['x'] * camera_pos['target']['factor'],
      camera_pos['target']['y'] * camera_pos['target']['factor'],
      camera_pos['target']['z'] * camera_pos['target']['factor'])

      up = Geom::Vector3d.new(camera_pos['up']['x'] * camera_pos['up']['factor'],
      camera_pos['up']['y'] * camera_pos['up']['factor'],
      camera_pos['up']['z'] * camera_pos['up']['factor'])


      view = Sketchup.active_model.active_view
      camera = view.camera
      camera.set(eye, target, up)

      print_keys = {
          :filename => PRINT_PATH,
          :width => PRINT_WIDTH,
          :height => PRINT_HEIGHT
      }

      view.write_image(print_keys)

    end
  end
end

# Método para fazer uma solicitação à API
def fetch_data_from_api(email, password)
  uri = URI(URI_PATH)

  begin
    # Construir a solicitação POST com as credenciais
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request.body = { email: email, password: password }.to_json

    # Fazer a solicitação e obter a resposta
    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    # Verificar o código de resposta
    if response.code == '200'
      # A resposta é bem-sucedida
      UI.messagebox("Credenciais validadas com sucesso!!!")
      return response.body
    else
      # A resposta não foi bem-sucedida
      raise StandardError, "Erro na solicitação à API: #{response.code}"
    end
  rescue StandardError => e
    # Exibir um alerta em caso de erro
    UI.messagebox("Erro ao obter dados da API: #{e.message}")

    # Fechar o SketchUp em caso de erro
    if defined?(YourPluginNamespace::CloseSketchUp)
      YourPluginNamespace::CloseSketchUp.new.activate
    else
      UI.messagebox("Erro ao fechar o SketchUp: classe CloseSketchUp não encontrada.")
    end
  end
end

# Método para exibir um prompt de entrada para o usuário
def prompt_for_credentials
  prompts = ['e-mail', 'senha']
  defaults = ['', '']
  input = UI.inputbox(prompts, defaults, 'Insira suas credenciais')
  return input if input
  UI.messagebox('Operação cancelada pelo usuário.')
  if defined?(YourPluginNamespace::CloseSketchUp)
    YourPluginNamespace::CloseSketchUp.new.activate
  else
    UI.messagebox("Erro ao fechar o SketchUp: classe CloseSketchUp não encontrada.")
  end
  nil
end

# Exibir o prompt para o usuário
credentials = prompt_for_credentials

# Se as credenciais foram fornecidas, faça a solicitação à API
if credentials
  email, password = credentials
  user_authenticated = fetch_data_from_api(email, password)
  if user_authenticated
    # Se o retorno da API estiver disponível, mostrar a interface
    dialog = UI::HtmlDialog.new({
      :dialog_title => "Exemplo de Interface",
      :scrollable => true,
      :resizable => true,
      :width => WINDOW_WIDTH,
      :height => WINDOW_HEIGHT,
      :left => 100,
      :top => 100
    })

    # HTML da interface
    dialog.set_html(html_content)

    dialog.add_action_callback("paint") do |contexto, entity_attr|
      model = Sketchup.active_model
      materials = model.materials
      entities = model.entities
      customizeModel = CustomizeModel.new(model, materials, entities)
      customizeModel.apply_texture('C:\Users\Amoradev\AppData\Roaming\SketchUp\SketchUp 2021\SketchUp\Materials\SANTORINE-35-POLIDO.jpg', entity_attr)
    end

    dialog.add_action_callback("onReady") { |context|
      windowImage = YourPluginNamespace::WindowImage.new
      windowImage.screenshot_sketchup()
    }

    dialog.add_action_callback("screenshot") do |context|
      windowImage = YourPluginNamespace::WindowImage.new
      windowImage.screenshot_sketchup()
    end

    dialog.show
  end
end

unless defined?(Sketchup::Model)
  abort("This script can only be used inside SketchUp application.")
end

# Adiciona uma instância do observador ao SketchUp para observar eventos do modelo
if defined?(ModelObserver)
  Sketchup.active_model.add_observer(ModelObserver.new)
end

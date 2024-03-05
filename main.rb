require 'net/http'
require 'json'

# Define o caminho para o script que você deseja carregar automaticamente ao abrir um modelo no sketchup
cfg = JSON.parse(File.read(File.join(File.dirname(__FILE__), 'cfg.json')))
SCRIPT_PATH = cfg['script_path']
URI_PATH = cfg['uri_path']

# Verifica se o módulo Sketchup está definido antes de usar suas classes
if defined?(Sketchup::Model)
  # Define uma classe de observador para observar eventos do SketchUp
  class ModelObserver < Sketchup::ModelObserver
    # Método chamado quando um modelo é aberto
    def onOpenModel(model)
      # Carrega o script especificado
      load SCRIPT_PATH
    end
  end

  # Define uma classe de comando para fechar o SketchUp
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
  end
else
  # Se o módulo Sketchup não estiver definido, defina-o como uma classe vazia para evitar erros de execução
  module Sketchup
    class ModelObserver
      def onOpenModel(model)
      end
    end
    module YourPluginNamespace # TODO: Mudar o nome para o plugin
      class CloseSketchUp
        def initialize
        end

        def activate
          UI.messagebox("Fechando o SketchUp...")
          # TODO: Verificar com a vivian se é necessário fechar o SketchUp
          Sketchup.active_model.close
        end
      end
    end
  end
end

# Método para fazer uma solicitação à API
def fetch_data_from_api
  uri = URI(URI_PATH)

  begin
    response = Net::HTTP.get_response(uri)

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

if fetch_data_from_api
  # Se o retorno da API estiver disponível, mostrar a interface
  dialog = UI::HtmlDialog.new({
    :dialog_title => "Exemplo de Interface",
    :scrollable => true,
    :resizable => true,
    :width => 600,
    :height => 400,
    :left => 100,
    :top => 100
  })

  # HTML da interface
  dialog.set_html(<<-HTML)
    <html>
    <body>
      <button id="create_rectangle">Criar Retângulo</button>
      <button id="change_color">Pintar</button>
      <script>
        document.getElementById("create_rectangle").addEventListener("click", function() {
          sketchup.create_rectangle();
        });
        document.getElementById("change_color").addEventListener("click", function() {
          sketchup.change_color();
        });
      </script>
    </body>
    </html>
  HTML

  dialog.add_action_callback("create_rectangle") do |_|
    entidades = Sketchup.active_model.entities
    ponto1 = [0, 0, 0]
    ponto2 = [100, 100, 0]
    entidades.add_face(ponto1, [ponto1.x, ponto2.y, ponto1.z], ponto2, [ponto2.x, ponto1.y, ponto1.z])
  end

  dialog.add_action_callback("change_color") do |_|
    # Acessar o modelo ativo e a seleção atual
    model = Sketchup.active_model
    selection = model.selection

    # Verificar se há exatamente um objeto selecionado e se é uma face
    if selection.length == 1
      # Realizar operações na face selecionada
      face_selecionada = selection[0]

      # Por exemplo, aplicar um material à face
      materials = model.materials
      material = materials.add("Cor Personalizada")
      material.color = "Red"
      face_selecionada.material = material
    end
  end

  dialog.show
end

# Adiciona uma instância do observador ao SketchUp para observar eventos do modelo
if defined?(ModelObserver)
  Sketchup.active_model.add_observer(ModelObserver.new)
end
# CAMERA PERSPECTIVES
view1 = 'view1'
view2 = 'view2'
env1 = {
        view1 => {'eye' => {'x' => 233.279284, 'y' => 49.104185, 'z' => 2.248919, 'factor' => 39.3700787},
                      'target' => {'x' => 244.615248, 'y' => 72.603167, 'z' => -1.159174, 'factor' => 39.3700787},
                      'up'=> {'x' => 0.0528586, 'y' => 0.115811, 'z' => 0.991864, 'factor' => 39.3700787}},

        view2 => {'eye' => {'x' => 220.279284, 'y' => 40.104185, 'z' => 2.248919, 'factor' => 39.3700787},
                      'target' => {'x' => 244.615248, 'y' => 72.603167, 'z' => -1.159174, 'factor' => 39.3700787},
                      'up'=> {'x' => 0.0528586, 'y' => 0.115811, 'z' => 0.991864, 'factor' => 39.3700787}}
        }
$plans_camera_pos = {
                      'env1' =>
                      {
                        view1 => env1[view1],
                        view2 => env1[view2]
                      }
                    }

# GENERAL
$entities_dict = 'entities_'
$entities_dict_key = 'entity_attr'

# TODO: Remove Amoradev and set Username
$command_file = 'C:\Users\Amoradev\AppData\Roaming\SketchUp\SketchUp 2021\SketchUp\Plugins\command.txt'

$PRINT_WIDTH = 1600
$PRINT_HEIGHT = 720
# TODO: Remove Amoradev and set Username
$PRINT_PATH = 'C:\Users\Amoradev\AppData\Roaming\Apache24\htdocs\assets\img\prints'
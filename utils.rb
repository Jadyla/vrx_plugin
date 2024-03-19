# CAMERA PERSPECTIVES
# variables
view1 = 'view1'
view2 = 'view2'
view3 = 'view3'
# /variables

# area_lazer
area_lazer = {view1 => {'eye' => {'x' => 233.279284, 'y' => 49.104185, 'z' => 2.248919, 'factor' => 39.3700787},
                           'target' => {'x' => 244.615248, 'y' => 72.603167, 'z' => -1.159174, 'factor' => 39.3700787},
                           'up'=> {'x' => 0.0528586, 'y' => 0.115811, 'z' => 0.991864, 'factor' => 39.3700787}},

              view2 => {'eye' => {'x' => 233.279284, 'y' => 49.104185, 'z' => 2.248919, 'factor' => 39.3700787},
                           'target' => {'x' => 244.615248, 'y' => 72.603167, 'z' => -1.159174, 'factor' => 39.3700787},
                           'up'=> {'x' => 0.0528586, 'y' => 0.115811, 'z' => 0.991864, 'factor' => 39.3700787}},

              view3 => {'eye' => {'x' => 233.279284, 'y' => 49.104185, 'z' => 2.248919, 'factor' => 39.3700787},
                           'target' => {'x' => 244.615248, 'y' => 72.603167, 'z' => -1.159174, 'factor' => 39.3700787},
                           'up'=> {'x' => 0.0528586, 'y' => 0.115811, 'z' => 0.991864, 'factor' => 39.3700787}}}


#$plans_camera_pos = {'area_lazer' => area_de_lazer}
$plans_camera_pos = {'area_lazer' => {view1 => area_lazer[view1],
                                      view2 => area_lazer[view2],
                                      view3 => area_lazer[view3]}}

# GENERAL
$entities_dict = 'entities_'
$entities_dict_key = 'entity_attr'

$command_file = 'C:\Users\Amoradev\AppData\Roaming\SketchUp\SketchUp 2021\SketchUp\Plugins\command.txt'

$PRINT_WIDTH = 1105
$PRINT_HEIGHT = 1024
$PRINT_PATH = 'C:\Users\Amoradev\AppData\Roaming\SketchUp\SketchUp 2021\SketchUp\Plugins\print.png'
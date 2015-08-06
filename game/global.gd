extends Node

var distance_travelled = 0
var current_scene
var game = "res://game/mainScene/MainScene.xml"
var screen_speed = 1
var original_screen_speed = 1
var gravity = 200
var coin_timeout = 1.5
var alturaTerr = 270
var player_id
var coin_count = 0
var stamina = [100, 100, 100]
var actual_animal = 0
var blockChange = false

#The root node of the Main Scene
var root
#The layer where the main game runs
var main_scene

var viewWidth

func load_hud(path):
	var _scene = ResourceLoader.load(path)
	var scene = _scene.instance()
	scene.add_to_group("HUD")
	return scene

#Loads the intro scene
#path: String containing the intro scene
func load_intro(path):
	get_tree().get_nodes_in_group("HUD")[0].hide()
	change_scene(path)


func load_level(path):
	get_tree().get_nodes_in_group("HUD")[0].show()
	change_scene(path)

func change_scene(scene_path):
	if(current_scene!=null):
		current_scene.queue_free()
	var s = ResourceLoader.load(scene_path)
	current_scene = s.instance()
	main_scene.add_child(current_scene)
	

func restart():
	change_scene(game)
	
	
	
func _ready():
	#screen_speed = original_screen_speed
	var rootView = get_tree().get_root().get_rect()
	var _root = get_tree().get_root()
	viewWidth = rootView.size.width
	alturaTerr = rootView.size.height
	root = _root.get_child(_root.get_child_count()-1)
	main_scene = root.get_node("MainLayer")
	
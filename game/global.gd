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

#The root node of the Main Scene
var root
#The layer where the main game runs
var main_scene

var viewWidth

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
	
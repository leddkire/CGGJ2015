extends Node

var distance_travelled = 0
var current_scene
var game = load("res://game/mainScene/MainScene.xml")
var screen_speed = 1
var original_screen_speed = 1
var gravity = 200
var coin_timeout = 1.5
var alturaTerr = 270
var player_id
var coin_count = 0


var viewWidth


func restart():
	current_scene.queue_free()
	current_scene= game.instance()
	get_tree().get_root().add_child(current_scene)
	
func _ready():
	#screen_speed = original_screen_speed
	var rootView = get_tree().get_root().get_rect()
	var root = get_tree().get_root()
	viewWidth = rootView.size.width
	alturaTerr = rootView.size.height
	current_scene = root.get_child(root.get_child_count()-1)
	
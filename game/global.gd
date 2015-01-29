extends Node

var distance_travelled = 0
var current_scene
var game = preload("res://game/mainScene.scn")
var screen_speed = 3

func restart():
	current_scene.queue_free()
	current_scene= game.instance()
	get_tree().get_root().add_child(current_scene)
	
	
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count()-1)
	
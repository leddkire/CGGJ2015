
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _fixed_process(delta):
	if(Input.is_action_pressed("restart")):
		get_node("/root/global").restart()
		set_fixed_process(false)

		

func _ready():
	# Initalization here
	set_fixed_process(true)



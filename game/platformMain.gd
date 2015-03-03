
extends StaticBody2D
var dirt = preload("res://textures/dirt.tex")
var agua = preload("res://textures/waterMid.tex")
var type = "agua"
# member variables here, example:
# var a=2
# var b="textvar"

func set_type(t):
	type = t
	if(type == "agua"):
		get_node("Sprite").set_texture(agua)
	else:
		get_node("Sprite").set_texture(dirt)		

func _ready():
	# Initalization here
	pass



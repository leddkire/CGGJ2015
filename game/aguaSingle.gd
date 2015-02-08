
extends Node2D

var watIn = preload("res://textures/waterIn.tex")
var watOut = preload("res://textures/waterOut.tex")

func move(cant):
	var hijos = get_children()
	for i in hijos:
		var posicion = i.get_pos()
		posicion.x -= cant
		i.set_pos(posicion)
	#if posicion.x <= -32:
	#	queue_free()
	#else:
	
func set_sprite(cual):
	if(cual == 'first'):
		get_node("waterMid").set_texture(watIn)
	elif(cual == 'last'):
		get_node("waterMid").set_texture(watOut)
	
	
func get_size():
	var hijos = get_child_count()
	return 64*hijos
	 
func get_type():
	return 'agua'

func _ready():
	# Initalization here
	pass



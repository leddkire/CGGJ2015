
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func add_terr_sprite(rand):
	var base = get_node("agua")
	var posicionAcumulada = base.get_pos()
	
	while rand > 0:
		var newSprite = base.duplicate()
		posicionAcumulada.x += 64
		newSprite.set_pos(posicionAcumulada)
		add_child(newSprite)
		rand -= 1
		
func move(cant):
	var hijos = get_children()
	for i in hijos:
		var posicion = i.get_pos()
		posicion.x -= cant
		i.set_pos(posicion)
	#if posicion.x <= -32:
	#	queue_free()
	#else:
	
func add_water():
	var baseOut = get_node("waterOut")
	var baseMid = get_node("waterMid")
	var newWater = baseMid.duplicate()
	var posicionNew = newWater.get_pos()
	var posicionOut = baseOut.get_pos()
	posicionNew.x = posicionOut.x
	posicionOut.x += 64
	newWater.set_pos(posicionNew)
	baseOut.set_pos(posicionOut)
	
func get_size():
	var hijos = get_child_count()
	return 64*hijos
	 
func get_type():
	return 'agua'

func _ready():
	# Initalization here
	pass



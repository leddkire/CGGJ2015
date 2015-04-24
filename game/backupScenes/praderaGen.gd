
extends Node2D

func add_terr_sprite(rand):
	var base = get_node("pradera")
	var posicionAcumulada = base.get_pos()
	
	while rand > 0:
		var newSprite = base.duplicate()
		posicionAcumulada.x += 64
		newSprite.set_pos(posicionAcumulada)
		add_child(newSprite)
		rand -= 1
		
func move(cant):
	var posicion = get_pos()
	posicion.x -= cant
	set_pos(posicion)
		
func get_type():
	return 'pradera'

func _ready():
	# Initalization here
	pass



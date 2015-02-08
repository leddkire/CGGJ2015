
extends Node2D
		
func move(cant):
	var posicion = get_pos()
	posicion.x -= cant
	set_pos(posicion)
		
func get_type():
	return 'pradera'

func _ready():
	# Initalization here
	pass



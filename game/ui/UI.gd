
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"


var blockChange = false
var posBlockBar = 100

func _process(delta):
	var stamina = get_node("/root/global").stamina
	var distance = get_node("/root/global").distance_travelled
	get_node("stamina_bars/ciervo/stamina").set_value(stamina[0])
	get_node("stamina_bars/sapo/stamina").set_value(stamina[1])
	get_node("stamina_bars/goat/stamina").set_value(stamina[2])
	get_node("header/distance").set_text(str(int(distance)))

func _ready():
	set_process(true)

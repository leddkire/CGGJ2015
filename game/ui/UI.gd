
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"


var blockChange = false
var posBlockBar = 100

func _unblock_change():
	blockChange = false

func _ready():
	get_node("charCd").connect("timeout",self,"_unblock_change")

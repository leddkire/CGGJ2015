extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var bar = 110
var color = Color(255,150,0)
var white = Color(0,0,0)
var timer
var maxH
var actA

func _draw():
	actA = get_parent().get_parent().get_node("player").actual_animal
	var staminaLeft = 0
	if(actA < 3):
		staminaLeft = get_parent().get_parent().get_node("player").stamina[actA]
	var h = maxH * (staminaLeft/100)

	draw_rect(Rect2(20,100,10,h),color)
	update()


func _process(delta):
	_draw()
	
func _ready():
	var posBlockBar = get_parent().posBlockBar
	maxH = posBlockBar
	set_process(true)
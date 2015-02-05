
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var bar = 110
var color = Color(255,0,0)
var white = Color(0,0,0)
var timer

func _draw():
	if(get_parent().blockChange):
		var w = 110 * (timer.get_time_left()/timer.get_wait_time())

		draw_rect(Rect2(-28,0,w,15),color)
		update()
	else:
		update()

func _process(delta):
	_draw()



func _ready():
	timer = get_parent().get_node("charCd")
	set_process(true)



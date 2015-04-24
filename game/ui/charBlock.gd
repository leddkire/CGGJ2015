
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var bar = 110
var color = Color(255,0,0)
var white = Color(0,0,0)
var timer
var maxW

func _draw():
	if(get_parent().blockChange):
		var w = maxW * (timer.get_time_left()/timer.get_wait_time())
		
		#draw_rect(Rect2(40,100,w,15),color)
		update()
	else:
		update()

func _process(delta):
	update()



func _ready():
	maxW = get_parent().get_node("header").get_pos().x
	timer = get_parent().get_node("charCd")
	set_process(true)




extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var mount1 = preload("res://images/mountains/mountain1.png")
var mount2 = preload("res://images/mountains/mountain2.png")
var mount3 = preload("res://images/mountains/mountain3.png")

var mount1Width = mount1.get_width()
var mount2Width = mount2.get_width()
var mount3Width = mount3.get_width()

var mount1List = []
var mount2List = []
var mount3List = []

var altura = 196

var mount1S
var mount2S
var mount3S

var viewWidth

class Mountain:
	var pos = Vector2()

func _draw():
	for i in range(mount3List.size()-1):
		draw_texture(mount3,mount3List[i].pos)

	for i in range(mount2List.size()-1):
		draw_texture(mount2,mount2List[i].pos)
		
	

	for i in range(mount1List.size()-1):
		draw_texture(mount1,mount1List[i].pos)
	
	
	
func _process(delta):
	mount1S = get_node("/root/global").screen_speed *0.8
	mount2S = mount1S * 0.6
	mount3S = mount1S * 0.4
	
	for i in range(mount1List.size()-1):
		mount1List[i].pos.x -= mount1S
		if(mount1List[i].pos.x <= -mount1Width):
			mount1List[i].pos.x = viewWidth + mount1Width
	
	for i in range(mount2List.size()-1):
		mount2List[i].pos.x -= mount2S
		if(mount2List[i].pos.x <= -mount2Width):
			mount2List[i].pos.x = viewWidth + mount2Width
		
	for i in range(mount3List.size()-1):
		mount3List[i].pos.x -= mount3S
		if(mount3List[i].pos.x <= -mount3Width):
			mount3List[i].pos.x = viewWidth + mount3Width
		
	
		
	if(mount2List[0].pos.x <= -mount2Width):
		mount2List[0].pos.x = mount2List[mount2List.size()-1].pos.x + mount2Width
		
	if(mount3List[0].pos.x <= -mount1Width):
		mount3List[0].pos.x = mount3List[mount3List.size()-1].pos.x + mount3Width
	
	update()

func _ready():
	# Initalization here
	viewWidth = get_node("/root/global").viewWidth
	var mount1Count = viewWidth/mount1Width +3
	var mount2Count = viewWidth/mount2Width + 3
	var mount3Count = viewWidth/mount3Width + 4
	
	for i in range(mount1Count):
		var m = Mountain.new()
		m.pos = Vector2(i*mount1Width,altura)
		mount1List.append(m)
		
	for i in range(mount2Count):
		var m = Mountain.new()
		m.pos = Vector2(i*mount2Width,altura-12)
		mount2List.append(m)
		
	for i in range(mount3Count):
		var m = Mountain.new()
		m.pos = Vector2(i*mount3Width,altura-30)
		mount3List.append(m)
	
	mount1S = get_node("/root/global").screen_speed *0.8
	mount2S = mount1S * 0.6
	mount3S = mount1S * 0.4
	
	
	set_process(true)




extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var mount1 = load("res://game/parallaxMountains/mountain1.png")
var mount2 = load("res://game/parallaxMountains/mountain2.png")
var mount3 = load("res://game/parallaxMountains/mountain3.png")

var cloudTexts = []
var cloudTexts1= load("res://game/clouds/cloud1.png")
var cloudTexts2 = load("res://game/clouds/cloud2.png")
var	cloudTexts3 = load("res://game/clouds/cloud3.png")


var mount1Width = mount1.get_width()
var mount2Width = mount2.get_width()
var mount3Width = mount3.get_width()

var mount1List = []
var mount2List = []
var mount3List = []

var cloud1List = []
var cloud2List = []
var cloud3List = []

var altura = 0
var cloudSpeed

var mount1S
var mount2S
var mount3S

var numClouds
var genClouds = false

var viewWidth
var offset = 4

class Cloud:
	var pos = Vector2()
	var tex = Resource
	var speed = float()

class Mountain:
	var pos = Vector2()

func _draw():
	for i in range(mount3List.size()-1):
		draw_texture(mount3,mount3List[i].pos)

	for i in range(mount2List.size()-1):
		draw_texture(mount2,mount2List[i].pos)
		
	

	for i in range(mount1List.size()-1):
		draw_texture(mount1,mount1List[i].pos)
	
	for i in range(cloud1List.size()-1):
		draw_texture(cloud1List[i].tex,cloud1List[i].pos)
	
	
func _process(delta):
	mount1S = get_node("/root/global").screen_speed *0.8
	mount2S = mount1S * 0.6
	mount3S = mount1S * 0.4
	
	for i in range(mount1List.size()-1):
		mount1List[i].pos.x -= mount1S
		if(mount1List[0].pos.x <= -mount1Width):
			mount1List.remove(0)
			var m = Mountain.new()
			m.pos = Vector2(mount1List[mount1List.size()-1].pos.x,altura)
			mount1List.append(m)
	
	for i in range(mount2List.size()-1):
		mount2List[i].pos.x -= mount2S
		if(mount2List[0].pos.x <= -mount2Width):
			mount2List.remove(0)
			var m = Mountain.new()
			m.pos = Vector2(mount2List[mount2List.size()-1].pos.x,altura-12)
			mount2List.append(m)
		
	for i in range(mount3List.size()-1):
		mount3List[i].pos.x -= mount3S
		if(mount3List[0].pos.x <= -mount3Width):
			mount3List.remove(0)
			var m = Mountain.new()
			m.pos = Vector2(mount3List[mount3List.size()-1].pos.x,altura-30)
			mount3List.append(m)
	
	
	
	#cloud Movement
	var listToRemove = []
	for i in range(cloud1List.size()-1):
		cloud1List[i].pos.x -= cloud1List[i].speed
		if(cloud1List[i].pos.x <= -150):
			listToRemove.append(i)
	
	for i in range(listToRemove.size()-1):
		cloud1List.remove(listToRemove[i])
		
	listToRemove.clear()
	update()
	
	if(genClouds):
		_genCloud()

func _genCloud():
	#cloud Generation
	numClouds = rand_range(0,5)
	for i in range(numClouds):
		var c = Cloud.new()
		c.pos = Vector2(viewWidth+ 20*int(rand_range(0,4)),20*int(rand_range(1,6)))
		c.tex = cloudTexts[int(int(rand_range(0,100))%3)]
		c.speed = cloudSpeed * rand_range(0.4,1)
		cloud1List.append(c)
	genClouds = false

func _setGen():
	genClouds = true

func _ready():

	cloudTexts.append(cloudTexts1)
	cloudTexts.append(cloudTexts2)
	cloudTexts.append(cloudTexts3)
	get_node("CloudGenTimer").connect("timeout",self,"_setGen")
	altura = get_node("/root/global").alturaTerr - 45
	# Initalization here
	viewWidth = get_node("/root/global").viewWidth
	#El offset es para que se dibujen hasta el ancho de la pantalla
	#Lo ideal seria que no se tuviese que utilizar este valor
	var mount1Count = viewWidth/mount1Width + offset
	var mount2Count = viewWidth/mount2Width + offset
	var mount3Count = viewWidth/mount3Width + offset
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
	cloudSpeed = get_node("/root/global/").screen_speed
	mount1S = get_node("/root/global").screen_speed *0.8
	mount2S = mount1S * 0.6
	mount3S = mount1S * 0.4
	
	
	set_process(true)



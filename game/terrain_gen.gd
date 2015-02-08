extends Node2D

var sceneMontana = load("res://game/montana.scn")
var scenePradera = preload("res://game/pradera.scn")
var sceneAgua = preload("res://game/agua.scn")

var numM
var numP
var numA
var terrainContainer = []

func _process(delta):
	pass

func _ready():
	numA = int(rand_range(3,5))
	numP = int(rand_range(3,5))
	numA = int(rand_range(3,5))
	set_process(true)



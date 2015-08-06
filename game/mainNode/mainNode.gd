
extends Node

#Starts the game

func _ready():
	get_node("/root/global").change_scene("res://game/title/title.xml")
	


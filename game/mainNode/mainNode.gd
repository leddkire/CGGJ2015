
extends Node

#Starts the game

#Path to the main UI
var ui_path = "res://game/ui/UI.xml"

func _ready():
	var ui = get_node("/root/global").load_hud(ui_path)
	get_node("UILayer").add_child(ui)
	get_node("/root/global").load_intro("res://game/title/title.xml")
	
	


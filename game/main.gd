var FACTOR_MEDIO = 1
var FACTOR_ALTO = 1.5
var FACTOR_BAJO = 0.5

var death_margin = -80

var dead = false

var gameOver = load("res://game/gameOver.xml")


func _process(delta):
	if(not dead):
		
		var player = get_node("player")
		var spritePosX = get_node("player/sprite").get_pos().x
		if(spritePosX <= death_margin):
			dead = true
		var animal_actual = player.actual_animal
		var terreno_actual = get_node("terrain").where_am_i(player.get_pos().x + spritePosX)
		if (terreno_actual == "montana"):
			if(animal_actual == 0):
				player.stamina_factor = FACTOR_ALTO
				player.direction = -1
			if(animal_actual == 1):
				player.stamina_factor = FACTOR_MEDIO
				player.direction = -1
			if(animal_actual == 2):
				player.stamina_factor = FACTOR_BAJO
				player.direction = 1
		elif (terreno_actual == "agua"):
			if(animal_actual == 0):
				player.stamina_factor = FACTOR_MEDIO
				player.direction = -1
			if(animal_actual == 1):
				player.stamina_factor = FACTOR_BAJO
				player.direction = 1
			if(animal_actual == 2):
				player.stamina_factor = FACTOR_ALTO
				player.direction = -1
		elif (terreno_actual == "pradera"):
			if(animal_actual == 0):
				player.stamina_factor = FACTOR_BAJO
				player.direction = 1
			if(animal_actual == 1):
				player.stamina_factor = FACTOR_ALTO
				player.direction = -1
			if(animal_actual == 2):
				player.stamina_factor = FACTOR_MEDIO
				player.direction = -1
		
	if(dead):
		
		get_node("UI").queue_free()
		get_node("player").queue_free()
		get_node("StreamPlayer").queue_free()
		get_node("terrain").queue_free()
		get_node("Parallax").queue_free()
		var gameOverNode = gameOver.instance()
		add_child(gameOverNode)
		set_process(false)
		get_node("/root/global").screen_speed = get_node("/root/global").original_screen_speed

		
	
	
	
func _ready():
	set_process(true)
	pass

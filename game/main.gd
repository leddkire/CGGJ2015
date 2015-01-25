var FACTOR_MEDIO = 1
var FACTOR_ALTO = 1.5
var FACTOR_BAJO = 0.5


func _fixed_process(delta):
	var terreno_actual = get_node("terrain").tipoActual
	var player = get_node("player")
	var animal_actual = player.actual_animal
	
	if (terreno_actual == "montana"):
		if(animal_actual == 0):
			player.stamina_factor = FACTOR_ALTO
		if(animal_actual == 1):
			player.stamina_factor = FACTOR_MEDIO
		if(animal_actual == 2):
			player.stamina_factor = FACTOR_BAJO
	elif (terreno_actual == "agua"):
		if(animal_actual == 0):
			player.stamina_factor = FACTOR_MEDIO
		if(animal_actual == 1):
			player.stamina_factor = FACTOR_BAJO
		if(animal_actual == 2):
			player.stamina_factor = FACTOR_ALTO
	elif (terreno_actual == "pradera"):
		if(animal_actual == 0):
			player.stamina_factor = FACTOR_BAJO
		if(animal_actual == 1):
			player.stamina_factor = FACTOR_ALTO
		if(animal_actual == 2):
			player.stamina_factor = FACTOR_MEDIO
func _ready():
	set_fixed_process(true)
	pass

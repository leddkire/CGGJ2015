
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var coin_scene = load("res://game/coin/coin.scn")
var coin_timeout
var coin_timeout_max
var random_seed = randf()
var random_arr = [1, random_seed]
var alturaTerr
var screenW

func _get_random():
	#Se consigue un numero random entre 1 y 4. Si no cambia, revisar el seed.
	random_arr = rand_seed(random_arr[1])
	random_arr[0] = int(random_arr[0] % 4)
	random_arr[0] += 4
	return random_arr[0]

func _process(delta):
		# Generador de monedas
	coin_timeout -= delta
	if (coin_timeout <= 0):
		var new_coin = coin_scene.instance()
		new_coin.add_to_group("Coins")
		var ran = _get_random()
		if (ran < 6):
			new_coin.set_pos(Vector2(screenW, alturaTerr-38))
		else:
			new_coin.set_pos(Vector2(screenW, alturaTerr - 66))
		add_child(new_coin)
		coin_timeout = coin_timeout_max


func _ready():
	#Obtener anchura de la pantalla (root viewport)
	screenW = get_tree().get_root().get_rect().size.width
	alturaTerr = get_node("/root/global").alturaTerr
	coin_timeout = get_node("/root/global").coin_timeout
	coin_timeout_max = coin_timeout
	set_process(true)



var deer = preload("res://textures/deer.tex")
var toad = preload("res://textures/toad.tex")
var goat = preload("res://textures/goat.tex")
var capybara = preload("res://textures/capybara.tex")
var coin_scene = preload("res://game/coin.scn")
var jumping = false
# Factor de salto
var alt = 1.2
var stamina = [100, 100, 100]
var actual_animal = 0
var max_stamina = 0 #Que animal tiene más stamina
var distance = 0
var coin_timeout = 1.5
var coins_acum = 0
var base_y = 0
var random_seed = randf()
var random_arr = [1, random_seed]
var capybara_timeout = 0

var STEP_DISTANCE = 0.1
var AMOUNT_RECOVERY = 0.1
var BASE_STAMINA_CONS = 0.2
var stamina_factor = 1

func _get_random():
	#Se consigue un numero random entre 1 y 4. Si no cambia, revisar el seed.
	random_arr = rand_seed(random_arr[1])
	random_arr[0] = int(random_arr[0] % 4)
	random_arr[0] += 4
	return random_arr[0]

func _fixed_process(delta):
	var jump = Input.is_action_pressed("jump")
	var animal_1 = Input.is_action_pressed("animal_1")
	var animal_2 = Input.is_action_pressed("animal_2")
	var animal_3 = Input.is_action_pressed("animal_3")
	var sprite = get_node("sprite")
	var pos = sprite.get_pos()
	
	# Distancia recorrida
	distance += STEP_DISTANCE
	get_node("distance").set_text(str(int(distance)))
	get_node("coins_label").set_text(str(int(coins_acum)))

	# Control de stamina
	for i in range(3):
		if (actual_animal != i):
			if (stamina[i] < 100):
				stamina[i] += AMOUNT_RECOVERY
			if (stamina[i] > stamina[max_stamina]):
				max_stamina = i
		else:
			stamina[i] -= BASE_STAMINA_CONS * stamina_factor
			if (stamina[i] <= 0):
				if (max_stamina == 0):
					sprite.set_texture(deer)
					actual_animal = 0
				elif (max_stamina == 1):
					sprite.set_texture(toad)
					actual_animal = 1
				else:
					sprite.set_texture(goat)
					actual_animal = 2
	
	# Cambio de sprites
	if (not jumping and capybara_timeout <= 0):
		if (animal_1):
			if (actual_animal != 0):
				sprite.set_texture(deer)
				actual_animal = 0
		if (animal_2):
			if (actual_animal != 1):
				actual_animal = 1
				sprite.set_texture(toad)
		if (animal_3):
			if (actual_animal != 2):
				actual_animal = 2
				sprite.set_texture(goat)


	get_node("stamina1").set_value(stamina[0])
	get_node("stamina2").set_value(stamina[1])
	get_node("stamina3").set_value(stamina[2])
	
	
	# Salto
	if (jump and not jumping):
		jumping = true
		get_node("anim").stop()
		sprite.set_frame(0)
	
	if(jumping):
		alt -= 0.04
		if (alt > -1.2):
			if (pos.y > 0):
				sprite.set_pos(Vector2(pos.x, 0))
				jumping = false
				alt = 1.2
				get_node("anim").play("running")
			else:
				pos += Vector2(0,-alt)
				sprite.set_pos(pos)
		else:
			jumping = false
			alt = 1.2
			get_node("anim").play("running")

	# Generador de monedas
	coin_timeout -= delta
	if (coin_timeout <= 0):
		var new_coin = coin_scene.instance()
		new_coin.add_to_group("Coins")
		var ran = _get_random()
		if (ran < 6):
			new_coin.set_pos(Vector2(240, 10))
		else:
			new_coin.set_pos(Vector2(240, -16))
		add_child(new_coin)
		coin_timeout = 1.5

	# Colisiones con monedas
	var coins = get_tree().get_nodes_in_group("Coins")
	for i in range(coins.size()):
		var elem = coins[i]
		var elem_pos = elem.get_pos()
		if (elem_pos.x <= pos.x+10 and elem_pos.y <= pos.y+20 and elem_pos.y >= pos.y-15):
			elem.queue_free()
			coins_acum += 1

	if (coins_acum % 20 == 0 and coins_acum != 0):
		sprite.set_texture(capybara)
		actual_animal = 3
		capybara_timeout = 8
		
	if (capybara_timeout > 0):
		capybara_timeout -= delta
		if (capybara_timeout <= 0):
			if (max_stamina == 0):
				sprite.set_texture(deer)
				actual_animal = 0
			elif (max_stamina == 1):
				sprite.set_texture(toad)
				actual_animal = 1
			else:
				sprite.set_texture(goat)
				actual_animal = 2

func _ready():
	# Initalization here
	get_node("sprite").set_texture(deer)
	get_node("anim").play("running")
	actual_animal = 0
	max_stamina = 0
	distance = 0
	set_fixed_process(true)
	pass

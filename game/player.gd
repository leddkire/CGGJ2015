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
var last_distance = 0
var raycast = false
var current_state
var prev_state
var output_state
var state_old

var STEP_DISTANCE = 0.1
var AMOUNT_RECOVERY = 0.1
var BASE_STAMINA_CONS = 0.2
var stamina_factor = 1
var direction = 0
var DISTANCE_TO_GROW = 100
var JUMP_FORCE = 100

var numAnimals = 3

var capybaraId = numAnimals

var screenW = 480

#posicion original del sprite (para cuando se recupere el animal se pueda trasladar el sprite a este sitio.)
var originalSpriteXPos
var originalSpriteYPos
#Velocidad en la que el animal se traslada a traves de la pantalla
var travelSpeed = 0.5
#Velocidad de recuperacion
var recoverSpeed = 2
#Variable que guarda la diferencia entre la posicion actual y el traslado que se le hara
var diferencialPosX
#Variable que determina que tanto se puede adelantar el jugador cuando esta utilizando bien las mecanicas de terreno
var maxDistance = 80



func _get_random():
	#Se consigue un numero random entre 1 y 4. Si no cambia, revisar el seed.
	random_arr = rand_seed(random_arr[1])
	random_arr[0] = int(random_arr[0] % 4)
	random_arr[0] += 4
	return random_arr[0]
	
func check(name):
	var input = Input.is_action_pressed(name)
	prev_state = current_state
	current_state = input
	
	state_old = output_state
	if not prev_state and not current_state:
		output_state = 0
	if not prev_state and current_state:
		output_state = 1
	if prev_state and current_state:
		output_state = 2
	if prev_state and not current_state:
		output_state = 3
		
	return output_state

func _process(delta):
	var jump = Input.is_action_pressed("jump")
	var animal_1 = Input.is_action_pressed("animal_1")
	var animal_2 = Input.is_action_pressed("animal_2")
	var animal_3 = Input.is_action_pressed("animal_3")
	var sprite = get_node("sprite")
	var pos = sprite.get_pos()
	# Distancia recorrida
	distance += STEP_DISTANCE
	get_parent().get_node("UI/header/distance").set_text(str(int(distance)))
	get_parent().get_node("UI/header/coins_label").set_text(str(int(coins_acum)))
	#Si se recorre cierta distancia, se incrementa la velocidad
	if(distance-last_distance >= DISTANCE_TO_GROW):
		get_node("/root/global").screen_speed += 0.1
		last_distance = distance
		BASE_STAMINA_CONS += 0.1
	var posXActual = get_node("sprite").get_pos().x
	diferencialPosX = posXActual
	# Control de stamina
	# Control de stamina
	for i in range(numAnimals):
		if (actual_animal != i):
			if (stamina[i] < 100):
				stamina[i] += AMOUNT_RECOVERY
			if (stamina[i] > stamina[max_stamina]):
				max_stamina = i
		else:
			#Si el stamina del animal actual es mayor a 0, restarle stamina
			if(stamina[i] > 0):
				stamina[i] -= BASE_STAMINA_CONS * stamina_factor
				#Si esta mas atras de la posicion original del sprite, se traslada hasta estar ahi
				if(posXActual < originalSpriteXPos):
					diferencialPosX += recoverSpeed
					if(diferencialPosX > originalSpriteXPos):
						diferencialPosX = originalSpriteXPos
						
				if(posXActual <= maxDistance and posXActual >= originalSpriteXPos):
					diferencialPosX += travelSpeed*direction
					if(diferencialPosX < originalSpriteXPos):
						diferencialPosX = originalSpriteXPos
					elif(diferencialPosX > maxDistance):
						diferencialPosX = maxDistance

				get_node("sprite").set_pos(Vector2(diferencialPosX,0))
				
			if (stamina[i] <= 0):
				diferencialPosX -= travelSpeed
				get_node("sprite").set_pos(Vector2(diferencialPosX,0))
	if(actual_animal == capybaraId):
		if(posXActual < originalSpriteXPos):
			diferencialPosX += recoverSpeed
			if(diferencialPosX > originalSpriteXPos):
				diferencialPosX = originalSpriteXPos
		if(posXActual <= maxDistance and posXActual >= originalSpriteXPos):
			diferencialPosX += travelSpeed
			if(diferencialPosX < originalSpriteXPos):
				diferencialPosX = originalSpriteXPos
			elif(diferencialPosX > maxDistance):
				diferencialPosX = maxDistance

		get_node("sprite").set_pos(Vector2(diferencialPosX,0))
	
	
	var blockChange = get_parent().get_node("UI").blockChange
	# Cambio de sprites
	# Cambio de sprites
	if (not jumping and capybara_timeout <= 0 and not(blockChange)):
		if (animal_1):
			if (actual_animal != 0):
				sprite.set_texture(deer)
				actual_animal = 0
				get_parent().get_node("UI").blockChange = true
				get_parent().get_node("UI/charCd").start()
		if (animal_2):
			if (actual_animal != 1):
				actual_animal = 1
				sprite.set_texture(toad)
				get_parent().get_node("UI/charCd").start()
				get_parent().get_node("UI").blockChange = true
		if (animal_3):
			if (actual_animal != 2):
				actual_animal = 2
				sprite.set_texture(goat)
				get_parent().get_node("UI/charCd").start()
				get_parent().get_node("UI").blockChange = true
	get_parent().get_node("UI/stamina_bars/ciervo/stamina").set_value(stamina[0])
	get_parent().get_node("UI/stamina_bars/sapo/stamina").set_value(stamina[1])
	get_parent().get_node("UI/stamina_bars/goat/stamina").set_value(stamina[2])


	# Salto
	if (jump and not jumping):
		jumping = true
		get_node("anim").stop()
		sprite.set_frame(0)
	if(jumping):
		alt -= 0.04
		if (alt > -1.2):
			if (pos.y > 0):
				sprite.set_pos(Vector2(diferencialPosX, 0))
				jumping = false
				alt = 1.2
				get_node("anim").play("running")
			else:
				pos += Vector2(0,-alt)
				sprite.set_pos(Vector2(diferencialPosX,pos.y))
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
			new_coin.set_pos(Vector2(screenW, 10))
		else:
			new_coin.set_pos(Vector2(screenW, -16))
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
		actual_animal = capybaraId
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
				
		
		
func _exit_tree():
	get_node("/root/global").distance_travelled = distance

func _ready():
	# Initalization here
	get_node("sprite").set_texture(deer)
	get_node("anim").play("running")
	originalSpriteXPos = get_node("sprite").get_pos().x
	diferencialPosX = 0
	actual_animal = 0
	max_stamina = 0
	distance = 0
	set_process(true)
	pass

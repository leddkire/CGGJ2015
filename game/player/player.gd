extends KinematicBody2D

var deer = load("res://game/player/deer.png")
var toad = load("res://game/player/toad.png")
var goat = load("res://game/player/goat.png")
var capybara = load("res://game/player/capybara.png")
var coin_scene = load("res://game/coin/coin.xml")
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

var playedCapySound = false

#posicion original del sprite (para cuando se recupere el animal se pueda trasladar el sprite a este sitio.)
var originalSpriteXPos
var originalSpriteYPos
#Velocidad en la que el animal se traslada a traves de la pantalla
var travelSpeed = 30
#Velocidad de recuperacion
var recoverSpeed = 80
#Variable que guarda la diferencia entre la posicion actual y el traslado que se le hara
var diferencialPosX
#Variable que determina que tanto se puede adelantar el jugador cuando esta utilizando bien las mecanicas de terreno
var maxDistance = 120
var mediumPos = 60

#Variables de debugging
#Variable que elimina stamina (para probar cosas)
var godMode = false
#Variable para decirle al programa que dibuje la posicion del jugador
var drawPlayerPos = false
 
#variables de movimiento para las fisicas
var velocity = Vector2()
var jumpForce = 100
var gravity
var recovering = false

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

func _draw():
	if(drawPlayerPos):
		var sprite = get_node("sprite")
		var pos = get_pos()
		draw_rect(Rect2(pos.x,pos.y,5,100),Color(0,0,255))

func _fixed_process(delta):
	var jump = Input.is_action_pressed("jump")
	var motion = Vector2()
	var posXActual = get_pos().x
	#update()

	diferencialPosX = posXActual
	# Control de stamina y movimiento horizontal
	for i in range(numAnimals):
		if (actual_animal != i):
			if (stamina[i] < 100):
				stamina[i] += AMOUNT_RECOVERY
			if (stamina[i] > stamina[max_stamina]):
				max_stamina = i
		else:
			#Si el stamina del animal actual es mayor a 0, restarle stamina
			if(stamina[i] > 0):
				if(not godMode):
					stamina[i] -= BASE_STAMINA_CONS * stamina_factor
				if(recovering):
					motion.x = recoverSpeed * delta
				else: 
					if(posXActual <= mediumPos && direction == -1):
						motion.x = 0
					
					elif(posXActual > mediumPos && posXActual < maxDistance):
						motion.x = travelSpeed*delta*direction
					elif(posXActual>=maxDistance && direction == 1):
						motion.x = 0
					else:
						motion.x = -travelSpeed*delta
				
			if (stamina[i] <= 0):
				motion.x = -travelSpeed*delta
	
###############################################
#		FALTA MOVIMIENTO HORIZONTAL
###############################################
	if(actual_animal == capybaraId):
		if(recovering):
			motion.x = recoverSpeed*delta
		else:
			if(posXActual < maxDistance):
				motion.x = travelSpeed*delta
			else:
				if(direction ==1):
					motion.x = 0

	#Control de salto
	
	
	if(jump and not jumping):
		jumping = true
		get_node("anim").stop()
		get_node("sprite").set_frame(0)
	if(not(is_colliding())):
		velocity.y += gravity*delta
	else:
		velocity.y = 0
		jumping = false
		
	if(jumping):
		motion.y = -jumpForce*delta
	else:
		if(not (get_node("anim").is_playing())):
			get_node("anim").play("running")

	motion += delta * velocity 
	move(motion)

func _process(delta):
	
	
	var animal_1 = Input.is_action_pressed("animal_1")
	var animal_2 = Input.is_action_pressed("animal_2")
	var animal_3 = Input.is_action_pressed("animal_3")
	var sprite = get_node("sprite")
	var pos = sprite.get_pos()
	# Distancia recorrida
	distance += STEP_DISTANCE
	get_parent().get_node("UI/header/distance").set_text(str(int(distance)))
	#Si se recorre cierta distancia, se incrementa la velocidad
	if(distance-last_distance >= DISTANCE_TO_GROW):
###############################################################################################
		#PROBLEMA: El cambio de velocidad causa irregularidades en la traslacion de los sprites
###############################################################################################
		get_node("/root/global").screen_speed += 0.1
		last_distance = distance
		BASE_STAMINA_CONS += 0.1
	
	var posXActual = get_pos().x
	var blockChange = get_parent().get_node("UI").blockChange
	# Cambio de sprites
	# Si se hacen mas sprites, OJO que el chiguire es el indice 3
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
	#actual_animal = 3 es el chiguire
	if(actual_animal != capybaraId ):
		if(stamina[actual_animal] > 0 && posXActual < mediumPos - 1):
			recovering = true
		else:
			recovering = false
	else:
		if(posXActual < mediumPos -1):
			recovering = true
	
	
	get_parent().get_node("UI/stamina_bars/ciervo/stamina").set_value(stamina[0])
	get_parent().get_node("UI/stamina_bars/sapo/stamina").set_value(stamina[1])
	get_parent().get_node("UI/stamina_bars/goat/stamina").set_value(stamina[2])


	# Salto
	#Manejo de gravedad
	coins_acum = get_node("/root/global").coin_count
	if (coins_acum % 20 == 0 and coins_acum !=  0):
		if(not playedCapySound):
			get_node("sounds").play("capypowers")
			playedCapySound = true
		
		sprite.set_texture(capybara)
		actual_animal = capybaraId
		capybara_timeout = 8
	
	if (capybara_timeout > 0):
		capybara_timeout -= delta
		if (capybara_timeout <= 0):
			playedCapySound=false
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
	originalSpriteXPos = get_pos().x
	gravity = get_node("/root/global").gravity
	get_node("anim").play("running")
	get_node("/root/global").player_id = get_instance_ID()
	diferencialPosX = 0
	actual_animal = 0
	max_stamina = 0
	distance = 0
	set_fixed_process(true)
	set_process(true)
	pass

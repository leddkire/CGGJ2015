var deer = preload("res://textures/deer.tex")
var toad = preload("res://textures/toad.tex")
var goat = preload("res://textures/goat.tex")
var capybara = preload("res://textures/capybara.tex")
var jumping = false
# Factor de salto
var alt = 1.2
var stamina = [100, 100, 100]
var actual_animal = 0
var max_stamina = 0 #Que animal tiene más stamina
var distance = 0

var STEP_DISTANCE = 0.1
var AMOUNT_RECOVERY = 0.1
var BASE_STAMINA_CONS = 0.2
var stamina_factor = 1


func _fixed_process(delta):
	var jump = Input.is_action_pressed("jump")
	var animal_1 = Input.is_action_pressed("animal_1")
	var animal_2 = Input.is_action_pressed("animal_2")
	var animal_3 = Input.is_action_pressed("animal_3")
	var sprite = get_node("sprite")
	var pos = sprite.get_pos()
	distance += STEP_DISTANCE
	
	get_node("distance").set_text(str(int(distance)))

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
	if (not jumping):
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


func _ready():
	# Initalization here
	get_node("sprite").set_texture(deer)
	get_node("anim").play("running")
	actual_animal = 0
	max_stamina = 0
	distance = 0
	set_fixed_process(true)
	pass

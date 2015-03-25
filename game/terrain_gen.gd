extends Node2D

var sceneMontana = preload("res://game/montanaSingle.xml")
var scenePradera = preload("res://game/praderaSingle.xml")
var sceneAgua = preload("res://game/aguaSingle.xml")
#var platform = preload("res://game/platform.xml")
var tipoActual = 'pradera'
var numT = 0
var terrainContainer = []
var anchoUnidadTerreno = 64
var posOfCreation = 0
var terrenoPorAgregar = scenePradera
var velocidad
var numTMax
var alturaTerr = 120

func choose_terrain():
	var random_terr = int(rand_range(0,2))
	#Todas las posibilidades que pueden ser para elegir terreno.
	if tipoActual == 'montana':
		if random_terr == 0:
			tipoActual = 'agua'
			#return tipoActual
		elif random_terr == 1:
			tipoActual = 'pradera'
			#return tipoActual
	elif tipoActual == 'agua':
		if random_terr == 0:
			tipoActual = 'montana'
			#return tipoActual
		elif random_terr == 1:
			tipoActual = 'pradera'
			#return tipoActual
	elif tipoActual == 'pradera':
		if random_terr == 0:
			tipoActual = 'montana'
			#return tipoActual
		elif random_terr == 1:
			tipoActual = 'agua'
			#return tipoActual

func put_platform():
	var random_plat = int(rand_range(0,2))
	if(random_plat == 0):
		return true
	else:
		return false

func where_am_i(pos):
	var escenas = get_tree().get_nodes_in_group("Terrenos")
	for escena in escenas:
		var tipo = escena.get_type()
		var posicion = escena.get_pos()
		
		if posicion.x<=pos<posicion.x+1:
			print(posicion.x)
			return tipo
		

#func _draw():
#	var escenas = get_tree().get_nodes_in_group("Terrenos")
#	for escena in escenas:
#		var posicion = escena.get_pos()
#		draw_rect(Rect2(posicion.x,posicion.y,5,100),Color(255,0,0))
	

func _process(delta):
	#update()
	if(numT == 0):
		choose_terrain()
		
		if(tipoActual == 'montana'):
			terrenoPorAgregar = sceneMontana
		elif(tipoActual == 'pradera'):
			terrenoPorAgregar = scenePradera
		elif(tipoActual == 'agua'):
			terrenoPorAgregar = sceneAgua
		numT = int(rand_range(3,6))
		numTMax = numT
		
	var terrenos = get_tree().get_nodes_in_group("Terrenos")
	var platforms = get_tree().get_nodes_in_group("Platforms")
	var posicionPrimero = terrenos[0].get_pos()
	var posicionPrimeraPlatform = null
	
	
	var pos
	#Mover los terrenos
	for i in range(terrenos.size()):
		pos = terrenos[i].get_pos()
		pos.x -= velocidad
		terrenos[i].set_pos(pos)
		
	#Mover platforms
	for i in range(platforms.size()):
		pos = platforms[i].get_pos()
		pos.x -= velocidad
		platforms[i].set_pos(pos)
		
	#Eliminar terreno fuera de pantalla y agregar otro
	if(posicionPrimero.x <= -(anchoUnidadTerreno)):
		terrenos[0].remove_from_group("Terrenos")
		terrenos[0].free()
		var node
		if(tipoActual == 'agua'):
			node = terrenoPorAgregar.instance()
			if(numTMax == numT):
				
				node.set_sprite('first')
			elif(numT == 1):
				node.set_sprite('last')
		else:
			node = terrenoPorAgregar.instance()
		node.add_to_group("Terrenos")
		add_child(node)
		var pos = terrenos[terrenos.size()-1].get_pos()
		pos.x += anchoUnidadTerreno
		pos.y = alturaTerr
		node.set_pos(pos)
		numT-=1
		#Agregar plataforma
		#if(put_platform()):
		#	var platf = get_parent().get_node("Platform").duplicate()
		#	platf.set_type("agua")
		#	platf.add_to_group("Platforms")
		#	add_child(platf)
		
	#Se eliminan la primera plataforma si salio
	if(platforms.size() > 0):
		posicionPrimeraPlatform = platforms[0].get_pos()
		if(posicionPrimeraPlatform.x <= -(anchoUnidadTerreno)):
			platforms[0].remove_from_group("Platforms")
			platforms[0].free()
		
		
	velocidad = get_node("/root/global").screen_speed

func _ready():
	var rootView = get_tree().get_root().get_rect()
	var viewWidth = rootView.size.width
	var numTerrainInit = int(viewWidth/64)+2
	var node
	velocidad = get_node("/root/global").screen_speed
	while numTerrainInit > 0:
		node = scenePradera.instance()
		node.add_to_group("Terrenos")
		var posi = node.get_pos()
		posi.x += posOfCreation
		posi.y = alturaTerr
		posOfCreation += anchoUnidadTerreno
		node.set_pos(posi)
		add_child(node)
		numTerrainInit -= 1
	set_process(true)

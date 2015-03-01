extends Node2D

var sceneMontana = preload("res://game/montanaSingle.scn")
var scenePradera = preload("res://game/praderaSingle.scn")
var sceneAgua = preload("res://game/aguaSingle.scn")
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

func where_am_i(pos):
	var escenas = get_tree().get_nodes_in_group("Terrenos")
	for escena in escenas:
		var tipo = escena.get_type()
		var posicion = escena.get_pos()
		if tipo == 'montana' or tipo == 'pradera':
			if posicion.x-32<=pos<=posicion.x+32:
				return tipo
		else:
			if posicion.x-96<=pos<=posicion.x+96:
				return tipo

func _process(delta):
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
	var posicionPrimero = terrenos[0].get_pos()
	
	
	var pos
	#Mover los terrenos
	for i in range(terrenos.size()):
		pos = terrenos[i].get_pos()
		pos.x -= velocidad
		terrenos[i].set_pos(pos)
		
	#Eliminar terreno fuera de pantalla y agregar otro
	if(posicionPrimero.x <= -(anchoUnidadTerreno)):
		terrenos[0].remove_from_group("Terrenos");
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

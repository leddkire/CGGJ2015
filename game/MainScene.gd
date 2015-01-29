
extends Node2D
#Montaña: 0, Agua: 1, Pradera: 2 
var sceneMontana = load("res://game/montanaGen.scn")
var scenePradera = load("res://game/praderaGen.scn")
var sceneAgua = load("res://game/agua.scn")
#Variables que contienen la informacion de las escenas activas
#Pos 0: tipo, pos 1: mitad, pos 2: nodo
var nodos = []
var direction = Vector2(-1,0)
var random_seed = randf()
var random_arr = [1, random_seed]
var seed_terr = randf()
var random_terr = [1, 0.348]
var posStart = Vector2(0,0)
var tiempoPasado = 0
var tiempoAcumulado = 0
var posX = 0
var tipoActual = 'montana'
var cantTipoCrear = 0
var velocidad
#cheat
var firstWater = true;

func _get_random():
	#Se consigue un numero random entre 1 y 4. Si no cambia, revisar el seed.
	random_arr = rand_seed(random_arr[1])
	random_arr[0] = int(random_arr[0] % 4)
	random_arr[0] += 4
	return random_arr[0]
	
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

func choose_terrain():
	random_terr = rand_seed(random_terr[1])
	random_terr[0] = int(random_terr[0]) % 2
	#Todas las posibilidades que pueden ser para elegir terreno.
	if tipoActual == 'montana':
		if random_terr[0] == 0:
			tipoActual = 'agua'
			#return tipoActual
		elif random_terr[0] == 1:
			tipoActual = 'pradera'
			#return tipoActual
	elif tipoActual == 'agua':
		if random_terr[0] == 0:
			tipoActual = 'montana'
			#return tipoActual
		elif random_terr[0] == 1:
			tipoActual = 'pradera'
			#return tipoActual
	elif tipoActual == 'pradera':
		if random_terr[0] == 0:
			tipoActual = 'montana'
			#return tipoActual
		elif random_terr[0] == 1:
			tipoActual = 'agua'
			#return tipoActual
		
func add_terrain_scene(terr):
	var cantSumAcu = 64
	var acumulado = posX
	var node
	if terr == 'montana':
		node = sceneMontana.instance()
		cantSumAcu = 64
	elif terr == 'agua':
		node = sceneAgua.instance()
		cantSumAcu = 192
	elif terr == 'pradera':
		node = scenePradera.instance()
		cantSumAcu = 64
	#elif terr == 'pradera':
	#	node = scenePradera.instance()
	#var scene = load("res://game/montanaGen.scn")
	#var node = scene.instance()
	
	var posi = node.get_pos()
	if terr == 'agua':
		cantTipoCrear = 0
	#	cantTipoCrear -= 1
	#	while cantTipoCrear > 0:
	#		node.add_water()
	#		cantTipoCrear -= 1
	#		cantSumAcu += 64
	posi.x += acumulado
	node.set_pos(posi)
	node.add_to_group("Terrenos")
	#Se agrega todo el agua de una.
	
	acumulado += cantSumAcu
	add_child(node)
	posX = acumulado
	
#Revisar la optimizacion!!!
func _fixed_process(delta):
	var pointOfErase
	if tipoActual == 'montana' or tipoActual == 'pradera':
		pointOfErase = 64
	elif tipoActual == 'agua':
		pointOfErase = 128
	tiempoPasado = delta
	tiempoAcumulado += delta
	var terrs = get_tree().get_nodes_in_group("Terrenos")
	var count = 0
	var tam = terrs.size()
	var borrarUno
	posX -= velocidad
	var paraBorrar = []
	var posicionRela = 32
	var agregar = true
	var lastNode
	for elem in range(terrs.size()):
		var i = terrs[elem]
		#var child = i.get_child(i.get_type())
		var posicion = i.get_pos()
		#Chequeo rapidito de posiciones, si está menor que -32 entonces se elimina y se agrega otro
		if posicion.x <= -pointOfErase and i.get_type() != 'agua':
			paraBorrar.append(terrs[elem])
			agregar == true
		elif posicion.x <= -pointOfErase:
			if i.get_pos().x <= -i.get_size():
				paraBorrar.append(terrs[elem])
			agregar == true
		posicion.x -= velocidad
		i.set_pos(posicion)
		
		if elem == terrs.size()-1:
			lastNode = terrs[elem]

	if paraBorrar.size() > 0:
		var posic = lastNode.get_pos()
		#if tipoActual == 'agua':
		if cantTipoCrear > 0:
			add_terrain_scene(tipoActual)
			cantTipoCrear -= 1
		else:
			choose_terrain()
			cantTipoCrear = _get_random() - 1
			add_terrain_scene(tipoActual)
				
	for i in paraBorrar:
		i.free()
	#set_fixed_process(true)
	
func _ready():
	var acumulado = 0
	var node
	var random = _get_random()
	var nodeP
	var first = true
	velocidad = get_node("/root/global").screen_speed
	while random > 0:
		node = sceneMontana.instance()
		node.add_to_group("Terrenos")
		var posi = node.get_pos()
		posi.x += acumulado
		acumulado += 64
		node.set_pos(posi)
		if(first):
			nodeP = node
			first = false
		add_child(node)
		random -= 1
	posX += acumulado
	
	#nodeP.free()

	#var sceneMontana2 = load("res://game/montanaGen.scn")
	#Segundo nodo
	#nodeSig[1] = sceneMontana.instance()
	#nodeSig._add_mountain(_get_random())
	#nodeSig.add_to_group("Terrenos")
	#posi = nodeSig.get_pos()
	#add_child(nodeSig)
	
	#pos.x -= 80
	#get_node("montanaPrueba").set_pos(pos)
	set_fixed_process(true)
	



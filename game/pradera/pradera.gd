
extends TextureFrame

func _player_speed(player):
	if player == 'ciervo' or player == 'chiguire':
		return 1
	elif player == 'cabra':
		return 2
	elif player == 'sapo':
		return 3

func _ready():
	# Initalization here
	pass



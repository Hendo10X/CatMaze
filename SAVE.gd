extends Node2D

const SAVEFILE = "user://SAVEFILE.save"

var game_data = {
	"fullscreen_on" : true,
	"musica" : 0.5,
	"efectos": 0.5,
	"traduccion": false
}

func _ready():
	load_data()
	print(game_data)
func load_data():
	var file = FileAccess.open(SAVEFILE,FileAccess.READ)
	if file == null:
		save_data()
	else:
		var data_saved = file.get_var()
		for data in game_data.keys():
			if !data_saved.keys().has(data):
				data_saved[data] = game_data[data]
				print("error",data, "no existe")
				print(data, "agregado")
		game_data = data_saved
	file = null

func save_data():
	var file = FileAccess.open(SAVEFILE,FileAccess.WRITE)
	file.store_var(game_data)
	file = null

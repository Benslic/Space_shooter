extends Node

const SAVE_DATA_PATH="res://save_data.json"

var THE_OLD_GOD=false


var default_save_data= {
	HIGHSCORE=0,
}

func _ready():
	var a="HIGHSCORE"
	print(str(default_save_data[a]))

func save_data_to_file(save_data):
	var json_string=to_json(save_data)
	var save_file=File.new()
	save_file.open(SAVE_DATA_PATH,File.WRITE)
	save_file.store_line(json_string)
	save_file.close()

func load_data_from_file():
	var save_file=File.new()
	if not save_file.file_exists(SAVE_DATA_PATH):
		return default_save_data
	save_file.open(SAVE_DATA_PATH,File.READ)
	var save_data=parse_json(save_file.get_as_text())
	save_file.close()
	return save_data

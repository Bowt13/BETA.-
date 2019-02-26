extends Node

## SAVE
func save_file(path, data):
	var saveGame = File.new()
	saveGame.open(path, File.WRITE)
	var data_json = to_json(data)
	if !validate_json(data_json):
		saveGame.store_string(data_json)
		print("SAVE SUCCESFUL")
	else:
		print("SAVE FAILED (ERROR: INVALID JSON!)")
	saveGame.close()
	pass


## LOAD
func load_file(path):
	var file = File.new()
	if not file.file_exists(path):
		print ("File not found! Aborting...")
		return
	else:
		print("File found!")
	file.open(path, file.READ)
	var content = file.get_as_text()
	file.close()
	print("File Loaded")
	return content
	pass

func load_json(path):
	var file_content = load_file(path)
	if !validate_json(file_content):
		var json = JSON.parse(load_file(path))
		if json.error_string:
			print(json.error_string)
		return json
	else:
		print("LOAD FAILED (ERROR: INVALID JSON!)")
	pass

func generate_rooms(height, width):
	pass
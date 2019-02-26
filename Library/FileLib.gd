extends Node

func _ready():
	pass

func load_file(path):
    var file = File.new()
    if not file.file_exists(path):
        return
    file.open(path, file.READ)
    var content = file.get_as_text()
    file.close()
    return content


func load_json(path):
    var json = JSON.parse(load_file(path))
    if json.error_string:
        print(json.error_string)
    return json
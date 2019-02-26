extends TileMap

var diff = Vector2(32,32)

func _ready():
	pass

func destroy(bullet):
	var bullet_pos = bullet.global_position
	bullet_pos.x = round(bullet_pos.x)
	bullet_pos.y = round(bullet_pos.y)
	var cells = get_used_cells()
	for cell in cells:
		var cell_pos = map_to_world(cell, false)
		cell_pos += diff
		print(cell_pos)
#		print(cell_pos.x-bullet_pos.x)
		print(bullet_pos)
#			set_cell(cell.x, cell.y, -1)
	pass

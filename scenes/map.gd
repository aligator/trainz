extends TileMap

@export_range(0, 100) var layer_track: int = 1

const DATA_IS_TRACK = "IsSwitch"
const DATA_SWITCH_TO = "SwitchTo"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func get_tile_data(coordinate: Vector2i): 
	if get_cell_source_id(layer_track, local_to_map(coordinate)) == -1:
		return
	return get_cell_tile_data(layer_track, local_to_map(coordinate))

func switch(coordinate: Vector2): 
	var tile = get_tile_data(coordinate)
	if tile == null:
		return
		
	if !tile.get_custom_data(DATA_IS_TRACK):
		return
	
	var switch_to: Vector2i = tile.get_custom_data(DATA_SWITCH_TO)
	
	var source_id = get_cell_source_id(layer_track, local_to_map(coordinate))
	set_cell(layer_track, local_to_map(coordinate), source_id, switch_to)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:	
		if event.pressed:
			switch(event.position)

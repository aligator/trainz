extends CharacterBody2D

@export_range(0, 100) var layer_track: int = 1
@export_range(0, 100) var move_speed: float = 20

var tilemap: TileMap

const KEY_IS_TRACK = "IsTrack"
const KEY_TRACK_LEFT = "TrackLeft"
const KEY_TRACK_RIGHT = "TrackRight"
const KEY_TRACK_TOP = "TrackTop"
const KEY_TRACK_BOTTOM = "TrackBottom"

func get_tile_data(): 
	var coordinate = tilemap.local_to_map(get_position())
	if tilemap.get_cell_source_id(layer_track, coordinate) == -1:
		return
	return tilemap.get_cell_tile_data(layer_track, coordinate)

# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = get_parent()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	var data = get_tile_data()

	if (data == null):
		return
	
	if data.get_custom_data(KEY_IS_TRACK):
		velocity = Vector2(1, 0) * move_speed
		
	move_and_slide()

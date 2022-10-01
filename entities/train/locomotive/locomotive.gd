extends CharacterBody2D

@export_range(0, 100) var layer_track: int = 1
@export_range(0, 100) var move_speed: float = 30

var tilemap: TileMap
var move_direction: Vector2i = Vector2i(1, 0)

const TRACK_WIDTH: float = 16
const TRACK_TILE_CENTER = TRACK_WIDTH / 2.0
	
const DATA_IS_TRACK = "IsTrack"
const DATA_TRACK_LEFT = "TrackLeft"
const DATA_TRACK_RIGHT = "TrackRight"
const DATA_TRACK_TOP = "TrackTop"
const DATA_TRACK_BOTTOM = "TrackBottom"

const explosion = preload("res://effects/Explosion.tscn")

func get_tile_data(): 
	var coordinate = tilemap.local_to_map(get_position())
	if tilemap.get_cell_source_id(layer_track, coordinate) == -1:
		return
	return tilemap.get_cell_tile_data(layer_track, coordinate)

func follow_track(tile_data: TileData):
	var position_in_tile = Vector2(roundf(fmod(position.x, TRACK_WIDTH)), roundf(fmod(position.y, TRACK_WIDTH)))


	var left: bool = tile_data.get_custom_data(DATA_TRACK_LEFT)
	var right: bool = tile_data.get_custom_data(DATA_TRACK_RIGHT)
	var top: bool = tile_data.get_custom_data(DATA_TRACK_TOP)
	var bottom: bool = tile_data.get_custom_data(DATA_TRACK_BOTTOM)

	# set the source to false to avoid moving back or just do nothing if not over the half of the tile
	if move_direction == Vector2i(1, 0): # from left
		if position_in_tile.x >= TRACK_TILE_CENTER:
			return
		
		left = false
	if move_direction == Vector2i(-1, 0): # from right
		if position_in_tile.x <= TRACK_TILE_CENTER:
			return

		right = false
	if move_direction == Vector2i(0, 1): # from top
		if position_in_tile.y >= TRACK_TILE_CENTER:
			return

		top = false
	if move_direction == Vector2i(0, -1): # from bottom
		if position_in_tile.y <= TRACK_TILE_CENTER:
			return

		bottom = false

	if left: 
		move_direction = Vector2i(-1, 0)
	if right: 
		move_direction = Vector2i(1, 0)
	if top: 
		move_direction = Vector2i(0, -1)
	if bottom: 
		move_direction = Vector2i(0, 1)

	return

func rotate_train():
	if move_direction == Vector2i(1, 0):
		rotation = deg_to_rad(0)

	if move_direction == Vector2i(-1, 0):
		rotation = deg_to_rad(180)

	if move_direction == Vector2i(0, 1):
		rotation = deg_to_rad(90)
	
	if move_direction == Vector2i(0, -1):
		rotation = deg_to_rad(270)

	return

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	if move_direction == Vector2i(0, 0):
		return
	
	if 	tilemap == null:
		tilemap = get_parent()
	
	var data = get_tile_data()

	if (data == null):
		return
	
	if !data.get_custom_data(DATA_IS_TRACK):
		return

	follow_track(data)
	
	# Just move forward
	velocity = move_direction * move_speed

	# Keep at the center
	if move_direction.x == 0:
		position.x = tilemap.local_to_map(get_position()).x * TRACK_WIDTH + TRACK_TILE_CENTER
	if move_direction.y == 0:
		position.y = tilemap.local_to_map(get_position()).y * TRACK_WIDTH + TRACK_TILE_CENTER

	rotate_train()
	move_and_slide()

func _on_collision_detector_body_entered(body):
	if body == self:
		return
	
	if body.has_method("die"):
		body.die()
		die()


func die():
	move_direction = Vector2(0, 0)

	var new_explosion: GPUParticles2D = explosion.instantiate()
	add_child(new_explosion)
	new_explosion.global_position = global_position
	await new_explosion.get_node("Timer").timeout
	
	queue_free()

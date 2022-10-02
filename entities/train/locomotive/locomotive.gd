extends CharacterBody2D

@export_range(0, 100) var layer_track: int = 1
@export_range(0, 100) var move_speed: float = 30
@export var train_color: Color = Color("#ea0000")

var tilemap: TileMap
var move_direction: Vector2i = Vector2i(1, 0)

const TRACK_WIDTH: float = 16
const TRACK_TILE_CENTER = TRACK_WIDTH / 2.0
	
const DATA_IS_TRACK = "IsTrack"
const DATA_TRACK_LEFT = "TrackLeft"
const DATA_TRACK_RIGHT = "TrackRight"
const DATA_TRACK_TOP = "TrackTop"
const DATA_TRACK_BOTTOM = "TrackBottom"

const DATA_IS_DEPOT = "IsDepot"
const DATA_DEPOT_COLOR = "DepotColor"

const explosion = preload("res://effects/Explosion.tscn")

const DIR_NONE = Vector2i(0, 0)
const DIR_LEFT = Vector2i(-1, 0)
const DIR_RIGHT = Vector2i(1, 0)
const DIR_TOP = Vector2i(0, -1)
const DIR_BOTTOM = Vector2i(0, 1)

var dead = false
var in_depot = false

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

	var is_depot: bool = tile_data.get_custom_data(DATA_IS_DEPOT)
	
	if is_depot && position_in_tile.x >= TRACK_TILE_CENTER-2:
		check_in_depot(tile_data)
		return
	
	
	# set the source to false to avoid moving back or just do nothing if not over the half of the tile
	if move_direction == DIR_RIGHT: # from left
		if position_in_tile.x >= TRACK_TILE_CENTER:
			return
		
		left = false
	if move_direction == DIR_LEFT: # from right
		if position_in_tile.x <= TRACK_TILE_CENTER:
			return

		right = false
	if move_direction == DIR_BOTTOM: # from top
		if position_in_tile.y >= TRACK_TILE_CENTER:
			return

		top = false
	if move_direction == DIR_TOP: # from bottom
		if position_in_tile.y <= TRACK_TILE_CENTER:
			return

		bottom = false

	if left: 
		move_direction = DIR_LEFT
	if right: 
		move_direction = DIR_RIGHT
	if top: 
		move_direction = DIR_TOP
	if bottom: 
		move_direction = DIR_BOTTOM

	return

func rotate_train():
	if move_direction == DIR_RIGHT:
		rotation = deg_to_rad(0)

	if move_direction == DIR_BOTTOM:
		rotation = deg_to_rad(90)

	if move_direction == DIR_LEFT:
		rotation = deg_to_rad(180)
	
	if move_direction == DIR_TOP:
		rotation = deg_to_rad(270)

	return

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	if Global.lives == 0:
		return
	
	if move_direction == DIR_NONE:
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

func check_in_depot(tile_data: TileData):
	if in_depot: 
		return
		
	in_depot = true
	
	var depot_color: Color = tile_data.get_custom_data(DATA_DEPOT_COLOR)
	
	if depot_color.is_equal_approx(train_color):
		Global.increment_points()
		visible = false
		$AudioBing.play()
		$BingTimer.start()
		await $BingTimer.timeout
		queue_free()
	else:
		die()
		
func _on_collision_detector_body_entered(body):
	if body == self:
		return
	
	if body.has_method("die"):
		body.die(false)
		die()

func die(decrement_lives: bool = true):
	if dead:
		return
		
	dead = true
	
	if decrement_lives:
		Global.decrement_lives()
		
	move_direction = DIR_NONE

	var new_explosion: GPUParticles2D = explosion.instantiate()
	add_child(new_explosion)
	new_explosion.global_position = global_position
	await new_explosion.get_node("Timer").timeout
	
	queue_free()

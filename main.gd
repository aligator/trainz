extends Node2D

@export_range(0, 1000) var scroll_speed: float = 400

@onready var camera: Camera2D = $Camera2d
@onready var tilemap: TileMap = $Map
 
var max_x = 0
var max_y = 0

func _ready():
	camera.set_position(Vector2(0, 0))
	calculate_bounds()

func calculate_bounds():
	var used_cells = tilemap.get_used_cells(0)
	for pos in used_cells:
		if pos.x > max_x:
			max_x = int(pos.x)
		elif pos.y > max_y:
			max_y = int(pos.y)

	max_x *= 16
	max_y *= 16


func _physics_process(delta):
	var current_pos = camera.position 
	
	if Input.is_action_pressed("Up"):
		current_pos += (Vector2(0, -1) * scroll_speed * delta)
	if Input.is_action_pressed("Down"):
		current_pos += (Vector2(0, 1) * scroll_speed * delta)
	if Input.is_action_pressed("Right"):
		current_pos += (Vector2(1, 0) * scroll_speed * delta)
	if Input.is_action_pressed("Left"):
		current_pos += (Vector2(-1, 0) * scroll_speed * delta)
	
	if current_pos.x <= 0:
		current_pos.x = 0
		
	if current_pos.y <= 0:
		current_pos.y = 0
	
	if current_pos.x >= max_x - camera.get_viewport_rect().size.x:
		current_pos.x = max_x - camera.get_viewport_rect().size.x
		
	if current_pos.y >= max_y - camera.get_viewport_rect().size.y:
		current_pos.y = max_y - camera.get_viewport_rect().size.y
		
	
	camera.set_position(current_pos)

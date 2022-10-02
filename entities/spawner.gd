extends Timer

@export var entities: Array[PackedScene]

func spawn():
	var max_trains = 2
	if Global.points >= 10:
		max_trains = 3
	if Global.points >= 15:
		max_trains = 4
	
	var entity = entities[randi_range(0, max_trains-1)]
	
	var newEntity = entity.instantiate()
	newEntity.position = get_parent().position
	get_parent().get_parent().call_deferred("add_child", newEntity)

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout.connect(spawn)
	spawn()

func _physics_process(_delta):
	if Global.lives == 0:
		stop()

extends Timer

@export var entity: PackedScene

func spawn():
	var newEntity = entity.instantiate()
	newEntity.position = get_parent().position
	get_parent().get_parent().call_deferred("add_child", newEntity)

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout.connect(spawn)
	spawn()

extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	load_hearts()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	load_hearts()

func load_hearts():
	var newSize = Global.lives * 32
	$Panel/HeartsFull.size.x = newSize
	if newSize == 0:
		$Panel/HeartsFull.visible = false

extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	load_hearts()
	load_points()
	load_timeout()

func load_hearts():
	var newSize = Global.lives * 32
	$Panel/HeartsFull.size.x = newSize
	if newSize == 0:
		$Panel/HeartsFull.visible = false

func load_points():
	$Panel2/Points.text = str(Global.points)

func load_timeout():
	$Panel3/Time.text = "Next trains arrive in " + str(roundf(Global.time_left)) + " seconds..."

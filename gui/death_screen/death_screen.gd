extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = Global.lives == 0
	$Panel/CenterContainer/Label.text = "You got " + str(Global.points) + " points!"


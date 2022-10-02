extends Node

var max_lives = 3
var lives = max_lives

func decrement_lives():
	lives -= 1
	if lives <= 0:
		lives = 0

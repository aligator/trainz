extends Node

var max_lives = 3
var lives = max_lives

var points = 0

func decrement_lives():
	lives -= 1
	if lives <= 0:
		lives = 0

func increment_points():
	points += 1

extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()

	for i in range(0, 10):
		rng.randomize()
		var rand_index = rng.randi_range(0, 49)
		print(rand_index)

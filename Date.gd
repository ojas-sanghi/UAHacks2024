extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = load("res://assets/" + str(DaySystem.day_number) + ".png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

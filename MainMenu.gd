extends Node2D

func _ready():
	$CenterContainer/VBoxContainer/StartButton.pressed.connect(start_game)
	
func start_game():
	DaySystem.start_new_day()

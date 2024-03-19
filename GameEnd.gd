extends Node2D

func _ready():
	$CenterContainer/VBoxContainer/ScoreLabel.text = "Money earned: $" + str(PlayerData.money)

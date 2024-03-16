extends Node

var money = 0

var letters = {}

func _ready():
	for l in "ABCDEFGHJKILMNOPQRSTUVWXYZ":
		letters[l] = 0

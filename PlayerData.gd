extends Node

var LETTER_LIST = "ABCDEFGHJKILMNOPQRSTUVWXYZ"
var money = 0
var letters = {}

func _ready():
	for l in LETTER_LIST:
		letters[l] = 0

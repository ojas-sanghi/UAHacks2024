extends Node

var LETTER_LIST = "ABCDEFGHJKILMNOPQRSTUVWXYZ"
var money = 0
var letters = {}

var owned_art = []

func _ready():
	for l in LETTER_LIST:
		letters[l] = 0

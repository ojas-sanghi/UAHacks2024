extends Node

var LETTER_LIST = "ABCDEFGHJKILMNOPQRSTUVWXYZ"
var money = 0
var letters = {}

var image_counter = 0

var owned_art = []
var art_values = {}

func _ready():
	for l in LETTER_LIST:
		letters[l] = 4

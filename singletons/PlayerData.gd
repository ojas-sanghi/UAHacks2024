extends Node

var LETTER_LIST = "ABCDEFGHJKILMNOPQRSTUVWXYZ"
var money = 0
var letters = {}

var image_counter = 0

var owned_art = []
var art_values = {}

var art_value_sell_amounts = {
	"trash": 5,
	"common": 25,
	"valuable": 50,
	"exceptional": 100
}

func _ready():
	for l in LETTER_LIST:
		letters[l] = 4

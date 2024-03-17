extends Node

var artwork = []
var art_prompts = {}

func _ready():
	# TODO: Generate base set of AI art and add to list
	# example of how it's set up:
	var name = "genimg.jpg"
	artwork.append(name)
	art_prompts[name] = "chair"

func generate_new():
	# TODO: generate an extra piece of art, add prompt, add cost
	pass

func remove_first():
	artwork.pop_front()
	generate_new()

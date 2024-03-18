extends Node2D

func _ready():
	generate_letters()

func generate_letters():
	var flow = $CenterContainerInv/VBoxContainer/LetterInventoryFlowContainer
	
	for l in PlayerData.LETTER_LIST:
		var label = Label.new()
		label.text = l + " – " + str(PlayerData.letters[l])
		label.add_theme_font_size_override("font_size", 32)
		label.size.x = 60
		label.size.y = 10
		
		flow.add_child(label)

extends Node2D

var LETTER_COSTS = {}

var inventory_nodes = {}

func _ready():
	PlayerData.money = 150 # testing
	
	var money_label = get_child(2)
	money_label.text = "Money: " + str(PlayerData.money)
	
	var store_grid = get_child(0)
	var inventory_container = get_child(1)
	
	for l in PlayerData.LETTER_LIST:
		# Set costs
		LETTER_COSTS[l] = randi_range(50, 101)
		
		# Add store buttons
		var vbox = VBoxContainer.new()
		var cost = Label.new()
		cost.text = "Cost: " + str(LETTER_COSTS[l])
		cost.add_theme_font_size_override("font_size", 42)
		
		var button = Button.new()
		button.text = l
		button.pressed.connect(handle_button_input.bind(l))
		button.add_theme_font_size_override("font_size", 64)
		button.set_custom_minimum_size(Vector2(275, 115))
		
		vbox.add_child(button)
		vbox.add_child(cost)
		
		store_grid.add_child(vbox)
		
		# Add inventory viewer
		var label = Label.new()
		label.text = l + " – " + str(PlayerData.letters[l])
		label.add_theme_font_size_override("font_size", 36)
		label.size.x = 60
		label.size.y = 10
		inventory_nodes[l] = label
		inventory_container.add_child(label)
	
func handle_button_input(letter):
	if PlayerData.money >= LETTER_COSTS[letter]:
		PlayerData.money -= LETTER_COSTS[letter]
		PlayerData.letters[letter] += 1
		
		inventory_nodes[letter].text = letter + " – " + str(PlayerData.letters[letter])
		
		var money_label = get_child(2)
		money_label.text = "Money: " + str(PlayerData.money)
	else:
		var dialog = AcceptDialog.new()
		dialog.dialog_text = "You do not have enough money to purchase that letter."
		dialog.title = ""
		dialog.min_size = Vector2(800, 200)
		dialog.get_label().add_theme_font_size_override("font_size", 48)
		dialog.get_ok_button().set_custom_minimum_size(Vector2(400, 100))
		dialog.get_ok_button().add_theme_font_size_override("font_size", 36)
		add_child(dialog)
		dialog.popup_centered()

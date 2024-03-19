extends Node2D

var LETTER_COSTS = {}

var inventory_nodes = {}

func _ready():
	$ReturnButton.pressed.connect(return_to_day)
	
	update_money_label()
	
	var store_grid = $ScrollContainer/StoreGridContainer
	var inventory_container = $InventoryFlowContainer
	
	var latest_trend = MarketTrend.latest_trend
	
	if (latest_trend == null):
		await get_tree().create_timer(3.0).timeout
		latest_trend = MarketTrend.latest_trend
	
	for l in PlayerData.LETTER_LIST:
		# Set costs
		LETTER_COSTS[l] = round(randi_range(25, 50) * MarketTrend.latest_trend_multiplier)
		
		# Add store buttons
		var vbox = VBoxContainer.new()
		var cost = Label.new()
		cost.text = "Cost: " + str(LETTER_COSTS[l])
		cost.add_theme_font_size_override("font_size", 30)
		
		var button = Button.new()
		button.size
		button.text = l
		button.pressed.connect(handle_button_input.bind(l))
		button.add_theme_font_size_override("font_size", 40)
		
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
	
func return_to_day():
	SceneChanger.go_to_scene("res://day.tscn")
	
func update_money_label():
	$MoneyLabel.text = "Money: $" + str(PlayerData.money)
	
func handle_button_input(letter):
	if PlayerData.money >= LETTER_COSTS[letter]:
		PlayerData.money -= LETTER_COSTS[letter]
		PlayerData.letters[letter] += 1
		
		inventory_nodes[letter].text = letter + " – " + str(PlayerData.letters[letter])
		
		update_money_label()
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

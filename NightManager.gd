extends Control

var actions = 3
var current_user_art_index = 0

var steal_selected_art = null
var steal_shown_art = []

func _ready():
	update_actions_label()
	update_money_label()
	
	$VBoxContainer/HBoxContainer/EndNightButton.pressed.connect(end_current_night)
	$VBoxContainer/HBoxContainer/NightNumberLabel.text = "Night " + str(DaySystem.day_number)
	
	# Sell
	var left = $VBoxContainer/TabContainer/SellArtworkTab/VBoxContainer/HBoxContainer/LeftButton
	var right = $VBoxContainer/TabContainer/SellArtworkTab/VBoxContainer/HBoxContainer/RightButton
	var sell = $VBoxContainer/TabContainer/SellArtworkTab/VBoxContainer/SellCurrentButton
	
	left.pressed.connect(shift_user_image_gallery.bind(true))
	right.pressed.connect(shift_user_image_gallery.bind(false))
	
	sell.pressed.connect(sell_current_art)
	
	display_user_artwork()
	
	# Steal
	var steal_input = $VBoxContainer/TabContainer/StealArtworkTab/VBoxContainer/StealGuessField
	steal_input.text_submitted.connect(accept_steal_guess)
	
	display_ai_artwork()

func end_current_night():
	DaySystem.start_new_day()

func use_action():
	actions -= 1
	update_actions_label()
	
	if actions == 0:
		var dialog = AcceptDialog.new()
		
		dialog.dialog_text = "You have run out of actions for tonight. Click OK to proceed to the next day."
		dialog.title = "No actions left!"
		dialog.min_size = Vector2(800, 200)
		
		dialog.get_label().add_theme_font_size_override("font_size", 48)
		
		var d_button = dialog.get_ok_button()
		d_button.set_custom_minimum_size(Vector2(400, 100))
		d_button.add_theme_font_size_override("font_size", 36)
		d_button.text = "Proceed"
		d_button.pressed.connect(end_current_night)
		
		add_child(dialog)
		dialog.popup_centered()

func update_actions_label():
	$VBoxContainer/HBoxContainer/CenterContainer/ActionsLabel.text = "Actions: " + str(actions)
	
func update_money_label():
	$VBoxContainer/TabContainer/SellArtworkTab/VBoxContainer/MoneyLabel.text = "Money: " + str(PlayerData.money)
	
func accept_steal_guess(guess):
	if actions <= 0:
		return
		
	var steal_input = $VBoxContainer/TabContainer/StealArtworkTab/VBoxContainer/StealGuessField
	steal_input.clear()
	
	# TODO: need to update with the real prompts
	var current = AiArtData.artwork[steal_shown_art[steal_selected_art]]
	var real_prompt = AiArtData.art_prompts[current]
	
	# doing this before the logic so the dialog shows up first if this is the last action
	use_action()
	
	if guess.to_lower() == real_prompt.to_lower():
		PlayerData.owned_art.append(current)
		AiArtData.remove_first()
		display_ai_artwork()
		
		if PlayerData.owned_art.size() == 0:
			display_user_artwork()
		
		show_alert("Success!", "You successfully stole a piece of artwork.")
	else:
		var loss = min(PlayerData.money, randi_range(50, 100));
		
		PlayerData.money -= loss
		
		show_alert("Fail!", "You failed to steal the artwork and have been fined $" + str(loss) + ".")
	
func display_ai_artwork():
	var rng = RandomNumberGenerator.new()
	
	for i in range(0, 10):
		rng.randomize()
		var rand_index = rng.randi_range(0, 49)
		print(rand_index)
		steal_shown_art.append(rand_index)
		var file = AiArtData.artwork[rand_index]
		var image = Image.load_from_file(file)
		var texture = ImageTexture.create_from_image(image)
		
		var grid = $VBoxContainer/TabContainer/StealArtworkTab/VBoxContainer/GridContainer
		var buttons = grid.get_children()
		for button in buttons:
			var rect: TextureRect = button.get_child(0)
			rect.texture.resource_local_to_scene = true
			rect.texture = texture
	
func shift_user_image_gallery(left: bool):
	if (left && current_user_art_index == 0) || (!left && current_user_art_index == PlayerData.owned_art.size() - 1):
		return
		
	current_user_art_index += -1 if left else 1
	display_user_artwork()

func display_user_artwork():
	var rect = $VBoxContainer/TabContainer/SellArtworkTab/VBoxContainer/SellTextureRect
	
	if PlayerData.owned_art.size() == 0:
		rect.texture = null
		return
		
	var file = PlayerData.owned_art[current_user_art_index]
	var image = Image.load_from_file(file)
	var texture = ImageTexture.create_from_image(image)
	rect.texture = texture
	
func sell_current_art():
	if PlayerData.owned_art.size() == 0:
		show_alert("No art owned", "You do not own any other artwork. You can attempt to steal art, or proceed to the next day.")
		return
	elif actions <= 0:
		return
	
	# TODO: need to get the AI-determined values
	var sell_amount = randi_range(50, 100)
	
	PlayerData.money += sell_amount
	PlayerData.owned_art.remove_at(current_user_art_index)
	update_money_label()
	
	if current_user_art_index > 0:
		current_user_art_index -= 1
	
	display_user_artwork()
	
	use_action()
	
func show_alert(title, text):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = text
	dialog.title = title
	dialog.min_size = Vector2(800, 200)
	dialog.get_label().add_theme_font_size_override("font_size", 40)
	dialog.get_ok_button().set_custom_minimum_size(Vector2(400, 100))
	dialog.get_ok_button().add_theme_font_size_override("font_size", 36)
	add_child(dialog)
	dialog.popup_centered()



func _on_button_pressed():
	steal_selected_art = 0
	print("clicked")


func _on_button_2_pressed():
	steal_selected_art = 1
	print("clicked1")


func _on_button_3_pressed():
	steal_selected_art = 2
	print("clicked2")


func _on_button_4_pressed():
	steal_selected_art = 3
	print("clicked3")


func _on_button_5_pressed():
	steal_selected_art = 4
	print("clicked4")


func _on_button_6_pressed():
	steal_selected_art = 5
	print("clicked5")


func _on_button_7_pressed():
	steal_selected_art = 6
	print("clicked6")


func _on_button_8_pressed():
	steal_selected_art = 7
	print("clicked7")


func _on_button_9_pressed():
	steal_selected_art = 8
	print("clicked8")


func _on_button_10_pressed():
	steal_selected_art = 9
	print("clicked9")

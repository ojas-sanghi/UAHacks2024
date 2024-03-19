extends Control

var actions = 3
var current_user_art_index = 0

var steal_selected_art = null
var steal_shown_art = []

func _ready():
	PlayerData.money = 3
	update_actions_label()
	update_money_label()
	check_can_steal()
	
	$VBoxContainer/HBoxContainer/EndNightButton.pressed.connect(end_current_night)
	$VBoxContainer/HBoxContainer/NightNumberLabel.text = "Night " + str(DaySystem.day_number)
	
	$VBoxContainer/TabContainer/StealArtworkTab/VBoxContainer/StealGuessField.visible = false
	
	var grid = $VBoxContainer/TabContainer/StealArtworkTab/VBoxContainer/GridContainer
	for i in range(0, grid.get_children().size()):
		var button = grid.get_children()[i]
		button.pressed.connect(on_ai_gallery_button_pressed.bind(i))
	
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
	var money_text = "Money: $" + str(PlayerData.money)
	$VBoxContainer/TabContainer/SellArtworkTab/VBoxContainer/MoneyLabel.text = money_text
	$VBoxContainer/TabContainer/StealArtworkTab/VBoxContainer/MoneyLabel.text = money_text
	
func accept_steal_guess(guess):
	if actions <= 0:
		return
		
	var steal_input = $VBoxContainer/TabContainer/StealArtworkTab/VBoxContainer/StealGuessField
	steal_input.clear()
	
	var current = AiArtData.artwork[steal_shown_art[steal_selected_art]]
	var real_prompt = AiArtData.art_prompts[current]
	
	# doing this before the logic so the dialog shows up first if this is the last action
	use_action()
	
	if guess.to_lower() == real_prompt.to_lower():
		PlayerData.owned_art.append(current)
		AiArtData.remove_first()
		display_ai_artwork()
		
		if PlayerData.owned_art.size() == 1:
			display_user_artwork()
		
		show_alert("Success!", "You successfully stole a piece of artwork.")
	else:
		var loss = min(PlayerData.money, max(10, PlayerData.money * 0.1));
		
		PlayerData.money -= loss
		
		show_alert("Fail!", "You failed to steal the artwork and have been fined $" + str(loss) + ".")
		
		if PlayerData.money == 0:
			$VBoxContainer/TabContainer.current_tab = 0
			check_can_steal()
		
		update_money_label()
	
func display_ai_artwork():
	var rng = RandomNumberGenerator.new()
	
	for i in range(0, 10):
		rng.randomize()
		var rand_index = rng.randi_range(0, AiArtData.artwork.size() - 1)
		print(rand_index)
		
		if rand_index in steal_shown_art:
			i -= 1
			continue
		
		steal_shown_art.append(rand_index)
		var file = AiArtData.artwork[rand_index]
		var image = Image.load_from_file(file)
		var texture = ImageTexture.create_from_image(image)
		
		var grid = $VBoxContainer/TabContainer/StealArtworkTab/VBoxContainer/GridContainer
		var button = grid.get_children()[i]
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
	
	check_can_steal()
	
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
	
func check_can_steal():
	$VBoxContainer/TabContainer.set_tab_hidden(1, PlayerData.money == 0)

func on_ai_gallery_button_pressed(index: int):
	steal_selected_art = index
	print("AI Gallery: Clicked " + str(index))
	
	$VBoxContainer/TabContainer/StealArtworkTab/VBoxContainer/StealGuessField.visible = true

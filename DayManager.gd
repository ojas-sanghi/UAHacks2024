extends Node2D

var letter_inv_nodes = {}

func _ready():
	generate_letters()
	
	$LineEdit.grab_focus()
	
	$EndDayButton.pressed.connect(go_to_night)
	
	$LineEdit.text_submitted.connect(accept_input)
	
	$LetterStoreButton.pressed.connect(show_letter_store)
	
	$GeneratingLabel.visible = false

func show_letter_store():
	SceneChanger.go_to_scene("res://letter_store.tscn")

func go_to_night():
	SceneChanger.go_to_scene("res://night.tscn")
	
func accept_input(text):
	$LineEdit.clear()
	
	var prompt_chars = {}
	for c in text:
		c = c.to_upper()
		prompt_chars[c] = prompt_chars[c] + 1 if prompt_chars.has(c) else 1
	
	for key in prompt_chars:
		if PlayerData.letters[key] < prompt_chars[key]:
			show_alert("Insufficient Letters", "You don't own enough letters to create this word.")
			return
	
	for key in prompt_chars:
		PlayerData.letters[key] -= prompt_chars[key]
		
	update_letter_inventory()
		
	$GeneratingLabel.visible = true
	
	await AILoop.generate_image_from_prompt(text)
	
	var img: Sprite2D = AILoop.gen_img
	
	$CenterContainer/ArtworkTextureRect.texture = img.texture
	
	var file_name = "res://user_images/user-" + text + "-" + str(PlayerData.image_counter) + ".png"
	PlayerData.image_counter += 1
	
	img.texture.get_image().save_png(file_name)
	
	PlayerData.owned_art.append(file_name)
	PlayerData.art_values[file_name] = AILoop.prompt_value
	
	print("Finished!")
	$GeneratingLabel.visible = false

func generate_letters():
	var flow = $CenterContainerInv/VBoxContainer/LetterInventoryFlowContainer
	
	for l in PlayerData.LETTER_LIST:
		var label = Label.new()
		
		label.add_theme_font_size_override("font_size", 32)
		label.size.x = 60
		label.size.y = 10
		
		flow.add_child(label)
		letter_inv_nodes[l] = label
	
	update_letter_inventory()

func update_letter_inventory():
	for l in PlayerData.LETTER_LIST:
		letter_inv_nodes[l].text = l + " – " + str(PlayerData.letters[l])
		
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

extends Node2D

var actions = 3
var current_user_art_index = 0

func _ready():
	update_actions_label()
	update_money_label()
	
	# testing
	PlayerData.owned_art.append("genimg.jpg")
	
	var left = $"TabContainer/Sell Artwork/VBoxContainer/HBoxContainer/LeftButton"
	var right = $"TabContainer/Sell Artwork/VBoxContainer/HBoxContainer/RightButton"
	var sell = $"TabContainer/Sell Artwork/VBoxContainer/SellCurrentButton"
	
	left.pressed.connect(shift_user_image_gallery.bind(true))
	right.pressed.connect(shift_user_image_gallery.bind(false))
	
	sell.pressed.connect(sell_current_art)
	
	display_user_artwork()

func _process(delta):
	pass

func update_actions_label():
	$CenterContainer/ActionsLabel.text = "Actions: " + str(actions)
	
func update_money_label():
	$"TabContainer/Sell Artwork/VBoxContainer/MoneyLabel".text = "Money: " + str(PlayerData.money)
	
func shift_user_image_gallery(left: bool):
	if (left && current_user_art_index == 0) || (!left && current_user_art_index == PlayerData.owned_art.size() - 1):
		return
		
	current_user_art_index += -1 if left else 1
	display_user_artwork()

func display_user_artwork():
	if PlayerData.owned_art.size() == 0:
		$"TabContainer/Sell Artwork/VBoxContainer/TextureRect".texture = null
		return
		
	var file = "res://user_art/" + PlayerData.owned_art[current_user_art_index]
	var image = Image.load_from_file(file)
	var texture = ImageTexture.create_from_image(image)
	$"TabContainer/Sell Artwork/VBoxContainer/TextureRect".texture = texture
	
func sell_current_art():
	if PlayerData.owned_art.size() == 0:
		return
	
	# TODO: need to get the AI-determined values
	var sell_amount = randi_range(50, 100)
	
	PlayerData.money += sell_amount
	PlayerData.owned_art.remove_at(current_user_art_index)
	update_money_label()
	
	if current_user_art_index > 0:
		current_user_art_index -= 1
	
	display_user_artwork()
	
	actions -= 1
	update_actions_label()

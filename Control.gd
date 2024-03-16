extends Control

var letters = ["A", "B", "C", "D", "E"] # Example list of letters

func _ready():
	generateLetters()

func generateLetters():
	var position = Vector2(20, 20)  # Starting position of the first letter
	var spacing = 100  # Spacing between each letter
	
	for letter in letters:
		var label = Label.new()
		label.text = letter
		#label.set("custom_fonts/font", preload("res://path_to_your_font.ttf"))  # Set the font
		#label.add_color_override("font_color", Color(1, 1, 1))  # Set the font color
		label.set("rect_min_size", Vector2(20, 20))  # Set the minimum size of the label
		label.set("rect_max_size", Vector2(40, 40))  # Set the maximum size of the label
		label.set("rect_position", position)
		label.set("font_size", 24)
		add_child(label)
		position.x += spacing  # Move to the next position


extends FlowContainer

var letters = ["A", "B", "C", "D", "E","F","G","H","I","J","K"] # Example list of letters

func _ready():
	self.add_theme_constant_override("h_separation", 10)
	generateLetters()

func generateLetters():
	for letter in letters:
		var label = Label.new()
		label.text = letter
		label.set("rect_min_size", Vector2(10, 10))  # Set the minimum size of the label
		label.set("rect_max_size", Vector2(10, 10))  # Set the maximum size of the label
		label.set("size", Vector2(5, 5))  # Set the size of the label
		label.set("font", label.get("font:source"))  # Use the default font
		label.set("font_size", 6)  # Set the font size (adjust as needed)
		#label.set("size_flags_vertical", Control.SIZE_SHRINK_CENTER) # Vertically center the text
		#label.set("size_flags_horizontal", Control.SIZE_EXPAND_FILL) # Expand horizontally
		#label.add_color_override("font_color", Color(1, 1, 1))  # Set the font color
		self.add_child(label)

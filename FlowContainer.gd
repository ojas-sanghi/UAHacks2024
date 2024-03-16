extends FlowContainer

var letters = ["A", "B", "C", "D", "E","F","G","H","I","J","K","L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"] # Example list of letters

func _ready():
	self.add_theme_constant_override("h_separation", 3)
	generateLetters()

func generateLetters():
	for letter in letters:
		var label = Label.new()
		label.text = letter
		label.set("size", Vector2(4, 4))  # Set the size of the label
		label.set("font", label.get("font:source"))  # Use the default font
		label.set("font_size", 4)  # Set the font size (adjust as needed)
		label.modulate = Color(0, 0, 0.5)  # Set font color to red
		self.add_child(label)




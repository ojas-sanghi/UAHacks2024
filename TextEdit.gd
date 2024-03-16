extends TextEdit

func _ready():
	# Set the custom theme for TextEdit
	set_custom_theme()
	
func set_custom_theme():
	# Create a new Theme resource
	var theme = Theme.new()

	# Create a StyleBoxFlat for the background with transparency
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0, 0, 0, 0) # Fully transparent
	
	# Set the StyleBoxFlat to the "normal" style
	theme.set_stylebox("TextEdit", "normal", stylebox)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

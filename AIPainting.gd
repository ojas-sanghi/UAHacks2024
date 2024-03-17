extends TextureRect

func _ready():
	$HTTPRequest.request_completed.connect(_on_ai_painting_req_completed)

	var url := "https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-xl-base-1.0"
	
	var headers := ["Authorization: Bearer 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", "Content-Type: application/json"]
	
	var data := {
		"inputs": "A highly detailed, photorealistic image of an exquisite gold necklace with intricate filigree and precious gemstones, masterfully crafted with exceptional attention to detail, showcasing the pinnacle of luxury and opulence."
	}
	
	var body_string := JSON.stringify(data)
	print(body_string)
	var req = $HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, body_string)
	
	# Check for errors
	if req != OK:
		print("An error occurred when trying to perform the request.")

func _on_ai_painting_req_completed(result, response_code, headers, body):
	# Check if the request was successful
	if result == HTTPRequest.RESULT_SUCCESS:
		var image = Image.new()
		var error = image.load_jpg_from_buffer(body)
		
		var texture: = ImageTexture.create_from_image(image)
		
		var sprite = Sprite2D.new()
		sprite.set_texture(texture)
		
		print(sprite.texture.get_width())
		print(sprite.texture.get_height())
		
		add_child(sprite)
		
		# tood; resize froem 1024 to 512
	else:
		print("The request failed.")

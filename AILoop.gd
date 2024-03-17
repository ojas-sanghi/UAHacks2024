extends Node

func _ready():
	$WordValue.request_completed.connect(_on_word_value_req_completed)
	$AIGenPrompt.request_completed.connect(_on_ai_gen_prompt_req_completed)
	$AIPainting.request_completed.connect(_on_ai_painting_req_completed)
	
	get_word_value()

var word = "water bottle"

func get_word_value():
	var headers := ["x-api-key: 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", "anthropic-version: 2023-06-01", "content-type: application/json"]
	var body := {
		"model": "claude-3-haiku-20240307",
		"max_tokens": 1000,
		"temperature": 0,
		"system": "There are 4 categories of value any word can be assigned to: \n\n- Trash\n- Common\n- Valuable\n- Exceptional\n\nJudge how \"valuable\" a given word is by that word's perceived value in the real world. I will give you words and your job is to judge how \"valuable\" they are and return to me which category they are in. Say nothing but the answer. Nothing but the one or two words.\n\nExample:\n\nPlastic bottle. Trash.\nWater bottle. Common.\nGold. Exceptional.\nMobile Phone. Valuable.\nAirPods. Valuable.\nBackpack. Common.\nPlants. Uncommon.\nLight bulb. Common.\nOil. Exceptional.\nWrappers. Trash.\nNapkins. Trash.\nChair. Common\nPerfume. Common.\nWatch. Common.\nExpensive watch. Valuable.\nPorsche. Exceptional.\n",
		"messages": [
			{"role": "user", "content": word}
		]
	}
	var body_string := JSON.stringify(body)
	print(body_string)
	var req = $WordValue.request("https://api.anthropic.com/v1/messages", headers, HTTPClient.METHOD_POST, body_string)
	
	# Check for errors
	if req != OK:
		print("An error occurred when trying to perform the request.")

func _on_word_value_req_completed(result, response_code, headers, body):
	# Check if the request was successful
	if result == HTTPRequest.RESULT_SUCCESS:
		# Parse the response body text as JSON
		var json = JSON.new()
		var body_string = body.get_string_from_utf8()
		var body_response = json.parse_string(body.get_string_from_utf8())
		
		var value = body_response["content"][0]["text"]
		get_ai_gen_prompt(value)
	else:
		print("The request failed.")

func get_ai_gen_prompt(value):
	var headers := ["x-api-key: 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", "anthropic-version: 2023-06-01", "content-type: application/json"]
	var body := {
		"model": "claude-3-haiku-20240307",
		"max_tokens": 1000,
		"temperature": 0,
		"system": "Generate a detailed and high-quality AI image generation prompt for the Stable Diffusion model. I will give you a word or two around which to generate prompt. Make a prompt that generates art that would be \"valued\" according to society as the following value: " + value + ". \n\nReturn just the prompt in it's full form. Include nothing else. No text before or after. No quotes. Just the prompt.",
		"messages": [
			{"role": "user", "content": word}
		]
	}
	var body_string := JSON.stringify(body)
	print(body_string)
	var req = $AIGenPrompt.request("https://api.anthropic.com/v1/messages", headers, HTTPClient.METHOD_POST, body_string)
	
	# Check for errors
	if req != OK:
		print("An error occurred when trying to perform the request.")

func _on_ai_gen_prompt_req_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.new()
		var body_string = body.get_string_from_utf8()
		var body_response = json.parse_string(body.get_string_from_utf8())
		
		var ai_gen_prompt = body_response["content"][0]["text"]
		get_ai_painting(ai_gen_prompt)
	else:
		print("The request failed.")

func get_ai_painting(ai_gen_prompt):
	var url := "https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-xl-base-1.0"
	
	var headers := ["Authorization: Bearer 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", "Content-Type: application/json"]
	
	var data := {
		"inputs": ai_gen_prompt
	}
	
	var body_string := JSON.stringify(data)
	print(body_string)
	var req = $AIPainting.request(url, headers, HTTPClient.METHOD_POST, body_string)
	
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
		
		sprite.position = Vector2(512, 512)
		sprite.scale = Vector2(0.5, 0.5)
		
		add_child(sprite)
		
		# tood; resize froem 1024 to 512
	else:
		print("The request failed.")

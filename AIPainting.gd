extends TextureRect

func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	
	var url := "https://api.novita.ai/v3/async/txt2img"
	var headers := ["Authorization: Bearer a584ebc3-a756-405f-baf9-069d3a524ba1", "content-type: application/json"]
	#var data := {
	#"request": {
		#"model_name": "pixel-art-xl-v1.1_99321",
		#"prompt": "a detailed, high-quality pixel art image of a simple, everyday chair, with a clean and minimalist design, in a neutral color palette",
		#"negative_prompt": "overly complex or detailed chair, abstract or surreal chair, chair with extraneous elements or distractions",
		#"loras": [
			#{
				#"model_name": "",
				#"strength": null
			#}
		#],
		#"embeddings": [
			#{
				#"model_name": ""
			#}
		#],
		#"hires_fix": {
			#"target_width": null,
			#"target_height": null,
			#"strength": null,
			#"upscaler": "RealESRNet_x4plus"
		#},
		#"refiner": {
			#"switch_at": null
		#},
		#"width": 512,
		#"height": 512,
		#"image_num": 1,
		#"steps": 20,
		#"seed": 123,
		#"clip_skip": 1,
		#"guidance_scale": 10,
		#"sampler_name": "Euler a"
	#}
#}

	var data := {
		"request": {
			"model_name": "pixel-art-xl-v1.1_99321",
			"prompt": "a simple, minimalist pixel art chair, clean lines, basic colors, common design, everyday object",
			"negative_prompt": "complex, detailed, intricate, high-quality, detailed textures, photorealistic, 3d, realistic, detailed shading",
			"loras": [
				{
					"model_name": "",
					"strength": null
				}
			],
			"embeddings": [
				{
					"model_name": ""
				}
			],
			"hires_fix": {
				"target_width": null,
				"target_height": null,
				"strength": null,
				"upscaler": "RealESRNet_x4plus"
			},
			"refiner": {
				"switch_at": null
			},
			"width": 512,
			"height": 512,
			"image_num": 1,
			"steps": 50,
			"seed": 123456,
			"clip_skip": 1,
			"guidance_scale": 7.5,
			"sampler_name": "Euler a"
		}
	}
	var body_string := JSON.stringify(data)
	print(body_string)
	var req = $HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, body_string)
	
	# Check for errors
	if req != OK:
		print("An error occurred when trying to perform the request.")
	
	
	# then,
	#curl --location 'https://api.novita.ai/v3/async/task-result?task_id=96755ce9-8db3-49ab-b081-54a57f03fc7a' \
	#--header 'Authorization: Bearer {{key}}'

func _on_request_completed(result, response_code, headers, body):
	# Check if the request was successful
	if result == HTTPRequest.RESULT_SUCCESS:
		# Parse the response body text as JSON
		var json = JSON.new()
		var body_string = body.get_string_from_utf8()
		var body_response = json.parse_string(body.get_string_from_utf8())
		var task_id = body_response["task_id"]
		var new_url := "https://api.novita.ai/v3/async/txt2img?task_id=" + str(task_id)
		var new_headers := ["Authorization: Bearer a584ebc3-a756-405f-baf9-069d3a524ba1"]
		var req = $HTTPRequest.request(new_url, headers, HTTPClient.METHOD_GET)
	else:
		print("The request failed.")

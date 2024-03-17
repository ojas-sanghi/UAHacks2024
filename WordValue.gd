extends Node

func _ready():
	$HTTPRequest.request_completed.connect(_on_word_value_req_completed)

func get_word_value(word):
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
	var req = $HTTPRequest.request("https://api.anthropic.com/v1/messages", headers, HTTPClient.METHOD_POST, body_string)
	
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
		
		print(body_response["content"][0]["text"])
	else:
		print("The request failed.")
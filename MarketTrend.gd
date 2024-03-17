extends Node

var market_trend_http: HTTPRequest

var latest_trend = null
var latest_trend_multiplier = null

var messages = []

func add_claude_message(value):
	messages.append({"role": "assistant", "content": [{"type": "text", "text": value}]})

func _ready():
	market_trend_http = HTTPRequest.new()
	add_child(market_trend_http)
	
	market_trend_http.request_completed.connect(_on_market_trend_req_completed)
	
	get_latest_market_trend()
	# to get tremd, do `while (true): if (latest_trend != null): <use trend>`

func get_latest_market_trend():
	latest_trend = null
	
	# TEMPORARY!!
	latest_trend = -7
	latest_trend_multiplier = (1 + (latest_trend / 100.0))
	return
	
	messages.append({"role": "user", "content": [{"type": "text", "text": "Next"}]})
	
	var headers := ["x-api-key: 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", "anthropic-version: 2023-06-01", "content-type: application/json"]
	var body := {
		"model": "claude-3-haiku-20240307",
		"max_tokens": 1000,
		"temperature": 0,
		"system": "We are in an imaginary world where there is a fast-moving art market. The prices of art pieces are like stocks and go up or down by a couple of percentage points every few seconds. Cheaper art is less volatile and more expensive art is more volatile. They are all affected by the same larger trends; if there is a recession, then they are all affected.\n\nTaking this into account, generate what the latest trend in the market was and tell me what it was. For the most part, stay within -10% to 10%, but sometimes, there may be a recession or huge jump, which would lead to much larger fluctuations. Occasionally, give me those larger % values as well. Refer to previous conversation history to see what historical trends have been. When I say the word \"Next\", give me the next market movement.\n\nTell me just the positive or negative % value, nothing else. Your output should look like this:\n\n+5%\n\nOR\n\n-3%.",
		"messages": messages
	}
	var body_string := JSON.stringify(body)
	print(body_string)
	var req = market_trend_http.request("https://api.anthropic.com/v1/messages", headers, HTTPClient.METHOD_POST, body_string)
	
	# Check for errors
	if req != OK:
		print("An error occurred when trying to perform the request.")
	

func _on_market_trend_req_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.new()
		var body_string = body.get_string_from_utf8()
		var body_response = json.parse_string(body.get_string_from_utf8())
		
		var value = body_response["content"][0]["text"]
		add_claude_message(value)
		
		print(value)
		
		latest_trend = value[1].to_int()
		if (value[0] == "-"):
			latest_trend *= -1
		latest_trend_multiplier = (1 + (latest_trend / 100.0))
	else:
		print("The request failed.")
	

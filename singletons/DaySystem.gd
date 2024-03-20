extends Node

var day_number := 0
var max_days := 5

signal new_day_start

func start_new_day():
	emit_signal("new_day_start")

func _ready():
	new_day_start.connect(_on_start_new_day)

func _on_start_new_day():
	if day_number == max_days:
		SceneChanger.go_to_end_screen()
	
	day_number += 1
	
	MarketTrend.get_latest_market_trend()
	while MarketTrend.latest_trend == null:
		await get_tree().create_timer(1.0).timeout
		
	print(MarketTrend.latest_trend_multiplier)
	
	SceneChanger.go_to_scene("res://day.tscn")

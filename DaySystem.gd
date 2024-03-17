extends Node

var day_number := 0

signal new_day_start

func start_new_day():
	emit_signal("new_day_start")

func _ready():
	new_day_start.connect(_on_start_new_day)

func _on_start_new_day():
	day_number += 1
	
	MarketTrend.get_latest_market_trend()
	await get_tree().create_timer(3.0).timeout
	print(MarketTrend.latest_trend_multiplier)

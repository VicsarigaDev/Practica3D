extends CanvasLayer

@onready var coin_label = $CoinLabel
@onready var timer_label = $TimerLabel

var coins = 0
var time_elapsed = 0.0

func update_coins(amount: int):
	coins += amount
	coin_label.text = "Monedas: " + str(coins)

func update_timer(delta: float):
	time_elapsed += delta
	timer_label.text = "Tiempo: " + str(snapped(time_elapsed, 0.1)) + " s"


func _on_coin_collected():
	update_coins(1)

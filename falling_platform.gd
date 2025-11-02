extends Node3D

@onready var body = $StaticBody3D
@onready var area = $Area3D
@onready var timer = $Timer

var is_falling = false
var fall_delay = 0.7
var fall_speed = 4.0

func _ready():
	timer.wait_time = fall_delay
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)

	# ✅ Conectar la señal del área (no del StaticBody3D)
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(other_body):
	if not is_falling and other_body.name == "Player3DTemplate":
		print("Jugador pisó la plataforma")
		timer.start()

func _on_timer_timeout():
	is_falling = true
	print("La plataforma se cae")

func _process(delta):
	if is_falling:
		position.y -= fall_speed * delta

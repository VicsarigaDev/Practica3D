extends "res://EnemyBase.gd"

@export var jump_force: float = 10.0
@export var gravity: float = 20.0
@export var jump_interval: float = 2.0  # tiempo entre saltos

var time_since_jump := 0.0

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.x = 0  # sin movimiento horizontal

	# Saltos periódicos
	time_since_jump += delta
	if time_since_jump >= jump_interval and is_on_floor():
		velocity.y = jump_force
		time_since_jump = 0.0

	move_and_slide()

func _on_area_3d_body_entered(body):
	if body.name == "Player3DTemplate":
		print("💥 El saltador dañó al jugador")
		var hud = get_tree().current_scene.get_node_or_null("HUD")
		if hud:
			hud.take_damage(15)

extends "res://EnemyBase.gd"

@export var speed: float = 4.0
@export var explosion_radius: float = 3.0
@export var explosion_damage: int = 40
@export var explosion_delay: float = 1.0  # segundos antes de explotar
@export var gravity: float = 20.0

var player: Node3D = null
var is_exploding = false

@onready var detection_area = $DetectionArea
@onready var explosion_area = $ExplosionArea
@onready var explosion_timer = $ExplosionTimer
@onready var explosion_sound = $AudioStreamPlayer3D

func _ready():
	detection_area.body_entered.connect(_on_detection_body_entered)
	detection_area.body_exited.connect(_on_detection_body_exited)
	explosion_timer.timeout.connect(_explode)

func _physics_process(delta):
	if is_exploding:
		return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		# Si está muy cerca, iniciar cuenta regresiva para explotar
		if global_position.distance_to(player.global_position) < explosion_radius:
			start_explosion()
	else:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()

func _on_detection_body_entered(body):
	if body.name == "Player3DTemplate":
		player = body

func _on_detection_body_exited(body):
	if body == player:
		player = null

func start_explosion():
	if not is_exploding:
		is_exploding = true
		explosion_timer.start(explosion_delay)
		if explosion_sound:
			explosion_sound.play()
		print("💣 Iniciando cuenta regresiva de explosión")

func _explode():
	print("💥 ¡Explosión!")

	# Activar área de daño
	explosion_area.monitoring = true

	# Activar partículas
	var particles = $ExplosionParticles
	particles.emitting = true

	# Reproducir sonido si existe
	if explosion_sound:
		explosion_sound.play()

	# Esperar a que termine el efecto antes de eliminar el enemigo
	await get_tree().create_timer(0.6).timeout
	queue_free()



func _on_explosion_area_body_entered(body):
	if body.name == "Player3DTemplate":
		print("🔥 El jugador fue alcanzado por la explosión")
		var hud = get_tree().current_scene.get_node_or_null("HUD")
		if hud:
			hud.take_damage(explosion_damage)

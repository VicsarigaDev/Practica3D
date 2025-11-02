extends Node3D

@onready var anim_player = $AnimationPlayer

func run():
	if anim_player and anim_player.has_animation("Run"):
		anim_player.play("Run")

func idle():
	if anim_player and anim_player.has_animation("Idle"):
		anim_player.play("Idle")

func jump():
	if anim_player and anim_player.has_animation("Jump"):
		anim_player.play("Jump")

func fall():
	if anim_player and anim_player.has_animation("Fall"):
		anim_player.play("Fall")

func move():
	run()  # usa la animación de correr cuando se mueve

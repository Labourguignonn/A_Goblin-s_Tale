extends Node2D

@export var speed: float = 1.5
@export var attack_cooldown = 0.0
@onready var input_vector: Vector2


var enemy: Enemy
var attack_area: Area2D
var animation_player: AnimatedSprite2D 
var is_following: bool = true
var is_attacking: bool = false
var can_attack: bool = false
var attack_animation: AnimationPlayer


func _ready():
	enemy = get_parent()
	animation_player = enemy.get_node("AnimatedSprite2D")
	attack_area = enemy.get_node("Attack_area")

func _process(delta):
	play_run_idle_anim()
	rotate_sprite()
	attack(delta)
	
func _physics_process(delta) -> void:
	var player_pos = GameManager.player_position
	var difference = player_pos - enemy.position
	input_vector = difference.normalized()
	if is_following == true:
		move(input_vector)
	enemy.move_and_slide()

func rotate_sprite()-> void:
	if input_vector.x > 0:
		animation_player.flip_h = false
	elif input_vector.x < 0:
		animation_player.flip_h = true

func play_run_idle_anim() ->void:
	animation_player.play("walk")

func move(input_vector:Vector2)-> void:
	if GameManager.is_game_over: return
	var target_velocity = input_vector * speed * 100.0
	enemy.velocity = lerp(enemy.velocity,target_velocity,0.08)

func attack(delta)-> void:
	if attack_cooldown > 0.0: 
		attack_cooldown -= delta
		return
	
	attack_cooldown = 1
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			body.damage(10)
# Replace with function body.

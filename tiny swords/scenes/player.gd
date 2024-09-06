extends CharacterBody2D

@export var speed: float = 3
@export var sword_damage: int = 2
@export var health: int = 100
@export var max_health: int = 100
@export var death_prefab: PackedScene
@export_category("Ritual")
@export var super_attack_prefab: PackedScene
@export var ritual_damage:int = 1
@export var ritual_interval: float = 30


@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword_area: Area2D = $Area2D
@onready var health_progress_bar:ProgressBar = %PlayerLife

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking:bool = false
var attack_cooldown:float = 0.8
var ritual_cooldown: float = 0.0
var time_over: bool = false

func _process(delta: float) -> void:
	#ler input
	GameManager.player_position = position
	read_input()
	
	#Ataque
	update_attack_coold(delta)
	if Input.is_action_just_pressed("attack_side"):
		attack()
	call_super_attack()
	
	#processar animação e rodar sprite
	if !is_attacking:
		rotate_sprite()
	play_run_idle_anim()
	
	#Atualizar healthbar
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health
		
func _physics_process(delta) -> void:
	#obter o input vector e aplicar a velocidade
	var target_velocity = input_vector * speed * 100
	if is_attacking:
		target_velocity *= 0.5
	velocity = lerp(velocity,target_velocity,0.08)
	move_and_slide()

func read_input() -> void:
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down",0.15)
	
	#atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
func attack() -> void:
	if is_attacking:
		return
	animation_player.play("Attack_right")
	attack_cooldown = 0.6
	is_attacking = true
	#aplicar dano()

func play_run_idle_anim() ->void:
	#trocar_animação
	if !is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("walk")
			else:
				animation_player.play("idle")
				
func rotate_sprite()->void:
	#girar o sprite
	if input_vector.x > 0:
		animation_player.flip_h = false
	elif input_vector.x < 0:
		animation_player.flip_h = true
		
func update_attack_coold(delta)->void:
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")	

func deal_damage_to_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies") || body.is_in_group("sheeps"):
			var enemy = body
			var direction_to_enemy =(enemy.position - position).normalized()
			var attack_direction: Vector2
			if animation_player.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.5:
				enemy.damage(sword_damage)
				

func _on_animated_sprite_2d_frame_changed():
	if is_attacking && animation_player.get_frame() == 3:
		deal_damage_to_enemies()
		# Replace with function body.
func damage(amount:int) -> void:
	health -= amount
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	if health <= 0:
		die()

func die()->void:
	GameManager.end_game()
	if death_prefab:
		var death_object = death_prefab.instantiate()
		if self.name == "sheep":
			death_object.position = Vector2(position.x + 30, position.y)
			death_object.scale = Vector2(0.52,0.54)
		elif self.name == "knight":
			death_object.scale = Vector2(1.11,1.14)
			death_object.position = position
		else:
			death_object.position = position
		get_parent().add_child(death_object)
	queue_free()
			
func heal(amount: int)	-> int:
	health = min(max_health,health + amount)
	return health

func call_super_attack():
	if Input.is_action_just_pressed("super_attack"):
		super_attack()

func super_attack()->void:
	if super_attack_prefab:
		var flame_thrower = super_attack_prefab.instantiate()
		flame_thrower.position = Vector2.ZERO
		add_child(flame_thrower)

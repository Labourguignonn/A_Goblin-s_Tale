extends RigidBody2D
@onready var explosionArea: Area2D = $Area2D
@export var direction: Vector2 = Vector2(1, 0)
@export var damage_explosion:float = 20
@export var speed_dynamite: float = 300
@onready var stop: bool = false
@onready var can_damage:bool = true

var current_speed: float
func _physics_process(delta):
	current_speed = speed_dynamite
	if !stop:
		position += direction * speed_dynamite * delta

func damage_to_enemies() ->void:
		var bodies = explosionArea.get_overlapping_bodies()
		for body in bodies:
			print(body.name)
			if body.is_in_group("enemies"):
				body.damage(damage_explosion)
	
func stopping():
	stop = true

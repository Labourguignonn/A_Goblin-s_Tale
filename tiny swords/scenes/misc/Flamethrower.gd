extends Area2D

@export var damage: int = 10
@onready var attack_cooldown:float = 0
@onready var area2d: Area2D = $Area2D

func _process(delta):
	fire_damage(delta)

func fire_damage(delta):
	var bodies = area2d.get_overlapping_bodies()
	for body in bodies:
		print("atacou")
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			enemy.damage(damage)
	


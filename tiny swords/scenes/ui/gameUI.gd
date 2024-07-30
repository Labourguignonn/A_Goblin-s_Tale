class_name GameUI
extends CanvasLayer


@onready var timer_label:Label = %timer_label
@onready var death_label:Label = %death_label


func _process(delta: float):
	timer_label.text = GameManager.time_elapsed_string
	death_label.text = str(GameManager.death_count)
	
func increase_death()->void:
	GameManager.death_count += 1
	

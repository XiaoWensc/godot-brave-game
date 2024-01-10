extends "res://scenes/base_world.gd"

@onready var to_world_1: Interactable = $toWorld1

func _ready() -> void:
	to_world_1.interacted.connect(_to_world1)
	
	
func _to_world1():
	get_tree().change_scene_to_file("res://scenes/world.tscn")

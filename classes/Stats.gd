class_name Stats
extends Node

signal health_changed
signal energy_changed

## 最大血量
@export var max_health: int = 3
## 最大能量
@export var max_energy: float = 3
## 没帧回复的能量
@export var energy_regen: float = 0.2

## 当前血量
@onready var health: int = max_health:
	set(v):
		v = clamp(v, 0, max_health)
		if v == health:
			return
		health = v
		health_changed.emit()

## 当前能量
@onready var energy: float = max_energy:
	set(v):
		v = clamp(v, 0, max_energy)
		if v == energy:
			return
		energy = v
		energy_changed.emit()

func _process(delta: float) -> void:
	energy += energy_regen * delta

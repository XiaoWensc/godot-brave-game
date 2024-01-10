extends HBoxContainer

@export var stats: Stats

@onready var health_bar: TextureProgressBar = $V/HealthBar
@onready var eased_health_bar: TextureProgressBar = $V/HealthBar/EasedHealthBar
@onready var energy_bar: TextureProgressBar = $V/EnergyBar


func _ready() -> void:
	stats.health_changed.connect(update_health)
	update_health(true)
	
	stats.energy_changed.connect(update_energy)
	update_energy(true)
	

func update_health(is_init := false) -> void:
	var percentage := (stats.health if not is_init else stats.max_health )/ float(stats.max_health)
	health_bar.value = percentage
	
	create_tween().tween_property(eased_health_bar, "value", percentage, 0.5)

func update_energy(is_init := false) -> void:
	var percentage := (stats.energy if not is_init else stats.max_energy )/ float(stats.max_energy)
	energy_bar.value = percentage
	

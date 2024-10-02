extends Node2D

@export var machineGunUnit: PackedScene = preload("res://res/machine-gunner/machinegunner.tscn")

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			spawnMG(get_global_mouse_position())
		
func spawnMG(spawn_global_position: Vector2) -> void:
	var instance: Node2D = machineGunUnit.instantiate()
	instance.global_position = spawn_global_position
	add_child(instance)
	

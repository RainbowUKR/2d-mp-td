extends Node2D

@export var MachineGunner: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			print("Left mouse button")
			var machinegunnerInst = MachineGunner.instantiate()
			var spawnPosition = get_global_mouse_position()
			machinegunnerInst.global_position = position
			add_child(machinegunnerInst)

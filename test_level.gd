extends Node2D

@export var MachineGunner: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			print("Left mouse button")
			var machinegunnerInst = MachineGunner.instantiate()
			var position = get_viewport().get_mouse_position()
			
			

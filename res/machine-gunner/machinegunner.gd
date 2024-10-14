extends Node2D

const BULLET_SPEED = 100
const BULLET_COUNT = 50

@export var MaxReloadTime : float = 2.0
@export var SpreadAngle : float = 5.0
@export var TimeBetweenShotsMax : float = 0.15
const bullet_image := preload("res://res/machine-gunner/bullet.png")

var IsReloading : bool = false;

var ReloadingTimer : float = 0.0
var TimeBetweenShotsTimer : float = 0.0

var bullets_fired = 0

var bullets := []
var shape := RID()

class Bullet:
	var position := Vector2()
	var speed := 1.0
	var speedVec := Vector2(0,-1)
	# The body is stored as a RID, which is an "opaque" way to access resources.
	# With large amounts of objects (thousands or more), it can be significantly
	# faster to use RIDs compared to a high-level approach.
	var body := RID()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!IsReloading):
		if(TimeBetweenShotsTimer == 0.0):
			Fire()
		TimeBetweenShotsTimer += delta
		if(TimeBetweenShotsMax < TimeBetweenShotsTimer):
			TimeBetweenShotsTimer = 0.0
	else:
		Reload(delta)
	queue_redraw()

func _physics_process(delta: float) -> void:
	var transform2d := Transform2D()
	for bullet: Bullet in bullets:
		if((bullet.position.y < 0) or (bullet.position.y > get_viewport().get_visible_rect().size.y)):
			PhysicsServer2D.free_rid(bullet.body)
			bullets.erase(bullet)
			continue
		bullet.position += bullet.speed * delta * bullet.speedVec
		transform2d.origin = bullet.position
		PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)
		
func _draw() -> void:
	for bullet: Bullet in bullets:
		#we need to get canvas global transform and invert it, to draw bullet position correctly
		draw_texture(bullet_image, get_global_transform().inverse() * bullet.position)

# Perform cleanup operations (required to exit without error messages in the console).
func _exit_tree() -> void:
	for bullet: Bullet in bullets:
		PhysicsServer2D.free_rid(bullet.body)

	PhysicsServer2D.free_rid(shape)
	bullets.clear()

func Fire() -> void:
	shape = PhysicsServer2D.rectangle_shape_create()
	# Set the collision shape's radius for each bullet in pixels.
	PhysicsServer2D.shape_set_data(shape, Vector2(2,3))

	var bullet := Bullet.new()
	
	bullet.speed = BULLET_SPEED
	#set speed vec direction
	bullet.speedVec = bullet.speedVec.rotated(deg_to_rad(randf_range(-SpreadAngle, SpreadAngle)))
	bullet.speedVec = bullet.speedVec.normalized()
	bullet.body = PhysicsServer2D.body_create()	
	PhysicsServer2D.body_set_space(bullet.body, get_world_2d().get_space())
	PhysicsServer2D.body_add_shape(bullet.body, shape)
	
	# Don't make bullets check collision with other bullets to improve performance.
	PhysicsServer2D.body_set_collision_mask(bullet.body, 0)
	
	#place bullet in the middle of MG
	var sprite : Sprite2D = get_child(0)
	var spriteOffset = -sprite.get_rect().end * 0.5
	bullet.position = get_global_position() + spriteOffset
	var transform2d := Transform2D()
	transform2d.origin = bullet.position
	PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)

	bullets.push_back(bullet)
	bullets_fired += 1
	if(bullets_fired == BULLET_COUNT):
		IsReloading = true;
		bullets_fired = 0;

func Reload(delta: float) -> void:
	if(ReloadingTimer > MaxReloadTime):
		IsReloading = false;
		ReloadingTimer = 0.0
	else:
		ReloadingTimer += delta

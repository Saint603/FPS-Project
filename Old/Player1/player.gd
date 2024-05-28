extends CharacterBody3D

@export_category("Movement")
@export var DEFAULT_SPEED = 7.0
@export var SPRINT_SPEED : float = 9.0
@export var CROUCH_SPEED : float = 5.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var JUMP_VELOCITY : float = 5
@export var MOUSE_SENSITIVITY : float = 0.5

@export_category("Nodes")
@export var CAMERA_CONTROLLER : Camera3D
@export var ANIMATION_PLAYER : AnimationPlayer
@export var CROUCH_SHAPE : ShapeCast3D

var peer_id = null
var current_speed = DEFAULT_SPEED
var _mouse_rotation : Vector3
var _rotation_input : float
var _tilt_input : float

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") ##Commented out, but kept for reference
var gravity = 11.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	CROUCH_SHAPE.add_exception(self) ##add player as a collision exception
	%Camera3D.make_current()

func _input(event):
	if event.is_action_pressed("exit"): get_tree().quit()
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY

func _physics_process(_delta):
	pass

func _process(delta):
	_update_camera(delta)
	update_input(delta)
	move_and_slide()
	

func _update_camera(delta):
	#rotate camera
	_mouse_rotation.x = clamp(_mouse_rotation.x + (_tilt_input * delta), deg_to_rad(-90), deg_to_rad(90))
	_mouse_rotation.y += _rotation_input * delta
	CAMERA_CONTROLLER.rotation = Vector3(_mouse_rotation.x, 0.0, 0.0)
	rotation.y = _mouse_rotation.y
	_rotation_input = 0.0
	_tilt_input = 0.0
	
func update_gravity(delta):
	velocity.y -= gravity * delta

func update_input(_delta):
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * current_speed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0.0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0.0, DECELERATION)

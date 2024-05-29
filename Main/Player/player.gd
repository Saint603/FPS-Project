#each player increases mouse sensitivity :(
#fixed that but now he jitters non stop
#FIXED SOME JITTERS BUT NOW ANIMATIONS GO TWICE AS FAST WHEN CLIENT JOINS. AY CARAMBA

class_name Player
extends CharacterBody3D

signal weapon_fired

@export var custom_scale : Vector3 = Vector3(1,1,1)
@export_category("Health")
@export var MAX_HEALTH : int = 100

@export_category("Mouse")
@export var MOUSE_SENSITIVITY : float = 0.0005

@export_category("Movement")
@export var DEFAULT_SPEED = 7.0
@export var SPRINT_SPEED : float = 9.0
@export var CROUCH_SPEED : float = 5.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var JUMP_STRENGTH : float = 5

@onready var ANIMATION_PLAYER : AnimationPlayer = %AnimationPlayer
@onready var CROUCH_SHAPE : ShapeCast3D = %CrouchCheck
@onready var UI : Control = %UI
@onready var STATE_MACHINE : StateMachine = %StateMachine
@onready var CAMERA_RIG : FPSCamera = %CameraRig
@onready var CAMERA_CONTROLLER : Camera3D = %CameraRig.CAMERA
@onready var WEAPON_BASE : WeaponBase = %CameraRig.WEAPON_BASE

var current_weapon : Weapons
var current_speed = DEFAULT_SPEED
var current_health = MAX_HEALTH
var bullet_hole = preload("res://Art/2D/Bullet Hole/bullet_decal.tscn")
var bullet_hole_timeout : float = 1.5
var isIdle : bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	scale = custom_scale
	if mp_check(): #if we're not the authority, delete all extra problematic nodes
		UI.queue_free()
		return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	CAMERA_CONTROLLER.current = true

func _unhandled_input(event):
	if mp_check(): return 
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		update_camera(event)

func _physics_process(delta):
	if mp_check(): return
	WEAPON_BASE.sway_and_bob_weapon(delta, isIdle) ##putting this function here instead of in _process removes issue with vsync/frame rate differences
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

func _process(_delta):
	if mp_check(): return
	#Global.debug.add_property("State", STATE_MACHINE.CURRENT_STATE, 1)
	update_input()

func update_camera(event):
	rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
	CAMERA_RIG.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
	CAMERA_RIG.rotation.x = clamp(CAMERA_RIG.rotation.x, -PI/2, PI/2)
	WEAPON_BASE.mouse_movement = event.relative

func update_input():
	#directional movement (W,A,S,D stuff)
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * current_speed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0.0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0.0, DECELERATION)
	move_and_slide()

func attack():
	if mp_check(): return
	weapon_fired.emit()
	##First we emit our weapon fire signal, then we do a raycast...I could probably move this into its own function but not tonight's focus
	##Maybe move it into its own node within the camera rig.
	var space_state = CAMERA_CONTROLLER.get_world_3d().direct_space_state
	var screen_center = get_viewport().size / 2
	var origin = CAMERA_CONTROLLER.project_ray_origin(screen_center)
	var end = origin + CAMERA_CONTROLLER.project_ray_normal(screen_center) * 1000 ##1000 is range? maybe use this for inaccuracy
	var query = PhysicsRayQueryParameters3D.create(origin, end) ##make ray case
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result:
		###var instance = raycast_debug.instantiate()
		var instance = bullet_hole.instantiate()
		Global.game.synced_instances.add_child(instance)
		instance.global_position = result.get("position")
		if result.get("normal") != Vector3.UP and result.get("normal") != Vector3.DOWN:
			instance.look_at(instance.global_transform.origin + result.get("normal"), Vector3.UP)
		if result.get("normal") != Vector3.UP and result.get("normal") != Vector3.DOWN:
			instance.rotate_object_local(Vector3(1,0,0), 90)
		if result.get("collider").has_method("receive_damage"):
				result.get("collider").receive_damage.rpc(WEAPON_BASE.damage)
		await get_tree().create_timer(5).timeout
		var fade = get_tree().create_tween()
		fade.tween_property(instance, "modulate:a", 0, bullet_hole_timeout)
		await get_tree().create_timer(bullet_hole_timeout).timeout
		instance.queue_free()

func mp_check(): ##just a shorthand for a if statement that keeps popping up
	if Global.game.mode == Global.game.modes.MULTI_PLAYER and not is_multiplayer_authority(): return 1
	else: return 0

@rpc("any_peer")
func receive_damage(amount):
	current_health -= amount
	if current_health <= 0:
		current_health = 100
		position = Vector3.ZERO
	##health_changed.emit(current_health)



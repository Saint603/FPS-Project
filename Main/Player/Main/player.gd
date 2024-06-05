class_name Player
extends CharacterBody3D

signal weapon_trigger_down
signal weapon_trigger_up
signal player_loaded

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
@onready var ammo : Label = %Ammo
@onready var reticle : Reticle = %Reticle

var current_weapon : Weapons
var current_speed = DEFAULT_SPEED
var current_health = MAX_HEALTH
var bullet_hole = preload("res://Art/2D/Bullet Hole/bullet_decal.tscn")
var bullet_hole_timeout : float = 1.5
var isIdle : bool = false
var isPaused : bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	scale = custom_scale
	if mp_check(): #if we're not the authority, delete all extra problematic nodes
		STATE_MACHINE.queue_free()
		UI.queue_free()
		return
	Global.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	CAMERA_CONTROLLER.current = true
	player_loaded.emit()

func _process(_delta):
	if mp_check(): return
	#Global.debug.add_property("State", STATE_MACHINE.CURRENT_STATE, 1)
	update_input()

func _physics_process(delta):
	if mp_check(): return
	WEAPON_BASE.sway_and_bob_weapon(delta, isIdle) ##putting this function here instead of in _process removes issue with vsync/frame rate differences
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

func _unhandled_input(event):
	if mp_check(): return 
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		update_camera(event)

func update_camera(event):
	rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
	CAMERA_RIG.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
	CAMERA_RIG.rotation.x = clamp(CAMERA_RIG.rotation.x, -PI/2, PI/2)
	WEAPON_BASE.mouse_movement = event.relative

func update_input():
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("menu"):
		pause()
	if Input.is_action_just_pressed("reload") and !isPaused:
		CAMERA_RIG.WEAPON_RELOAD.reload()
	if Input.is_action_just_pressed("attack") and !isPaused:
		weapon_trigger_down.emit()
	if Input.is_action_just_released("attack"): #dont check for pause here so that the trigger releases on pause automatically
		weapon_trigger_up.emit()
	
	#directional movement (W,A,S,D stuff)
	#if we're not paused, we take input as normal. If we pause, we move towards 0 (as if player let go of keyboard).
	if direction and !isPaused:
		velocity.x = lerp(velocity.x, direction.x * current_speed, ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * current_speed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0.0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0.0, DECELERATION)
	move_and_slide()

func pause():
	isPaused = !isPaused
	if isPaused:
		weapon_trigger_up.emit()
		%PauseMenu.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		reticle.visible = false
	elif !isPaused:
		%PauseMenu.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		reticle.visible = true

func mp_check(): ##just a shorthand for a if statement that keeps popping up
	if Global.game.mode == Global.game.modes.MULTI_PLAYER and not is_multiplayer_authority(): return 1
	else: return 0

@rpc("any_peer")
func receive_damage(amount):
	current_health -= amount
	if current_health <= 0:
		current_health = 100
		position = Vector3.ZERO
	%HealthBar.value = (float(current_health) / float(MAX_HEALTH)) * 100
	##health_changed.emit(current_health)



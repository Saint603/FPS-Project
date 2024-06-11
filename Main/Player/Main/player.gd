class_name Player
extends CharacterBody3D
#Signals
signal weapon_trigger_down
signal weapon_trigger_up
signal player_loaded
signal weapon_switched
#Exports, arranged by appearance in editor
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

@export_category("Inventory")
@export var inventory : Array[Weapons]
@export_range(0, 1, 1) var equipped_item_index : int

@onready var ANIMATION_PLAYER : AnimationPlayer = %AnimationPlayer
@onready var CROUCH_SHAPE : ShapeCast3D = %CrouchCheck
@onready var UI : Control = %UI
@onready var STATE_MACHINE : StateMachine = %StateMachine
@onready var CAMERA_RIG : FPSCamera = %CameraRig
@onready var CAMERA_CONTROLLER : Camera3D = %CameraRig.CAMERA
@onready var WEAPON_BASE : WeaponBase = %CameraRig.WEAPON_BASE
@onready var AMMO_LABEL : Label = %Ammo
@onready var RETICLE : Reticle = %Reticle
#Local variables
var current_weapon : Weapons #current weapon is redundant now with inventory and inventory index.
var current_speed = DEFAULT_SPEED
var current_health = MAX_HEALTH
var bullet_hole = preload("res://Art/2D/Bullet Hole/bullet_decal.tscn")
var bullet_hole_timeout : float = 1.5
var isIdle : bool = false
var isPaused : bool = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") #Get the gravity from the project settings to be synced with RigidBody nodes

#Editor Functions
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	scale = custom_scale
	current_weapon = inventory[equipped_item_index]
	if mp_check(): #If we're not the authority, delete all extra problematic nodes
		STATE_MACHINE.queue_free()
		UI.queue_free()
	else: 
		Global.player = self
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		CAMERA_CONTROLLER.current = true
	player_loaded.emit()

func _process(_delta):
	pass

func _physics_process(delta):
	if mp_check(): return
	WEAPON_BASE.sway_and_bob_weapon(delta, isIdle) #Putting this function here instead of in _process removes issue with vsync/frame rate differences
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide() #im wondering which process function this really should belong to

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


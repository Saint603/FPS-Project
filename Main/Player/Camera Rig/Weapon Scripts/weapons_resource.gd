class_name Weapons
extends Resource

enum FireModes {SINGLE, BURST, AUTO}

@export var name : StringName

@export_category("Weapon Stats")
@export var FIRE_MODE : FireModes = FireModes.SINGLE
@export var BURST_LENGTH : int = 3
@export var damage : float = 25
@export var MAX_AMMO : int = 7
@export var RELOAD_TIME : float = 2
@export var FIRE_RATE : float = 2 ##shots per second ( 1 / fire rate)

@export_category("Weapon Transform")
@export var position : Vector3
@export var rotation : Vector3
@export var scale : float = 1.0

@export_category("Weapon Bob")
@export_range(0,10,0.01) var bob_speed : float = 0.07
@export_range(0,20,0.01) var bob_amount_x : float = 10
@export_range(0,20,0.01) var bob_amount_y : float = 10

@export_category("Weapon Sway")
@export var sway_min : Vector2 = Vector2(-100, -100)
@export var sway_max : Vector2 = Vector2(100, 100)
@export_range(0, 0.2, 0.01) var sway_speed_position : float = 0.01
@export_range(0, 0.2, 0.01) var sway_speed_rotation : float = 0.01
@export_range(0, 0.25, 0.01) var sway_amount_position : float = 0.25
@export_range(0, 50, 0.5) var sway_amount_rotation : float = 50
@export var idle_sway_adjustment : float = 10
@export var idle_sway_rotation_strength : float = 300
@export_range(0.1, 10, 0.1) var random_sway_amount : float = 5.0

@export_category("Visual Settings")
@export var mesh : Mesh
@export var shadow : bool

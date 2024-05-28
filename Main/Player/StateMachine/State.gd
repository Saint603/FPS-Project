#TODO readd player declarations once im done testing new player class. See varable lists here and maybe in the state machine and reticle
class_name State
extends Node

var ANIMATION_SPEED = 2
var PLAYER 
var ANIMATION_PLAYER : AnimationPlayer
var CROUCH_SHAPECAST : ShapeCast3D
var WEAPON_BASE : WeaponBase

signal transition(new_state_name: StringName)

func _ready():
	await owner.ready
	PLAYER = owner
	ANIMATION_PLAYER = PLAYER.ANIMATION_PLAYER
	CROUCH_SHAPECAST = PLAYER.CROUCH_SHAPE
	WEAPON_BASE = PLAYER.WEAPON_BASE

func enter(_current_state):
	pass
	
func exit():
	pass
	
func update(_delta):
	pass
	
func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, PLAYER.current_speed, 0, 1)
	ANIMATION_PLAYER.speed_scale = lerp(0, ANIMATION_SPEED, alpha)

func player_update_full(current_speed, ACCELERATION, DECELERATION, isIdle):
	PLAYER.current_speed = current_speed
	PLAYER.ACCELERATION = ACCELERATION
	PLAYER.DECELERATION = DECELERATION
	PLAYER.isIdle = isIdle


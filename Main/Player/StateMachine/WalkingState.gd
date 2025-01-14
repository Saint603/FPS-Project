class_name WalkingState
extends State


func enter(_previous_state):
	player_update_full(PLAYER.DEFAULT_SPEED, PLAYER.ACCELERATION, PLAYER.DECELERATION, false)

func exit():
	ANIMATION_PLAYER.speed_scale = 1.0
	
func update(_delta):
	if PLAYER.velocity.length() == 0.0:
		transition.emit("IdlingState")
	if Input.is_action_just_pressed("sprint"):
		transition.emit("SprintingState")
	if Input.is_action_just_pressed("crouch"):
		transition.emit("CrouchingState")
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingState")

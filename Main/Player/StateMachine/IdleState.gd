class_name IdlingState
extends State

func enter(_previous_state):
	#ANIMATION_PLAYER.pause()
	player_update_full(PLAYER.DEFAULT_SPEED, PLAYER.ACCELERATION, PLAYER.DECELERATION, true)
	
func update(_delta):
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingState")
	if Input.is_action_just_pressed("crouch"):
		transition.emit("CrouchingIdleState")
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingState")
	if Input.is_action_just_pressed("shoot"):
		PLAYER.attack()

class_name JumpingState
extends State

@export_range (0.5, 1.0, 0.1) var INPUT_MULTIPLIER : float = 0.85

func enter(_previous_state):
	player_update_full(PLAYER.DEFAULT_SPEED, PLAYER.ACCELERATION, PLAYER.DECELERATION, false)
	if _previous_state.name != "CrouchingJumpState":
		PLAYER.velocity.y += PLAYER.JUMP_STRENGTH
	ANIMATION_PLAYER.pause()

func update(_delta):
	if PLAYER.is_on_floor():
		transition.emit("IdlingState")
	if Input.is_action_just_pressed("crouch"):
		transition.emit("CrouchingJumpState")
	if Input.is_action_just_pressed("shoot"):
		PLAYER.attack()


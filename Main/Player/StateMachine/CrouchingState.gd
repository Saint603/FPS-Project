class_name CrouchingState
extends State

func enter(_previous_state):
	if _previous_state.name != "CrouchingIdleState" and _previous_state.name != "CrouchingJumpState":
		ANIMATION_PLAYER.play("crouch", -1.0, PLAYER.CROUCH_SPEED)
	player_update_full(PLAYER.CROUCH_SPEED, PLAYER.ACCELERATION, PLAYER.DECELERATION, false)
	
func update(_delta):
	if PLAYER.velocity == Vector3.ZERO:
		transition.emit("CrouchingIdleState")
	if Input.is_action_just_released("crouch"):
		uncrouch()
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("CrouchingJumpState")

func uncrouch():
	if CROUCH_SHAPECAST.is_colliding() == false and Input.is_action_pressed("crouch") == false:
		ANIMATION_PLAYER.play("crouch", -1.0, -PLAYER.CROUCH_SPEED * 1.5, true)
		if ANIMATION_PLAYER.is_playing():
			await ANIMATION_PLAYER.animation_finished
		transition.emit("IdlingState")
	elif CROUCH_SHAPECAST.is_colliding() == true:
		await get_tree().create_timer(0.1).timeout
		uncrouch()

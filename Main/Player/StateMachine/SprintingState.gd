class_name SprintingState
extends State

func enter(_previous_state):
	player_update_full(PLAYER.SPRINT_SPEED, PLAYER.ACCELERATION, PLAYER.DECELERATION, false)

func exit():
	ANIMATION_PLAYER.speed_scale = 1.0
	
func update(_delta):
	##set_animation_speed(PLAYER.velocity.length()) #example of how to do this for later
	if Input.is_action_just_released("sprint"):
		transition.emit("WalkingState")
	if Input.is_action_just_pressed("crouch"):
		transition.emit("CrouchingState")
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingState")

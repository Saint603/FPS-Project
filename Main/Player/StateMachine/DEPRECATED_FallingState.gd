class_name FallingState
extends State

func enter(_previous_state):
	ANIMATION_PLAYER.pause()
	player_update_full(PLAYER.CROUCH_SPEED, PLAYER.ACCELERATION, PLAYER.DECELERATION, false)

func update(_delta):
	if PLAYER.is_on_floor():
		transition.emit("IdlingState")

	

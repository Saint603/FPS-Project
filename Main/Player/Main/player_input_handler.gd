extends Node
class_name PlayerInput

@onready var PLAYER = owner
@onready var isPaused = PLAYER.isPaused
@onready var CAMERA_RIG = %CameraRig
@onready var MOUSE_SENSITIVITY =  PLAYER.MOUSE_SENSITIVITY
@onready var equipped_item_index = PLAYER.equipped_item_index

func _ready():
	set_process(!PLAYER.mp_check())

func _process(delta):
	update_input()

func switch_weapon(switch_up : bool): #True is up, false is down
	if switch_up:
		if equipped_item_index >= (PLAYER.inventory.size() - 1):
			equipped_item_index =  0
		else:
			equipped_item_index += 1
	else:
		if equipped_item_index <= 0:
			equipped_item_index = PLAYER.inventory.size() - 1
		else:
			equipped_item_index -= 1
	PLAYER.current_weapon =  PLAYER.inventory[equipped_item_index]
	PLAYER.weapon_switched.emit()
	
func pause():
	isPaused = !isPaused
	if isPaused:
		PLAYER.weapon_trigger_up.emit()
		%PauseMenu.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		PLAYER.RETICLE.visible = false
	elif !isPaused:
		%PauseMenu.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		PLAYER.RETICLE.visible = true
		
func _unhandled_input(event):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		update_camera(event)

#Custom Functions
func update_camera(event):
	PLAYER.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
	CAMERA_RIG.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
	CAMERA_RIG.rotation.x = clamp(CAMERA_RIG.rotation.x, -PI/2, PI/2)
	PLAYER.WEAPON_BASE.mouse_movement = event.relative

func update_input():
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "forward", "backward")
	var direction = (PLAYER.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#key binds
	if Input.is_action_just_pressed("menu"):
		pause()
	if Input.is_action_just_pressed("weapon_next") and !isPaused:
		switch_weapon(true) #true is up false is down
	if Input.is_action_just_pressed("weapon_prev")and !isPaused:
		switch_weapon(false) #true is up false is down
	if Input.is_action_just_pressed("reload") and !isPaused:
		CAMERA_RIG.WEAPON_RELOAD.reload()
	if Input.is_action_just_pressed("attack") and !isPaused:
		PLAYER.weapon_trigger_down.emit()
	if Input.is_action_just_released("attack"): #dont check for pause here so that the trigger releases on pause automatically
		PLAYER.weapon_trigger_up.emit()
	
	#directional movement (W,A,S,D stuff)
	#if we're not paused, we take input as normal. If we pause, we move towards 0 (as if player let go of keyboard).
	if direction and !isPaused:
		PLAYER.velocity.x = lerp(PLAYER.velocity.x, direction.x * PLAYER.current_speed, PLAYER.ACCELERATION)
		PLAYER.velocity.z = lerp(PLAYER.velocity.z, direction.z * PLAYER.current_speed, PLAYER.ACCELERATION)
	else:
		PLAYER.velocity.x = move_toward(PLAYER.velocity.x, 0.0, PLAYER.DECELERATION)
		PLAYER.velocity.z = move_toward(PLAYER.velocity.z, 0.0, PLAYER.DECELERATION)

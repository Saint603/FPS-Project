extends Node3D

@onready var light : OmniLight3D = %OmniLight3D
@onready var emitter : GPUParticles3D = %GPUParticles3D

var flash_time

func _ready():
	##TODO change individual function calls to singal style instead
	##weapon.weapon_fired.connect(add_recoil)
	pass
	
func add_muzzle_flash():
	light.visible = true
	emitter.emitting = true
	await get_tree().create_timer(flash_time).timeout
	light.visible = false

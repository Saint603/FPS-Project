class_name MuzzleFlash
extends Node3D

@onready var light : OmniLight3D = %OmniLight3D
@onready var emitter : GPUParticles3D = %GPUParticles3D

var flash_time : float

func add_muzzle_flash():
	#light.visible = true
	var light_copy : OmniLight3D = light.duplicate()
	var emitter_copy : GPUParticles3D = emitter.duplicate()
	add_child(emitter_copy)
	add_child(light_copy)
	light_copy.visible = true
	emitter_copy.emitting = true
	await get_tree().create_timer(flash_time).timeout
	light_copy.queue_free()
	emitter_copy.queue_free()

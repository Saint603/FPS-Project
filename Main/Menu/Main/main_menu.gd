class_name MainMenu
extends Control
@onready var game = get_node("/root/Game")

var debug = false
@onready var ERROR_LABEL = %ErrorLabel

func _on_host_pressed():
	if debug: debug_start()
	else: MP._host()
	hide()

func _on_join_pressed():
	if %Address.text == "": %Address.text = "localhost"
	if address_check(%Address.text):
		MP.address = %Address.text
		MP._join()
		hide()
	else: 
		%ErrorLabel.visible = true
		%ErrorLabel.text = "Invalid IP!"

func _on_address_text_submitted(_new_text):
	if address_check(_new_text):
		MP.address = _new_text
		MP._join()
		hide()
	else: 
		%ErrorLabel.visible = true
		%ErrorLabel.text = "Invalid IP!"

func debug_start():
	Global.game.add_child(Global.PLAYER_SCENE.instantiate())

func address_check(text : String):
	if text == "localhost" or text.is_valid_ip_address(): return 1
	
func _on_debug_mode_toggled(_toggled_on):
	debug = !debug
	%Join.disabled = !%Join.disabled
	%Address.visible = !%Address.visible

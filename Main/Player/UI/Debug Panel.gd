class_name DebugPanel
extends Panel

@onready var v_box_container = %VBoxContainer
var property
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	Global.debug = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _input(event):
	if event.is_action_pressed("debug"): visible = !visible

func add_property(title, value, order):
	var target
	target = v_box_container.find_child(title,true,false)
	if !target:
		target = Label.new()
		v_box_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:
		target.text = title + ": " + str(value)
		v_box_container.move_child(target,order)



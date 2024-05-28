class_name Reticle
extends CenterContainer

@export var DOT_RADIUS : float = 1.0
@export var DOT_COLOR : Color = Color.RED
@export var CROSSHAIR_THICKNESS : int = 4
@export var PLAYER_CONTROLLER : CharacterBody3D
@export var RETICLE_SPEED : float = 0.25
@export var RETICLE_DISTANCE : float = 2.0

var crosshair_lines = []

# Called when the node enters the scene tree for the first time.
func _ready():
	crosshair_lines = [%Top,%Right,%Bottom,%Left]
	for i in crosshair_lines:
		i.width = CROSSHAIR_THICKNESS
	queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	adjust_reticle_lines()

func _draw():
	draw_circle(Vector2(0,0), DOT_RADIUS, DOT_COLOR)

func adjust_reticle_lines():
	var vel = PLAYER_CONTROLLER.get_real_velocity()
	var origin = Vector3(0,0,0)
	var pos = Vector2(0,0)
	var speed = origin.distance_to(vel)
	
	crosshair_lines[0].position = lerp(crosshair_lines[0].position, pos + Vector2(0, -speed * RETICLE_DISTANCE), RETICLE_SPEED)
	crosshair_lines[1].position = lerp(crosshair_lines[1].position, pos + Vector2(speed * RETICLE_DISTANCE, 0), RETICLE_SPEED)
	crosshair_lines[2].position = lerp(crosshair_lines[2].position, pos + Vector2(0, speed * RETICLE_DISTANCE), RETICLE_SPEED)
	crosshair_lines[3].position = lerp(crosshair_lines[3].position, pos + Vector2(-speed * RETICLE_DISTANCE, 0), RETICLE_SPEED)

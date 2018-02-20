
extends Label

var speed = 40
var max_move = 40
var move = 0

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	var pos = get_position()
	var delta_move= (speed * delta)
	pos.y -= delta_move
	move += delta_move
	set_position(pos)
	if move >= max_move:
		queue_free()



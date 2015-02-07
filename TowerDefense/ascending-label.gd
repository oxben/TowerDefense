
extends Label

# member variables here, example:
# var a=2
# var b="textvar"

var speed = 40
var max_move = 20
var move = 0

func _ready():
	# Initalization here
	set_process(true)
	
func _process(delta):
	var pos = get_pos()
	var delta_move= (speed * delta)
	pos.y -= delta_move
	move += delta_move
	set_pos(pos)
	if move >= max_move:
		queue_free()



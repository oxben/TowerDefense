
extends RigidBody2D

var speed = 40

func _ready():
	add_to_group("enemy")
	set_fixed_process(true)

func _fixed_process(delta):
	if get_parent().get_unit_offset() < 1.0:
		get_parent().set_offset(get_parent().get_offset() + (speed * delta) )
	else:
		print(get_name() + " reached the fortress")
		queue_free()

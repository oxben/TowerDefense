
extends Sprite

const lifetime = 0.25
var time = 0

func _ready():
	set_frame(randi() % 4)
	set_fixed_process(true)

func _fixed_process(delta):
	time += delta
	if time > lifetime:
		queue_free()



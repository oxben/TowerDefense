
extends Sprite

const lifetime = 0.25
var time = 0
var frame_time = 0


func _ready():
	set_frame(randi() % 4)
	set_physics_process(true)
	var particles = get_node("Particles2D")
	if particles:
		particles.set_emitting(true)


func _physics_process(delta):
	time += delta
	frame_time += delta
	if time < lifetime:
		if frame_time > 0.04:
			set_frame(randi() % 4)
	elif is_visible():
		hide()
	if not get_node("AudioExplosion").is_playing():
		queue_free()
	


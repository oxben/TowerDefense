
extends RigidBody2D

var speed = 500
var direction = Vector2(0, -1)
var fire_range = 200
var damage = 5

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var pos = get_pos()
	if pos.y > -fire_range:
		set_pos(pos + (direction * speed * delta))
		#pos.y -= speed * delta
		#set_pos(pos)
	else:
		print("Bullet dies")
		queue_free()

func _on_body_enter(body):
	print("Hit!")
	if body.is_in_group("enemy"):
		body.hit(damage)
		queue_free()

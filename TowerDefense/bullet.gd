
extends RigidBody2D

var global

var speed = 300
var direction = Vector2(0, -1)
var fire_range = 200
var damage = 5

func _ready():
	global = get_node("/root/global")
	set_fixed_process(true)
	# Rotate bullet sprite
	var rad_angle = atan2(direction.x, direction.y) - atan2(0, -1)
	var sprite = get_node("Sprite")
	set_rot(rad_angle)

	
func _fixed_process(delta):
	var pos = get_pos()
	if pos.y > -fire_range:
		set_pos(pos + (direction * speed * delta))
		#pos.y -= speed * delta
		#set_pos(pos)
	else:
		#print("Bullet dies")
		queue_free()

func _on_body_enter(body):
	#print("Hit!")
	if body.is_in_group("enemy"):
		var scene = preload("res://explosion.scn")
		var explosion = scene.instance()
		explosion.set_pos(get_global_pos())
		get_node("/root").add_child(explosion)
		body.hit(damage)
		queue_free()

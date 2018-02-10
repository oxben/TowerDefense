
extends RigidBody2D

var global

var level = 1
var speed = 300
var direction = Vector2(0, -1)
var fire_range = 200
var damage = [ 0, 3, 4 ,5 ]

func _ready():
	global = get_node("/root/global")
	set_physics_process(true)
	# Set and rotate bullet sprite
	var sprite = get_node("Sprite")
	sprite.set_frame(level-1)
	var rad_angle = atan2(direction.x, -direction.y)
	set_rotation(rad_angle)


func _physics_process(delta):
	var pos = get_position()
	if pos.y > -fire_range:
		set_position(pos + (direction * speed * delta))
		#pos.y -= speed * delta
		#set_position(pos)
	else:
		#print("Bullet dies")
		queue_free()

func _on_body_enter(body):
	#print("Hit!")
	if body.is_in_group("enemy"):
		var scene = preload("res://explosion-small.tscn")
		var explosion = scene.instance()
		explosion.set_position(get_global_position())
		get_node("/root").add_child(explosion)
		body.hit(damage[level])
		queue_free()

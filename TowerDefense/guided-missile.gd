
extends RigidBody2D

var global

var level = 1
var speed = 200
var direction = Vector2(0, -1)
var target_path = ""
var target = null
var fire_range = 200
var damage = [0, 6, 8, 12]


func _ready():
	global = get_node("/root/global")
	set_fixed_process(true)
	# Set and rotate bullet sprite
	var sprite = get_node("Sprite")
	sprite.set_frame(level-1)
	target = get_node(target_path)
	direction = (target.get_global_pos() - get_global_pos()).normalized()
	var rad_angle = atan2(direction.x, direction.y) - atan2(0, -1)
	set_rot(rad_angle)

	
func _fixed_process(delta):
	var pos = get_pos()
	target = get_node(target_path)
	if target != null and pos.length() <= fire_range:
		direction = (target.get_global_pos() - get_global_pos()).normalized()
		var rad_angle = atan2(direction.x, direction.y) - atan2(0, -1)
		set_rot(rad_angle)
		set_pos(pos + (direction * speed * delta))
	else:
		queue_free()


func _on_body_enter(body):
	if body.is_in_group("enemy"):
		target = get_node(target_path)
		if target != body:
			return
		var scene = preload("res://explosion.xscn")
		var explosion = scene.instance()
		explosion.set_pos(get_global_pos())
		get_node("/root").add_child(explosion)
		body.hit(damage[level])
		queue_free()


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
	set_physics_process(true)
	# Set and rotate bullet sprite
	var sprite = get_node("Sprite")
	sprite.set_frame(level-1)
	target = get_node(target_path)
	direction = (target.get_global_position() - get_global_position()).normalized()
	var rad_angle = atan2(direction.x, -direction.y)
	set_rotation(rad_angle)


func _physics_process(delta):
	var pos = get_position()
	target = get_node(target_path)
	if target != null and pos.length() <= fire_range:
		# Check if target is not beneath us
		if target.get_global_position().distance_to(get_global_position()) < 8:
			hit_target()
			return
		# Rotate to target direction
		direction = (target.get_global_position() - get_global_position()).normalized()
		var rad_angle = atan2(direction.x, -direction.y)
		set_rotation(rad_angle)
		set_position(pos + (direction * speed * delta))
	else:
		queue_free()


func _on_body_enter(body):
	#if body.is_in_group("enemy"):
	target = get_node(target_path)
	if target != body:
		return
	else:
		hit_target()


func hit_target():
	var scene = preload("res://explosion.tscn")
	var explosion = scene.instance()
	explosion.set_position(get_global_position())
	get_node("/root").add_child(explosion)
	target.hit(damage[level])
	target = null
	queue_free()


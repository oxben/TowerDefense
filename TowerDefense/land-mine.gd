
extends RigidBody2D

var global

var level = 1
var damage = [0, 20, 30, 40]


func _ready():
	pass


func _on_body_entered(body):
	print("LandMine: _on_body_enter()")
	if body.is_in_group("enemy"):
		var scene = preload("res://explosion-big.tscn")
		var explosion = scene.instance()
		explosion.set_position(get_global_position())
		get_node("/root").add_child(explosion)
		body.hit(damage[level])
		queue_free()

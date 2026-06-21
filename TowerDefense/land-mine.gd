
extends Node2D

var global

var level = 1
var damage = [0, 20, 30, 40]


func _ready():
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("LandMine: _on_body_enter(): %s" % [area.get_parent().name])
	var body = area.get_parent()
	if body.is_in_group("enemy"):
		var scene = preload("res://explosion-big.tscn")
		var explosion = scene.instantiate()
		explosion.set_position(get_global_position())
		get_node("/root").add_child(explosion)
		body.hit(damage[level])
		queue_free()

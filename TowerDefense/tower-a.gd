
extends RigidBody2D

var time = 0.0
var level = 1
var level_max = 3
var fire_delta = 1.0/5.0
var fire_next = 0.0
var enemy_at_range = 0
var enemy_direction = Vector2(0,-1)

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	time += delta
	if enemy_at_range > 0:
		fire()

func upgrade():
	if level < level_max:
		level += 1
		var sprite = get_node("Sprite")
		sprite.set_frame(level-1)
		print(get_name(), " upgraded to level ", level)

func fire():
	if time > fire_next:
		var scene = preload("res://bullet.scn")
		var bullet = scene.instance()
		#bullet.set_pos(get_pos())
		var target_enemy = null
		for b in get_colliding_bodies():
			if target_enemy == null or \
				b.get_global_pos().x > target_enemy.get_global_pos().x:
				target_enemy = b
		bullet.direction = (target_enemy.get_global_pos() - get_global_pos()).normalized()
		add_child(bullet)
		fire_next = time + fire_delta

func _on_button_pressed():
	upgrade()

func _on_body_enter(body):
	print("Body enter " + str(body))
	if body.is_in_group("enemy"):
		enemy_at_range += 1

func _on_body_exit(body):
	print("Body exit " + str(body))
	if body.is_in_group("enemy"):
		enemy_at_range -= 1

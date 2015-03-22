
extends RigidBody2D

var global

var time = 0.0
var level = 1
var level_max = 3
var fire_delta = 1.0/1.0
var fire_next = 0.0
var fire_range = 200
var enemy_at_range = 0
var enemy_direction = Vector2(0,-1)

var upgrade_cost = [0, 5, 10, 15]
var sell_price = [0, 2, 5, 8]

const ammunition = "res://guided-missile.xscn"


func _ready():
	global = get_node("/root/global")
	set_fixed_process(true)
	if global.debug:
		show_range()


func _fixed_process(delta):
	time += delta
	#if enemy_at_range > 0:
	fire()


func show_range():
	get_node("FireRange").set_scale(Vector2(fire_range/100.0, fire_range/100.0))
	get_node("FireRange").show()


func hide_range():
	get_node("FireRange").hide()


func get_sell_price():
	return sell_price[level]


func sell():
	global.increase_cash(sell_price[level])
	queue_free()


func get_upgrade_cost():
	return upgrade_cost[level]


func upgrade():
	if level < level_max and global.cash >= upgrade_cost[level]:
		global.decrease_cash(upgrade_cost[level])
		level += 1
		var sprite = get_node("Sprite")
		var hframes = sprite.get_hframes()
		sprite.set_frame(hframes * (level-1 ))
		print(get_name(), " upgraded to level ", level)


func rotate_turret(direction):
	var rad_angle = atan2(direction.x, direction.y) - atan2(0, -1)
	var angle = (360 - int(rad_angle * global.DEG_PER_RAD)) % 360
	var sprite = get_node("Sprite")
	var hframes = sprite.get_hframes()
	var frame = int(round(angle / (360.0/hframes))) % hframes
	sprite.set_frame(hframes * (level-1 ) + frame)


func choose_target():
	var target = null
	var pos = get_global_pos()
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if pos.distance_to(enemy.get_global_pos()) <= fire_range:
			if target == null or enemy.get_global_pos().x > target.get_global_pos().x:
				target = enemy
	return target


func fire():
	if time > fire_next:
		var target_enemy = choose_target()
		if target_enemy == null:
			return
		var scene = load(ammunition)
		var missile = scene.instance()
		missile.target_path = target_enemy.get_path()
		print("TARGET: " + target_enemy.get_path())
		missile.level = level
		var direction = (target_enemy.get_global_pos() - get_global_pos()).normalized()
		rotate_turret(direction)
		missile.set_pos(direction * 24) # Move missile at launcher boundary
		add_child(missile)
		move_child(missile, 0)
		fire_next = time + fire_delta


func _on_body_enter(body):
	#print("Body enter " + str(body))
	if body.is_in_group("enemy"):
		enemy_at_range += 1


func _on_body_exit(body):
	#print("Body exit " + str(body))
	if body.is_in_group("enemy"):
		enemy_at_range -= 1

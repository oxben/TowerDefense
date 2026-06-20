
extends Node2D

var global

# Speed of the unit in pixel/sec
var speed = 40

# Number of hit points
var health = 50.0

# Number of Armor points
var armor = 2

# Number of damage points done by the unit when it reaches its goal
var damage = 1

# Number of coins gained when the unit is destroyed
var reward = 5

# Number of seconds since the unit died
var dead_since = 0


func _ready():
	add_to_group("enemy")
	global = get_node("/root/global")
	get_node("HealthLabel").set_text(str(health))
	var progress = get_node("HealthProgress")
	progress.hide()
	progress.set_max(health)
	progress.set_value(health)
	set_physics_process(true)


func _physics_process(delta):
	if health <= 0:
		if dead_since > global.DEAD_CLEAN_INTVAL:
			queue_free()
		else:
			dead_since += delta
		return

	var path_follow := get_parent() as PathFollow2D
	if path_follow.progress_ratio < 1.0:
		#path_follow.set_h_offset(path_follow.get_h_offset() + (speed * delta) )
		path_follow.progress += speed * delta
	else:
		print(get_name() + " reached the fortress")
		global.hit_fortress(damage)
		queue_free()


func hit(damage_count, continuous=false):
	if health <= 0:
		# If unit is already dead (case of wrecks)
		return
	if not continuous:
		health -= max(0, damage_count - armor)
	else:
		health -= damage_count
	get_node("HealthLabel").set_text(str(health))
	var progress = get_node("HealthProgress")
	if not progress.is_visible():
		progress.show()
	progress.set_value(health)
	# Death
	if health <= 0:
		print(get_name(), " destroyed!")
		get_node("HealthLabel").hide()
		progress.hide()
		# Add explosion
		var scene = preload("res://explosion-big.tscn")
		var explosion = scene.instantiate()
		explosion.set_position(get_global_position())
		get_node("/root").add_child(explosion)
		# Add wreckage
		scene = preload("res://wreck-a.tscn")
		var wreck = scene.instantiate()
		wreck.set_position(get_global_position())
		wreck.set_frame(randi() % wreck.get_hframes())
		global.current_level.level.get_node("DetailsTileMap").add_child(wreck)

		var texture = load("res://assets/images/tank-a-dead.png")
		var sprite = get_node("Sprite2D")
		sprite.set_texture(texture)
		sprite.set_hframes(1)
		sprite.set_frame(0)
		remove_from_group("enemy")

		# Add label for reward
		scene = preload("res://ascending-label.tscn")
		var label = scene.instantiate()
		label.set_text("+ $" + str(reward))
		add_child(label)
		global.increase_cash(reward)

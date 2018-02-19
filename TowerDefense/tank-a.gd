
extends RigidBody2D

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

	if get_parent().get_unit_offset() < 1.0:
		get_parent().set_offset(get_parent().get_offset() + (speed * delta) )
	else:
		print(get_name() + " reached the fortress")
		global.hit_fortress(damage)
		queue_free()


func hit(damage, continuous=false):
	if health <= 0:
		# If unit is already dead (case of wrecks)
		return
	if not continuous:
		health -= max(0, damage - armor)
	else:
		health -= damage
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
		var explosion = scene.instance()
		explosion.set_position(get_global_position())
		get_node("/root").add_child(explosion)
		# Add wreckage
		scene = preload("res://wreck-a.tscn")
		var wreck = scene.instance()
		wreck.set_position(get_global_position())
		wreck.set_frame(randi() % wreck.get_hframes())
		var root = get_node("/root")
		global.current_level.level.get_node("DetailsTileMap").add_child(wreck)

		var texture = ImageTexture.new()
		texture.load("res://assets/images/tank-a-dead.png")
		var sprite = get_node("Sprite")
		sprite.set_texture(texture)
		sprite.set_hframes(1)
		sprite.set_frame(0)
		remove_from_group("enemy")

		# Add label for reward
		scene = preload("res://ascending-label.tscn")
		var label = scene.instance()
		label.set_text("+ $" + str(reward))
		add_child(label)
		global.increase_cash(reward)


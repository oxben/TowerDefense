
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
	set_fixed_process(true)


func _fixed_process(delta):
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
		# Add wreckage
		var scene = preload("res://wreck-a.xscn")
		var wreck = scene.instance()
		wreck.set_pos(get_global_pos())
		wreck.set_frame(randi() % wreck.get_hframes())
		var root = get_node("/root")
		global.current_level.add_child(wreck)
		global.current_level.move_child(wreck, 2)
		
		var texture = ImageTexture.new()
		texture.load("res://assets/images/tank-a-dead.png")
		var sprite = get_node("Sprite")
		sprite.set_texture(texture)
		sprite.set_hframes(1)
		sprite.set_frame(0)
		remove_from_group("enemy")
		
		# Add label for reward
		scene = preload("res://ascending-label.xscn")
		var label = scene.instance()
		label.set_text("+ $" + str(reward))
		add_child(label)
		global.cash += reward


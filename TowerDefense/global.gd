extends Node

# Degrees per radian
const DEG_PER_RAD = 57.295779513

# Interval of time before a dead unit is removed from the screen
const DEAD_CLEAN_INTVAL = 3.0

const COLOR_GOLD = "#ffda80"
const COLOR_RED  = "#ff4444"

# Game
var current_level = null

# Player
var cash = 10
var health = 5

var debug = false
var init_tower_cost = 5 # Initial tower cost

var enemy_scenes = {}


func _ready():
	var root = get_tree().get_root()
	current_level = root.get_child( root.get_child_count() - 1)
	# Preload enemies' scenes
	enemy_scenes["tank-a"] = preload("res://tank-a.tscn")


func hit_fortress(damage):
	if health > 0:
		decrease_health(damage)
		if health <= 0:
			current_level.get_node("AnimPlayer").play("GameOver")


func goto_scene(scene, level_name=""):
	current_level.queue_free()
	if scene.basename() != "splash.tscn":
		# Reset player attributes
		cash = 10
		health = 5
	var scn = ResourceLoader.load(scene)
	current_level = scn.instance()
	if level_name != "":
		current_level.level_name = level_name
	get_tree().get_root().add_child(current_level)


func increase_cash(sum):
	cash += sum
	# Update listeners
	get_tree().call_group(0,"CashListeners","on_cash_update")


func decrease_cash(sum):
	cash -= sum
	# Update listeners
	get_tree().call_group(0,"CashListeners","on_cash_update")


func increase_health(point):
	health += point
	# Update listeners
	get_tree().call_group(0,"HealthListeners","on_health_update")


func decrease_health(point):
	health -= point
	# Update listeners
	get_tree().call_group(0,"HealthListeners","on_health_update")


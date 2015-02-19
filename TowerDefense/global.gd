extends Node

# Degrees per radian
const DEG_PER_RAD = 57.295779513

# Interval of time before a dead unit is removed from the screen
const DEAD_CLEAN_INTVAL = 3.0

const COLOR_GOLD = "#ffda80"
const COLOR_RED  = "#ff4444"

var current_level = null
var cash = 10
var health = 5
var debug = false
var init_tower_cost = 5 # Initial tower cost


func _ready():
	var root = get_tree().get_root()
	current_level = root.get_child( root.get_child_count() - 1)


func hit_fortress(damage):
	if health > 0:
		health -= damage
		if health <= 0:
			current_level.get_node("AnimPlayer").play("GameOver")


func goto_scene(scene):
	current_level.queue_free()
	if scene.basename() != "splash.scn":
		# Reset player attributes
		cash = 10
		health = 5
	var scn = ResourceLoader.load(scene)
	current_level = scn.instance()
	get_tree().get_root().add_child(current_level)


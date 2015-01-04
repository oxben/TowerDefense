extends Node

# Interval of time before a dead unit is removed from the screen
const DEAD_CLEAN_INTVAL = 3.0

var current_level = null
var cash = 10
var health = 4

func _ready():
        var root = get_tree().get_root()
        current_level = root.get_child( root.get_child_count() - 1)


extends Node

var current_level = null

func _ready():
        var root = get_tree().get_root()
        current_level = root.get_child( root.get_child_count() - 1)


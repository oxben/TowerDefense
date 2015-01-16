
extends TextureButton

var idx

func _ready():
	idx = get_name().split("-")[1]

func _on_TowerBase_pressed():
	var level = get_node("/root/global").current_level
	var pos = get_pos()
	pos.x += 16
	pos.y += 8
	level.add_tower(pos, idx)

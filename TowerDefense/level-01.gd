
extends TextureFrame

var time
var enemy_spawn
var max_enemy_num = 5
var enemy_num = 0

func _ready():
	time = 0.0
	enemy_spawn = 2.0
	set_process(true)

func _process(delta):
	time += delta
	if time > enemy_spawn and enemy_num < max_enemy_num:
		enemy_spawn = time + 2.0
		var scene = preload("res://tank-a.scn")
		var enemy = scene.instance()
		var path = PathFollow2D.new()
		path.set_loop(false)
		get_node("/root/Level-1/WavePath-1").add_child(path)
		path.add_child(enemy)
		enemy_num += 1

func add_tower(pos, id):
	print("Add tower: x=", pos.x, " y=", pos.y)
	var scene = preload("res://tower-a.scn")
	var tower = scene.instance()
	tower.set_name("Tower-" + id)
	tower.set_pos(pos)
	add_child(tower)
	

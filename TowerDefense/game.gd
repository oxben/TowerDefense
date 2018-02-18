
extends TextureRect

var global

var time
var spawn_time
var max_enemy_num = 8
var enemy_num = 0

var start_countdown = 10.0
var victory = false

# Current level scene
var level_name = ""
var level = null
# Enemy waves
var waves = []
# Current enemy wave
var wave_idx = 0
var wave = {}

const WAIT     = 0
const ACTIVE   = 1
const FINISHED = 2

const ARROW_CURSOR = "res://assets/images/cursor-arrow-32x32.png"
var arrow_cursor = null

const LAND_MINE_CURSOR = "res://assets/images/land-mine-32x32.png"
var land_mine_cursor = null

var land_mine_install_mode = false


func _ready():
	print("Starting new level: " + level_name)
	time = 0.0
	victory = false
	global = get_node("/root/global")
	# Add level scene to current scene
	if level_name == "":
		level_name = "level-01"
	var scn = ResourceLoader.load("res://" + level_name + ".tscn")
	level = scn.instance()
	add_child(level)
	move_child(level, 0)
	# Load level waves from .json file
	var file = File.new()
	file.open("res://" + level_name + "-waves.json", File.READ) # eg. level-01-waves.json
	var txt = file.get_as_text()
	var d = parse_json(txt)
	print(d)
	if not d:
		print("ERROR: Failed to parse wave file")
	waves = d["waves"]
	# Initialize first wave
	init_wave(0)
	get_node("WaveSprite/WaveLabel").set_text(str(wave_idx+1) + "/" + str(waves.size()))
	# Enable process functions
	set_process(true)
	set_process_input(true)
	# Create mouse cursors
	arrow_cursor = load(ARROW_CURSOR)
	land_mine_cursor = load(LAND_MINE_CURSOR)
	Input.set_custom_mouse_cursor(arrow_cursor)


func init_wave(idx):
	# Initialize current wave
	print(waves)
	wave_idx = idx
	wave = waves[idx]
	wave["count"] = wave["enemies"].size()
	wave["state"] = WAIT
	wave["idx"] = 0
	start_countdown = wave["intval"]
	get_node("SkullButton/Label").set_text(str(ceil(start_countdown)) + "s")
	get_node("SkullButton").show()


func start_wave():
	# Start current wave: game will start spawning enemies from this wave
	wave["state"] = ACTIVE
	get_node("WaveSprite/WaveLabel").set_text(str(wave_idx+1) + "/" + str(waves.size()))
	spawn_time = time + wave["enemies"][wave["idx"]]["intval"]
	get_node("SkullButton").hide()


func _process(delta):
	time += delta
	if wave["state"] == ACTIVE:
		if wave["idx"] < wave["count"]:
			if time > spawn_time:
				# Spawn next enemy in waves
				# (idx is already incremented)
				var enemy = wave["enemies"][wave["idx"]]
				var scene = global.enemy_scenes[enemy["type"]]
				var enemy_inst = scene.instance()
				var path = PathFollow2D.new()
				path.set_loop(false)
				level.get_node(enemy["path"]).add_child(path)
				path.add_child(enemy_inst)

				if (wave["idx"]+1) < wave["count"]:
					# Next enemy in wave
					wave["idx"] += 1
					spawn_time = time + wave["enemies"][wave["idx"]]["intval"]
				else:
					wave["state"] = FINISHED
					if (wave_idx+1) < waves.size():
						# Next waves
						init_wave(wave_idx+1)
			else:
				pass
		else:
			pass
	elif wave["state"] == WAIT:
		start_countdown -= delta
		if start_countdown > 0:
			get_node("SkullButton/Label").set_text(str(ceil(start_countdown)) + "s")
		else:
			start_wave()

	get_node("CashSprite/CashLabel").set_text(str(global.cash))
	get_node("HealthSprite/HealthLabel").set_text(str(global.health))

	if global.health <= 0:
		print("You loose!")
		set_process(false)
	elif (not victory and
		#waves[waves.size()-1]["state"] == FINISHED and
		wave["state"] == FINISHED and
		get_tree().get_nodes_in_group("enemy").size() == 0):
		print("Victory!")
		victory = true
		get_node("AnimPlayer").play("Victory")
		set_process(false)


func _input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("pause_game"):
			get_tree().set_pause(true)
			get_node("PausePopupPanel").show()
			return
		if Input.is_action_pressed("quit_game"):
			get_tree().quit()
			return
		if Input.is_action_pressed("cheat_cash"):
			global.increase_cash(100)
			return
	elif event is InputEventMouseButton:
		if event.get_button_index() == BUTTON_LEFT and not event.is_pressed():
			# Letf mouse button up
			if land_mine_install_mode:
				plant_mine(event.get_global_position())
				print("plant mine")
				land_mine_install_mode = false


func _on_resume_button_pressed():
	get_node("PausePopupPanel").hide()
	get_tree().set_pause(false)


func _on_SkullButton_pressed():
	start_wave()

func gameover_pause():
	get_tree().set_pause(true)


func _on_RestartButton_pressed():
	print("Load Spash")
	get_tree().set_pause(false)
	get_node("/root/global").goto_scene("res://splash.tscn")


func _on_ContinueButton_pressed():
	print("Load next level")
	get_tree().set_pause(false)
	# Hack
	var next_level = get_node("/root/global").get_next_level()
	get_node("/root/global").goto_scene("res://game.tscn", next_level)


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_BuyLandMineButton_button_up():
	print("Buy mine")
	if global.init_land_mine_cost <= global.cash:
		print("I'm rich enough")
		global.decrease_cash(global.init_land_mine_cost)
		land_mine_install_mode = true
		Input.set_custom_mouse_cursor(land_mine_cursor)


func plant_mine(pos):
	print("plant land mine", pos)
	var scene = preload("res://land-mine.tscn")
	var mine = scene.instance()
	mine.set_position(pos)
	global.current_level.level.add_child(mine)
	global.current_level.level.move_child(mine, 3)
	Input.set_custom_mouse_cursor(arrow_cursor)



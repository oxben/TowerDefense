
extends TextureFrame

var global

var time
var enemy_spawn
var max_enemy_num = 8
var enemy_num = 0

var start_countdown = 10.0
var victory = false

# Enemy waves
var waves = []
# Current enemy wave
var wave_idx = 0
var wave = {}

const WAIT     = 0
const ACTIVE   = 1
const FINISHED = 2

func init_wave(idx):
	print(waves)
	wave_idx = idx
	wave = waves[idx]
	wave["count"] = wave["enemies"].size()
	wave["state"] = WAIT
	wave["idx"] = 0
	start_countdown = time + wave["intval"]
	get_node("SkullButton/Label").set_text(str(ceil(start_countdown)) + "s")
	get_node("SkullButton").show()


func _ready():
	time = 0.0
	enemy_spawn = 2.0
	victory = false
	global = get_node("/root/global")
	# Load waves
	var file = File.new()
	file.open("res://level-01-waves.json", File.READ)
	var txt = file.get_as_text()
	var d = {}
	var rc = d.parse_json(txt)
	if rc != OK:
		print("ERROR: Failed to parse wave file")
	waves = d["waves"]
	init_wave(0)
	get_node("WaveSprite/WaveLabel").set_text(str(wave_idx+1) + "/" + str(waves.size()))
	# Enable process functions
	set_process(true)
	set_process_input(true)


func _process(delta):
	time += delta
	if wave["state"] == ACTIVE:
		if wave["idx"] < wave["count"]:
			if time > enemy_spawn:
				# Spawn next enemy in waves
				# (idx is already incremented)
				var enemy = wave["enemies"][wave["idx"]]
				var scene = global.enemy_scenes[enemy["type"]]
				var enemy = scene.instance()
				var path = PathFollow2D.new()
				path.set_loop(false)
				get_node("/root/Level-1/" + wave["path"]).add_child(path)
				path.add_child(enemy)

				if (wave["idx"]+1) < wave["count"]:
					# Next enemy in wave
					wave["idx"] += 1
					enemy_spawn = time + wave["enemies"][wave["idx"]]["intval"]
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
			wave["state"] = ACTIVE
			get_node("WaveSprite/WaveLabel").set_text(str(wave_idx+1) + "/" + str(waves.size()))
			get_node("SkullButton").hide()
	
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
	if event.type == InputEvent.KEY:
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


func _on_resume_button_pressed():
	get_node("PausePopupPanel").hide()
	get_tree().set_pause(false)


func _on_SkullButton_pressed():
	wave["state"] = ACTIVE
	get_node("WaveSprite/WaveLabel").set_text(str(wave_idx+1) + "/" + str(waves.size()))
	get_node("SkullButton").hide()


func gameover_pause():
	get_tree().set_pause(true)


func _on_RestartButton_pressed():
	print("Load Spash")
	get_tree().set_pause(false)
	get_node("/root/global").goto_scene("res://splash.xscn")


func _on_QuitButton_pressed():
	get_tree().quit()


extends TextureFrame

var global

var time
var enemy_spawn
var max_enemy_num = 8
var enemy_num = 0

var start_wave = false
var start_countdown = 10.0

func _ready():
	time = 0.0
	enemy_spawn = 2.0
	global = get_node("/root/global")
	set_process(true)
	set_process_input(true)


func _process(delta):
	time += delta
	if start_wave == true and time > enemy_spawn and enemy_num < max_enemy_num:
		enemy_spawn = time + 3.0
		var scene = preload("res://tank-a.scn")
		var enemy = scene.instance()
		var path = PathFollow2D.new()
		path.set_loop(false)
		get_node("/root/Level-1/WavePath-1").add_child(path)
		path.add_child(enemy)
		enemy_num += 1
	else:
		start_countdown -= delta
		if start_countdown > 0:
			get_node("SkullButton/Label").set_text(str(ceil(start_countdown)) + "s")
		else:
			start_wave = true
			get_node("SkullButton").hide()
	get_node("CashSprite/CashLabel").set_text(str(global.cash))
	get_node("HealthSprite/HealthLabel").set_text(str(global.health))
		
	if global.health <= 0:
		print("You loose!")


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
			global.cash += 100
			return


func _on_resume_button_pressed():
	get_node("PausePopupPanel").hide()
	get_tree().set_pause(false)


func _on_SkullButton_pressed():
	start_wave = true
	get_node("SkullButton").hide()


extends Control


func _ready():
	print("Splash ready!")


func _on_Start_pressed():
	print("Load level")
	get_node("/root/global").goto_scene("res://game.tscn", "level-01")


func _on_Quit_pressed():
	get_tree().quit()


extends Control


func _ready():
	print("Splash ready!")


func _on_Start_pressed():
	print("Load level 1")
	get_node("/root/global").goto_scene("res://level-01.xscn")


func _on_Quit_pressed():
	get_tree().quit()

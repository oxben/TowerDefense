
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initalization here
	pass


func _on_Start_pressed():
	print("Load level 1")
	get_node("/root/global").goto_scene("res://level-01.scn")


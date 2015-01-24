
extends TextureButton

var global

var idx
var tower = null


func _ready():
	idx = get_name().split("-")[1]
	global = get_node("/root/global")
	hide_tower_menu()
	hide_upgrade_menu()


func _on_BuyTowerAButton_pressed():
	add_tower(preload("res://tower-a.scn"))
	hide_tower_menu()
	set_pressed(false)


func _on_BuyTowerDButton_pressed():
	add_tower(preload("res://tower-d.scn"))
	hide_tower_menu()
	set_pressed(false)


func _on_TowerBase_toggled( pressed ):
	print("pressed=", str(pressed))
	if pressed:
		if tower == null:
			show_tower_menu()
		else:
			show_upgrade_menu()
	else:
		hide_tower_menu()
		hide_upgrade_menu()


func show_tower_menu():
	get_node("BuyTowerAButton/Label").set_text("$ 5")
	get_node("BuyTowerDButton/Label").set_text("$ 5")
	get_node("BuyTowerAButton").show()
	get_node("BuyTowerDButton").show()


func hide_tower_menu():
	get_node("BuyTowerAButton").hide()
	get_node("BuyTowerDButton").hide()


func show_upgrade_menu():
	var sell_price = tower.get_sell_price()
	get_node("SellTowerButton/Label").set_text("$ " + str(sell_price))
	var cost = tower.get_upgrade_cost()
	var label = get_node("UpgradeTowerButton/Label")
	label.set_text("$ " + str(cost))
	if cost > global.cash:
		label.set("custom_colors/font_color", Color(global.COLOR_RED))
	else:
		label.set("custom_colors/font_color", Color(global.COLOR_GOLD))
	get_node("SellTowerButton").show()
	get_node("UpgradeTowerButton").show()


func hide_upgrade_menu():
	get_node("SellTowerButton").hide()
	get_node("UpgradeTowerButton").hide()


func add_tower(tower_scene):
	print("Add tower: x=", get_pos().x, " y=", get_pos().y)
	tower = tower_scene.instance()
	tower.set_name("Tower-" + idx)
	tower.set_pos(Vector2(32,16))
	add_child(tower)


func _on_SellTowerButton_pressed():
	tower.sell()
	tower = null
	hide_upgrade_menu()
	set_pressed(false)


func _on_UpgradeTowerButton_pressed():
	tower.upgrade()
	hide_upgrade_menu()
	set_pressed(false)

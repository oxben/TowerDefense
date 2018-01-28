
extends TextureButton

var global

var idx
var tower = null


func _ready():
	idx = get_name().split("-")[1]
	global = get_node("/root/global")
	add_to_group("CashListeners")
	hide_tower_menu()
	hide_upgrade_menu()


func on_cash_update():
	set_tower_cost_color()
	set_upgrade_cost_color()


func _on_BuyTowerAButton_pressed():
	if global.init_tower_cost <= global.cash:
		global.decrease_cash(global.init_tower_cost)
		add_tower(preload("res://tower-a.tscn"))
		hide_tower_menu()
		set_pressed(false)


func _on_BuyTowerDButton_pressed():
	if global.init_tower_cost <= global.cash:
		global.decrease_cash(global.init_tower_cost)
		add_tower(preload("res://tower-d.tscn"))
		hide_tower_menu()
		set_pressed(false)


func _on_BuyTowerEButton_pressed():
	if global.init_tower_cost <= global.cash:
		global.decrease_cash(global.init_tower_cost)
		add_tower(preload("res://tower-e.tscn"))
		hide_tower_menu()
		set_pressed(false)


func _on_TowerBase_toggled( pressed ):
	print("pressed=", str(pressed))
	if pressed:
		# Close other opened menu
		get_tree().call_group(0,"OpenedBases","close_tower_menu")
		# Display menu
		if tower == null:
			show_tower_menu()
		else:
			show_upgrade_menu()
		add_to_group("OpenedBases")
	else:
		remove_from_group("OpenedBases")
		hide_tower_menu()
		hide_upgrade_menu()


func close_tower_menu():
		# Called when another tower base is pressed (radio button behavior)
		# remove_from_group("OpenedBases") : done by called routines below
		hide_tower_menu()
		hide_upgrade_menu()
		set_pressed(false)


func set_tower_cost_color():
	var ta_label = get_node("BuyTowerAButton/Label")
	var td_label = get_node("BuyTowerDButton/Label")
	var te_label = get_node("BuyTowerEButton/Label")
	if global.init_tower_cost > global.cash:
		ta_label.set("custom_colors/font_color", Color(global.COLOR_RED))
		td_label.set("custom_colors/font_color", Color(global.COLOR_RED))
		te_label.set("custom_colors/font_color", Color(global.COLOR_RED))
	else:
		ta_label.set("custom_colors/font_color", Color(global.COLOR_GOLD))
		td_label.set("custom_colors/font_color", Color(global.COLOR_GOLD))
		te_label.set("custom_colors/font_color", Color(global.COLOR_GOLD))


func show_tower_menu():
	var ta_label = get_node("BuyTowerAButton/Label")
	var td_label = get_node("BuyTowerDButton/Label")
	var te_label = get_node("BuyTowerEButton/Label")
	ta_label.set_text("$ " + str(global.init_tower_cost))
	td_label.set_text("$ " + str(global.init_tower_cost))
	te_label.set_text("$ " + str(global.init_tower_cost))
	set_tower_cost_color()
	get_node("BuyTowerAButton").show()
	get_node("BuyTowerDButton").show()
	get_node("BuyTowerEButton").show()


func hide_tower_menu():
	remove_from_group("OpenedBases")
	get_node("BuyTowerAButton").hide()
	get_node("BuyTowerDButton").hide()
	get_node("BuyTowerEButton").hide()


func set_upgrade_cost_color():
	if tower == null:
		return
	var cost = tower.get_upgrade_cost()
	var label = get_node("UpgradeTowerButton/Label")
	if cost > global.cash:
		label.set("custom_colors/font_color", Color(global.COLOR_RED))
	else:
		label.set("custom_colors/font_color", Color(global.COLOR_GOLD))


func show_upgrade_menu():
	var sell_price = tower.get_sell_price()
	get_node("SellTowerButton/Label").set_text("$ " + str(sell_price))
	var cost = tower.get_upgrade_cost()
	var label = get_node("UpgradeTowerButton/Label")
	label.set_text("$ " + str(cost))
	set_upgrade_cost_color()
	get_node("SellTowerButton").show()
	get_node("UpgradeTowerButton").show()
	get_node("FireRange").set_scale(Vector2(tower.fire_range/100.0, tower.fire_range/100.0))
	get_node("FireRange").show()


func hide_upgrade_menu():
	remove_from_group("OpenedBases")
	get_node("SellTowerButton").hide()
	get_node("UpgradeTowerButton").hide()
	get_node("FireRange").hide()


func add_tower(tower_scene):
	print("Add tower: x=", get_position().x, " y=", get_position().y)
	tower = tower_scene.instance()
	tower.set_name("Tower-" + idx)
	tower.set_position(Vector2(32,16))
	add_child(tower)


func _on_SellTowerButton_pressed():
	tower.sell()
	tower = null
	hide_upgrade_menu()
	set_pressed(false)


func _on_UpgradeTowerButton_pressed():
	tower.upgrade()
	remove_from_group("OpenedBases")
	hide_upgrade_menu()
	set_pressed(false)

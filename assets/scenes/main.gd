extends Control

@onready var dough_rect = $PizzaBoard/Dough
@onready var pizza_board = $PizzaBoard
@onready var oven_bg = $OvenBackground
@onready var sauce_menu = $UI/SauceMenu

@onready var cheese_scroll = $UI/ToppingsCategoryMenu/CheeseScroll
@onready var cheese_menu = $UI/ToppingsCategoryMenu/CheeseScroll/HBoxContainer
@onready var meat_scroll = $UI/ToppingsCategoryMenu/MeatScroll
@onready var meat_menu = $UI/ToppingsCategoryMenu/MeatScroll/HBoxContainer
@onready var seafood_scroll = $UI/ToppingsCategoryMenu/SeafoodScroll
@onready var seafood_menu = $UI/ToppingsCategoryMenu/SeafoodScroll/HBoxContainer
@onready var veg_scroll = $UI/ToppingsCategoryMenu/VegScroll
@onready var veg_menu = $UI/ToppingsCategoryMenu/VegScroll/HBoxContainer

@onready var category_icons_container = $UI/HBoxContainer
@onready var btn_category_cheese = $UI/HBoxContainer/BtnCategoryCheese
@onready var btn_category_meat = $UI/HBoxContainer/BtnCategoryMeat
@onready var btn_category_seafood = $UI/HBoxContainer/BtnCategorySeafood
@onready var btn_category_veg = $UI/HBoxContainer/BtnCategoryVeg

@onready var btn_next = $UI/BtnNext
@onready var btn_bake = $UI/BtnBake
@onready var btn_undo = $UI/BtnUndo
@onready var btn_reset = $UI/BtnReset
@onready var sfx_player = $SFXPlayer
@onready var bgm_player = get_node_or_null("BGMPlayer") 

var placed_toppings: Array = []
var current_sauce_node: Sprite2D = null
var is_baked: bool = false
var original_bgm_volume: float = 0.0

var dragging_item_data = null
var drag_preview: Sprite2D = null

var sauces_data = [
	{"raw": "res://assets/images/sauce_tomato_raw.png", "baked": "res://assets/images/sauce_tomato_baked.png"},
	{"raw": "res://assets/images/sauce_bbq_raw.png", "baked": "res://assets/images/sauce_bbq_baked.png"},
	{"raw": "res://assets/images/sauce_pesto_raw.png", "baked": "res://assets/images/sauce_pesto_baked.png"},
	{"raw": "res://assets/images/sauce_white_raw.png", "baked": "res://assets/images/sauce_white_baked.png"},
	{"raw": "res://assets/images/sauce_special_raw.png", "baked": "res://assets/images/sauce_special_baked.png"},
	{"raw": "res://assets/images/sauce_special_white_raw.png", "baked": "res://assets/images/sauce_special_white_baked.png"}
]

var cheeses_data = [
	{"raw": "res://assets/images/cheese_blue_raw.png", "baked": "res://assets/images/cheese_blue_baked.png", "scale": 0.28},
	{"raw": "res://assets/images/cheese_cheddar_raw.png", "baked": "res://assets/images/cheese_cheddar_baked.png", "scale": 0.385},
	{"raw": "res://assets/images/cheese_feta_raw.png", "baked": "res://assets/images/cheese_feta_baked.png", "scale": 0.32},
	{"raw": "res://assets/images/cheese_gouda_raw.png", "baked": "res://assets/images/cheese_gouda_baked.png", "scale": 0.28},
	{"raw": "res://assets/images/cheese_mozzarella_raw.png", "baked": "res://assets/images/cheese_mozzarella_baked.png", "scale": 0.315},
	{"raw": "res://assets/images/cheese_pesto_raw.png", "baked": "res://assets/images/cheese_pesto_baked.png", "scale": 0.315}
]

var meats_data = [
	{"raw": "res://assets/images/chicken_breast_raw.png", "baked": "res://assets/images/chicken_breast_baked.png", "scale": 0.439875},
	{"raw": "res://assets/images/spicy_chicken_breast_raw.png", "baked": "res://assets/images/spicy_chicken_breast_baked.png", "scale": 0.439875},
	{"raw": "res://assets/images/meat_bacon_raw.png", "baked": "res://assets/images/meat_bacon_baked.png", "scale": 0.42},
	{"raw": "res://assets/images/meat_ham_raw.png", "baked": "res://assets/images/meat_ham_baked.png", "scale": 0.42},
	{"raw": "res://assets/images/meat_minced_raw.png", "baked": "res://assets/images/meat_minced_baked.png", "scale": 0.28},
	{"raw": "res://assets/images/meat_pepperoni_raw.png", "baked": "res://assets/images/meat_pepperoni_baked.png", "scale": 0.266},
	{"raw": "res://assets/images/meat_ribs_raw.png", "baked": "res://assets/images/meat_ribs_baked.png", "scale": 0.6336},
	{"raw": "res://assets/images/meat_roast_beef_raw.png", "baked": "res://assets/images/meat_roast_beef_baked.png", "scale": 0.54},
	{"raw": "res://assets/images/meat_salami_raw.png", "baked": "res://assets/images/meat_salami_baked.png", "scale": 0.266},
	{"raw": "res://assets/images/meat_sausage_raw.png", "baked": "res://assets/images/meat_sausage_baked.png", "scale": 0.252},
	{"raw": "res://assets/images/meat_steak_raw.png", "baked": "res://assets/images/meat_steak_baked.png", "scale": 0.60}
]

var seafood_data = [
	{"raw": "res://assets/images/seafood_crab_raw.png", "baked": "res://assets/images/seafood_crab_baked.png", "scale": 0.504},
	{"raw": "res://assets/images/seafood_octopus_raw.png", "baked": "res://assets/images/seafood_octopus_baked.png", "scale": 0.336},
	{"raw": "res://assets/images/seafood_salmon_raw.png", "baked": "res://assets/images/seafood_salmon_baked.png", "scale": 0.495},
	{"raw": "res://assets/images/seafood_sardine_raw.png", "baked": "res://assets/images/seafood_sardine_baked.png", "scale": 0.42},
	{"raw": "res://assets/images/seafood_scallop_raw.png", "baked": "res://assets/images/seafood_scallop_baked.png", "scale": 0.238},
	{"raw": "res://assets/images/seafood_shrimp_raw.png", "baked": "res://assets/images/seafood_shrimp_baked.png", "scale": 0.2754},
	{"raw": "res://assets/images/seafood_tuna_raw.png", "baked": "res://assets/images/seafood_tuna_baked.png", "scale": 0.38}
]

var veg_data = [
	{"raw": "res://assets/images/other_pineapple_raw.png", "baked": "res://assets/images/other_pineapple_baked.png", "scale": 0.396},
	{"raw": "res://assets/images/veg_Asparagus_raw.png", "baked": "res://assets/images/veg_Asparagus_baked.png", "scale": 0.54},
	{"raw": "res://assets/images/veg_bellpepper_green_raw.png", "baked": "res://assets/images/veg_bellpepper_green_baked.png", "scale": 0.3168},
	{"raw": "res://assets/images/veg_bellpepper_red_raw.png", "baked": "res://assets/images/veg_bellpepper_red_baked.png", "scale": 0.3168},
	{"raw": "res://assets/images/veg_bellpepper_yellow_raw.png", "baked": "res://assets/images/veg_bellpepper_yellow_baked.png", "scale": 0.3168},
	{"raw": "res://assets/images/veg_broccoli_raw.png", "baked": "res://assets/images/veg_broccoli_baked.png", "scale": 0.38},
	{"raw": "res://assets/images/veg_carolina_pepper_raw.png", "baked": "res://assets/images/veg_carolina_pepper_baked.png", "scale": 0.32},
	{"raw": "res://assets/images/veg_cherry_tomato_raw.png", "baked": "res://assets/images/veg_cherry_tomato_baked.png", "scale": 0.30},
	{"raw": "res://assets/images/veg_corn_raw.png", "baked": "res://assets/images/veg_corn_baked.png", "scale": 0.2704},
	{"raw": "res://assets/images/veg_dill_raw.png", "baked": "res://assets/images/veg_dill_baked.png", "scale": 0.28},
	{"raw": "res://assets/images/veg_eggplant_raw.png", "baked": "res://assets/images/veg_eggplant_baked.png", "scale": 0.336},
	{"raw": "res://assets/images/veg_garlic_raw.png", "baked": "res://assets/images/veg_garlic_baked.png", "scale": 0.22},
	{"raw": "res://assets/images/veg_jalapeno_raw.png", "baked": "res://assets/images/veg_jalapeno_baked.png", "scale": 0.27},
	{"raw": "res://assets/images/veg_mushroom_cantharellus_friesii_raw.png", "baked": "res://assets/images/veg_mushroom_cantharellus_friesii_baked.png", "scale": 0.28},
	{"raw": "res://assets/images/veg_mushroom_enoki_raw.png", "baked": "res://assets/images/veg_mushroom_enoki_baked.png", "scale": 0.288},
	{"raw": "res://assets/images/veg_mushroom_Lion's_Mane_raw.png", "baked": "res://assets/images/veg_mushroom_Lion's_Mane_baked.png", "scale": 0.304},
	{"raw": "res://assets/images/veg_mushroom_slice_raw.png", "baked": "res://assets/images/veg_mushroom_slice_baked.png", "scale": 0.28},
	{"raw": "res://assets/images/veg_mushroom_truffle_raw.png", "baked": "res://assets/images/veg_mushroom_truffle_baked.png", "scale": 0.24},
	{"raw": "res://assets/images/veg_mushroom_wild_enoki_raw.png", "baked": "res://assets/images/veg_mushroom_wild_enoki_baked.png", "scale": 0.288},
	{"raw": "res://assets/images/veg_olive_black_raw.png", "baked": "res://assets/images/veg_olive_black_baked.png", "scale": 0.25},
	{"raw": "res://assets/images/veg_olive_green_raw.png", "baked": "res://assets/images/veg_olive_green_baked.png", "scale": 0.25},
	{"raw": "res://assets/images/veg_onion_red_raw.png", "baked": "res://assets/images/veg_onion_red_baked.png", "scale": 0.35},
	{"raw": "res://assets/images/veg_onion_white_raw.png", "baked": "res://assets/images/veg_onion_white_baked.png", "scale": 0.35},
	{"raw": "res://assets/images/veg_Parsley_raw.png", "baked": "res://assets/images/veg_Parsley_baked.png", "scale": 0.28},
	{"raw": "res://assets/images/veg_red_pepper_raw.png", "baked": "res://assets/images/veg_red_pepper_baked.png", "scale": 0.35},
	{"raw": "res://assets/images/veg_Rosemary_raw.png", "baked": "res://assets/images/veg_Rosemary_baked.png", "scale": 0.30},
	{"raw": "res://assets/images/veg_spinach_raw.png", "baked": "res://assets/images/veg_spinach_baked.png", "scale": 0.38},
	{"raw": "res://assets/images/veg_tomato_slice_raw.png", "baked": "res://assets/images/veg_tomato_slice_baked.png", "scale": 0.3696},
	{"raw": "res://assets/images/veg_zucchini_raw.png", "baked": "res://assets/images/veg_zucchini_baked.png", "scale": 0.266}
]

func _ready():
	btn_next.pressed.connect(_on_btn_next_pressed)
	btn_bake.pressed.connect(_on_btn_bake_pressed)
	btn_undo.pressed.connect(_on_btn_undo_pressed)
	btn_reset.pressed.connect(_on_btn_reset_pressed)
	
	btn_category_cheese.pressed.connect(func(): _show_topping_category("cheese"))
	btn_category_meat.pressed.connect(func(): _show_topping_category("meat"))
	btn_category_seafood.pressed.connect(func(): _show_topping_category("seafood"))
	btn_category_veg.pressed.connect(func(): _show_topping_category("veg"))
	
	sauce_menu.visible = true
	category_icons_container.visible = false
	if $UI.has_node("ToppingsCategoryMenu"):
		$UI/ToppingsCategoryMenu.visible = false
	
	btn_next.visible = true
	btn_bake.visible = false
	btn_undo.visible = false
	btn_reset.visible = false
	
	_setup_sauce_menu()
	_setup_category_menus()
	
	_thicken_scroll_bar(sauce_menu, 75)
	_thicken_scroll_bar(cheese_scroll, 75)
	_thicken_scroll_bar(meat_scroll, 75)
	_thicken_scroll_bar(seafood_scroll, 75)
	_thicken_scroll_bar(veg_scroll, 75)

func _thicken_scroll_bar(scroll_container: ScrollContainer, extra_margin: int):
	if scroll_container:
		var h_bar = scroll_container.get_h_scroll_bar()
		if h_bar:
			h_bar.visible = true
			h_bar.custom_minimum_size = Vector2(0, 36)
			
			var margin_style = StyleBoxEmpty.new()
			margin_style.content_margin_top = extra_margin
			h_bar.add_theme_stylebox_override("panel", margin_style)
			
			# پس‌زمینه اسکرول‌بار: مشکی عمیق
			var bg_style = StyleBoxFlat.new()
			bg_style.bg_color = Color(0.08, 0.08, 0.08, 0.95)
			bg_style.corner_radius_top_left = 8
			bg_style.corner_radius_top_right = 8
			bg_style.corner_radius_bottom_left = 8
			bg_style.corner_radius_bottom_right = 8
			h_bar.add_theme_stylebox_override("scroll", bg_style)
			
			# دستگیره اسکرول (Grabber): طلایی خیره‌کننده و گرم هماهنگ با تصویر مرجع
			var grabber_style = StyleBoxFlat.new()
			grabber_style.bg_color = Color(1.0, 0.75, 0.15, 1.0)
			grabber_style.corner_radius_top_left = 8
			grabber_style.corner_radius_top_right = 8
			grabber_style.corner_radius_bottom_left = 8
			grabber_style.corner_radius_bottom_right = 8
			h_bar.add_theme_stylebox_override("grabber", grabber_style)
			h_bar.add_theme_stylebox_override("grabber_highlight", grabber_style)
			h_bar.add_theme_stylebox_override("grabber_pressed", grabber_style)

func _setup_sauce_menu():
	var container = $UI/SauceMenu/HBoxContainer
	for item in sauces_data:
		var btn = TextureButton.new()
		btn.texture_normal = load(item["raw"])
		btn.custom_minimum_size = Vector2(200, 200)
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		
		var raw_p = item["raw"]
		var baked_p = item["baked"]
		btn.pressed.connect(func(): select_sauce(raw_p, baked_p))
		container.add_child(btn)

func select_sauce(raw_path: String, baked_path: String):
	if is_baked:
		return
	if current_sauce_node and is_instance_valid(current_sauce_node):
		current_sauce_node.queue_free()
		
	current_sauce_node = Sprite2D.new()
	current_sauce_node.texture = load(raw_path)
	current_sauce_node.position = dough_rect.position
	current_sauce_node.scale = dough_rect.scale * 0.9
	current_sauce_node.z_index = 5
	
	pizza_board.add_child(current_sauce_node)
	current_sauce_node.set_meta("baked_path", baked_path)

func _setup_category_menus():
	_populate_menu(cheese_menu, cheeses_data, 175)
	_populate_menu(meat_menu, meats_data, 195)
	_populate_menu(seafood_menu, seafood_data, 195)
	_populate_menu(veg_menu, veg_data, 195)

func _populate_menu(menu_container: HBoxContainer, data_array: Array, btn_size: int):
	for item in data_array:
		var btn = TextureButton.new()
		btn.texture_normal = load(item["raw"])
		btn.custom_minimum_size = Vector2(btn_size, btn_size)
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		
		var item_ref = item
		btn.gui_input.connect(func(event):
			if is_baked:
				return
			if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				_start_dragging(item_ref, event.global_position)
		)
		menu_container.add_child(btn)

func _start_dragging(item_data, pos):
	dragging_item_data = item_data
	if drag_preview and is_instance_valid(drag_preview):
		drag_preview.queue_free()
		
	drag_preview = Sprite2D.new()
	drag_preview.texture = load(item_data["raw"])
	drag_preview.scale = Vector2.ONE * item_data["scale"]
	drag_preview.global_position = pos
	drag_preview.modulate.a = 0.8
	drag_preview.z_index = 100
	add_child(drag_preview)

func _input(event):
	if dragging_item_data and drag_preview:
		if event is InputEventMouseMotion:
			drag_preview.global_position = event.global_position
		elif event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_drop_item(event.global_position)

func _drop_item(pos):
	if not dragging_item_data:
		return
		
	var dough_global_pos = dough_rect.global_position
	var dough_radius = (dough_rect.texture.get_size().x * dough_rect.scale.x) / 2.0
	
	if dough_global_pos.distance_to(pos) <= dough_radius * 0.95:
		var sprite = Sprite2D.new()
		sprite.texture = load(dragging_item_data["raw"])
		sprite.scale = Vector2.ONE * dragging_item_data["scale"]
		sprite.rotation_degrees = randf_range(0.0, 360.0)
		sprite.z_index = 10
		
		pizza_board.add_child(sprite)
		sprite.global_position = pos
		
		placed_toppings.append({"node": sprite, "baked_path": dragging_item_data["baked"]})
	
	if drag_preview and is_instance_valid(drag_preview):
		drag_preview.queue_free()
		drag_preview = null
	dragging_item_data = null

func _show_topping_category(category: String):
	cheese_scroll.visible = (category == "cheese")
	meat_scroll.visible = (category == "meat")
	seafood_scroll.visible = (category == "seafood")
	veg_scroll.visible = (category == "veg")

func _on_btn_next_pressed():
	sauce_menu.visible = false
	btn_next.visible = false
	btn_reset.visible = false
	
	category_icons_container.visible = true
	if $UI.has_node("ToppingsCategoryMenu"):
		$UI/ToppingsCategoryMenu.visible = true
	btn_bake.visible = true
	btn_undo.visible = true
	
	_show_topping_category("cheese")

func _on_btn_bake_pressed():
	if is_baked:
		return
	is_baked = true
	
	category_icons_container.visible = false
	if $UI.has_node("ToppingsCategoryMenu"):
		$UI/ToppingsCategoryMenu.visible = false
	btn_bake.visible = false
	btn_undo.visible = false
	
	oven_bg.visible = true
	
	if bgm_player and bgm_player.playing:
		original_bgm_volume = bgm_player.volume_db
		bgm_player.volume_db = original_bgm_volume - 6.0
	
	sfx_player.stream = load("res://assets/audio/sound_baking.mp3")
	sfx_player.volume_db = 9.5
	sfx_player.play()
	
	await get_tree().create_timer(3.4).timeout
	
	dough_rect.texture = load("res://assets/images/dough_circle_baked.png")
	if current_sauce_node and is_instance_valid(current_sauce_node) and current_sauce_node.has_meta("baked_path"):
		current_sauce_node.texture = load(current_sauce_node.get_meta("baked_path"))
		
	for item in placed_toppings:
		if is_instance_valid(item["node"]):
			item["node"].texture = load(item["baked_path"])
		
	oven_bg.visible = false
	
	if bgm_player:
		bgm_player.volume_db = original_bgm_volume
		
	btn_reset.visible = true

func _on_btn_undo_pressed():
	if placed_toppings.size() > 0 and not is_baked:
		var last_item = placed_toppings.pop_back()
		if is_instance_valid(last_item["node"]):
			last_item["node"].queue_free()

func _on_btn_reset_pressed():
	for item in placed_toppings:
		if is_instance_valid(item["node"]):
			item["node"].queue_free()
	placed_toppings.clear()
	
	if current_sauce_node and is_instance_valid(current_sauce_node):
		current_sauce_node.queue_free()
		current_sauce_node = null
		
	is_baked = false
	dough_rect.texture = load("res://assets/images/dough_circle_raw.png")
	
	sauce_menu.visible = true
	category_icons_container.visible = false
	if $UI.has_node("ToppingsCategoryMenu"):
		$UI/ToppingsCategoryMenu.visible = false
	
	btn_next.visible = true
	btn_bake.visible = false
	btn_undo.visible = false
	btn_reset.visible = false

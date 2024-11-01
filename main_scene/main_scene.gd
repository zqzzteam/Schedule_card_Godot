extends Control

var now_save_file:SaveFileData
var save_file_path:String ="user://user_data.tres"

var select_card:BaseCardData

@onready var base_card_container = $BaseCardContainer
@onready var container_manager_1 = $VBoxContainer

func _ready():
	load_save_file(1)
	debug()
	pass

func _process(delta):
	pass

#遍历存档文件，加载卡牌
func clear_all_container():
	for card in base_card_container.get_children():
		base_card_container.remove_child(card)
		card.queue_free()

func load_save_file(page_index:int):
	now_save_file = load(save_file_path) as SaveFileData
	if page_index == 1: #是不是可以改进，不用写三次？
		if now_save_file.stack_cards_1 == null:
			return
		for card_data in now_save_file.stack_cards_1:#针对两种enum，load不同的程序
			if card_data.type == card_data.card_type.BASE_CARD:
				load_card_from_save_file(card_data)
			elif card_data.type == card_data.card_type.CONTROL_CARD:
				load_control_card_from_save_file(card_data)
				pass
	if page_index == 2: #是不是可以改进，不用写三次？
		if now_save_file.stack_cards_2 == null:
			return
		for card_data in now_save_file.stack_cards_2:#针对两种enum，load不同的程序
			print(card_data)
			if card_data.type == card_data.card_type.BASE_CARD:
				load_card_from_save_file(card_data)
			elif card_data.type == card_data.card_type.CONTROL_CARD:
				load_control_card_from_save_file(card_data)
				pass
	if page_index == 3: #是不是可以改进，不用写三次？
		if now_save_file.stack_cards_3 == null:
			return
		for card_data in now_save_file.stack_cards_3:#针对两种enum，load不同的程序
			print(card_data)
			if card_data.type == card_data.card_type.BASE_CARD:
				load_card_from_save_file(card_data)
			elif card_data.type == card_data.card_type.CONTROL_CARD:
				load_control_card_from_save_file(card_data)
				pass
	

func save_save_file(page_index:int): #如何减少代码量，不写3个if
	#now_save_file = SaveFileData.new() #要用new创建
	now_save_file = ResourceLoader.load(save_file_path) as SaveFileData
	#now_save_file = load(save_file_path) as SaveFileData #为什么这个找不到stack_card?
	if page_index == 1:
		now_save_file.stack_cards_1.clear()
		for panel in base_card_container.get_children():
			if not panel is HolderCard:
				var card_file = panel.return_card_file() as BaseCardData
				now_save_file.stack_cards_1.append(card_file)
	elif page_index == 2:
		now_save_file.stack_cards_2.clear()
		for panel in base_card_container.get_children():
			if not panel is HolderCard:
				var card_file = panel.return_card_file() as BaseCardData
				now_save_file.stack_cards_2.append(card_file)
	elif page_index == 3:
		now_save_file.stack_cards_3.clear()
		for panel in base_card_container.get_children():
			if not panel is HolderCard:
				var card_file = panel.return_card_file() as BaseCardData
				now_save_file.stack_cards_3.append(card_file)
	ResourceSaver.save(now_save_file,save_file_path)

func load_card_from_save_file(card_data:BaseCardData,path=""):
	var card:PackedScene 
	if path == "":
		card = load("res://card_create_component/base_card_panel.tscn") as PackedScene 
	else:
		card = load(path) as PackedScene 
	var card_instance = card.instantiate()
	card_instance.init_load_form_file(card_data)
	base_card_container.add_child(card_instance)

func load_control_card_from_save_file(card_data:BaseCardData): #查一下controlcard的场景号，对应加载
	var control_card_index = card_data.control_card_index
	match control_card_index:
		Vector2(1,0):
			load_card_from_save_file(card_data,\
			"res://card_create_component/control_card_component/control_card_instance/control_card_panel_1_0.tscn")
		Vector2(2,0):
			load_card_from_save_file(card_data,\
			"res://card_create_component/control_card_component/control_card_instance/control_card_panel_2_0.tscn")
		Vector2(2,1):
			load_card_from_save_file(card_data,\
			"res://card_create_component/control_card_component/control_card_instance/control_card_panel_2_1.tscn")
		Vector2(2,2):
			load_card_from_save_file(card_data,\
			"res://card_create_component/control_card_component/control_card_instance/control_card_panel_2_2.tscn")
	pass

#control按钮信号逻辑处理
signal clear_holder
signal add_holder
func change_page_to(page_index:int):
	print(page_index)
	clear_all_container()
	load_save_file(page_index)
	self.connect("clear_holder",Callable(container_manager_1,"clear_all_holder_panel"))
	emit_signal("clear_holder")
	self.connect("add_holder",Callable(container_manager_1,"add_all_holder_panel"))
	emit_signal("add_holder")
	pass

func minimize_page():
	print("mini")
	pass

func exit_process():
	print("exit")
	pass

func change_setting(): #如何修改设置还没想明白
	pass

#debug和调试
func save_a_new_file(): #for debug
	var new_save = SaveFileData.new()
	ResourceSaver.save(new_save,save_file_path)

func debug():
	pass


func _on_button_button_up():
	
	#save_save_file(3)
	pass # Replace with function body.

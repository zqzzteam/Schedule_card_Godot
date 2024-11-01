extends VBoxContainer
@onready var _card_panel = $"../BaseCardContainer/BaseCardPanel" as BaseDragableCard
@onready var _upper_container = $"../UpperContainer"
@onready var _card_panel_container = $"../BaseCardContainer" #这两个记得随时调整！！！！！

var _drag_offset := Vector2.ZERO
var _is_drag:bool = false
var _focus_card:BaseDragableCard = null
var _focus_card_index:int = 0
var _focus_card_before_position:Vector2

var holder_scan_stop:bool = false

func _ready():
	await $"..".ready #引入了加载存档数据的根节点的脚本，记得实时更新位置！！！
	clear_all_holder_panel()
	add_all_holder_panel()
	pass 


func _process(delta):
	drag()
	holder_scan()
	pass
	

func drag():
	if _is_drag and _focus_card:
		_focus_card.global_position = get_global_mouse_position()+_drag_offset

func start_drag():
	_is_drag = true
	#计算差值
	_drag_offset = _focus_card.global_position-get_global_mouse_position()
	#记录开始拖拽的位置
	_focus_card_before_position = _focus_card.global_position
	#卡片节点换到顶层缓存器中
	_focus_card_index = _focus_card.get_index()
	_focus_card.reparent(_upper_container)
	_focus_card = _upper_container.get_child(0) #不知道为什么，reparent后原先的变量无法跟踪位置
	#更新holder
	clear_all_holder_panel()
	add_all_holder_panel()
	#放大的holder
	print(_focus_card_index)
	var change_holder = _card_panel_container.get_child(_focus_card_index-1) as HolderCard 
	change_holder.custom_minimum_size.y = _focus_card.custom_minimum_size.y +_card_panel_container.get_theme_constant("separation") 

func stop_drag():
	_is_drag = false
	#有active时执行插入
	for holder in _card_panel_container.get_children():
		if holder is HolderCard and holder.active == true:
			#记录选定的holder的index和位置
			var holder_index = holder.get_index()
			var card_before_position = _focus_card.global_position
			#var card_after_position = holder.global_position #可能会报错，位置还要调整
			#动态换父节点
			_focus_card.reparent(_card_panel_container)
			var count = _card_panel_container.get_child_count()
			for i in _card_panel_container.get_child_count():
				var card = _card_panel_container.get_child(count)
				if card is BaseDragableCard:
					_focus_card = _card_panel_container.get_child(count)
					break
				count -= 1
			#移动卡片到选定的holder位置
			_card_panel_container.move_child(_focus_card,holder_index)
			clear_all_holder_panel()
			add_all_holder_panel()
			#播放tween动画
			#for i in 2:
				#await get_tree().process_frame
			#var card_after_position = _focus_card.global_position
			#_focus_card.global_position = card_before_position
			#var tween_2 = create_tween()
			#print(card_before_position,"and after",card_after_position)
			#print(_focus_card.global_position)
			#holder_scan_stop = true
			#tween_2.tween_property(_focus_card,"global_position",card_after_position,1).set_trans(Tween.TRANS_QUINT)
			#for i in 3:
				#await get_tree().process_frame
				#print(_focus_card.global_position)
			#holder_scan_stop = false
			return
	#没有active时执行归还
	if _focus_card:
		#记录动画开始时位置#记录之前的位置
		var card_after_position = _focus_card_before_position
		var card_before_position = _focus_card.global_position
		#动态换父节点
		_focus_card.reparent(_card_panel_container)
		var count = _card_panel_container.get_child_count()
		for i in _card_panel_container.get_child_count():
			var card = _card_panel_container.get_child(count)
			if card is BaseDragableCard:
				_focus_card = _card_panel_container.get_child(count)
				break
			count -= 1
		_card_panel_container.move_child(_focus_card,_focus_card_index)
		#更新holder
		clear_all_holder_panel()
		add_all_holder_panel()
		#播放tween动画,改变节点后移动位置不太好，会有一两帧闪烁
		#_focus_card.visible = false #不知道为什么，更新visible后后续动画无法播放
		for i in 2:
			await get_tree().process_frame
		#_focus_card.visible = true
		_focus_card.global_position = card_before_position
		var tween = create_tween()
		tween.tween_property(_focus_card,"global_position",card_after_position,0.2).set_trans(Tween.TRANS_QUINT)
		

func _input(event):
	drag_input_deal(event)

func drag_input_deal(event:InputEvent):
	if _focus_card == null:
		#print("NO_Card")
		return
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed(): #可恶，松开按键没有button_mask,button_index好一些
			var size :Vector2 = _focus_card.get_rect().size
			var mouse_global_position :Vector2 = get_global_mouse_position() #检测在卡的范围之内，要写到卡里面
			if _focus_card.global_position.x <= mouse_global_position.x and mouse_global_position.x <= (_focus_card.global_position.x + size.x) :
				if _focus_card.global_position.y <= mouse_global_position.y and mouse_global_position.y <= (_focus_card.global_position.y + size.y) :
					start_drag()
					return
		if event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
			stop_drag()
			return

#接受鼠标选中了哪个卡的数据
func get_card_index_in(card_id:int,card_type:String): #改变卡牌位置写在strat_drag里面了
	if card_type == "BaseDragableCard":
		_focus_card = instance_from_id(card_id)
		return
	if card_type == "ControlCard":
		pass
	pass

func get_card_index_out(card_id:int,card_type:String):
	if card_type == "BaseDragableCard":
		if card_id == _focus_card.get_instance_id() :
			_focus_card = null
			return
	if card_type == "ControlCard":
		pass
	pass

#处理holderpanel的变化
func clear_all_holder_panel(): #内置在add中了
	for holder in _card_panel_container.get_children():
		if holder is HolderCard:
			_card_panel_container.remove_child(holder)
			holder.queue_free()
	pass

func add_all_holder_panel():
	for index in _card_panel_container.get_child_count()+1:
		print("HOLDER_ADD")
		var holder_pre = load("res://card_create_component/holder_card_component/holder_card_panel.tscn") as PackedScene
		var added_holder = holder_pre.instantiate()
		_card_panel_container.add_child(added_holder)
		_card_panel_container.move_child(added_holder,index*2)
	#去掉第一个holder，因为第一个是标题
	var first_child = _card_panel_container.get_child(0)
	_card_panel_container.remove_child(first_child)
	pass

func holder_scan(): #扫描检测有没有放大的
	#if holder_scan_stop == true: #调试上方的stop_drag第一种情况用的
		#return
	for holder in _card_panel_container.get_children():
		if holder is HolderCard:
			var offset_area = Vector2(150,50)
			var y_offset = -100
			var holder_size = holder.get_rect().size + offset_area*2
			var mouse_position = get_global_mouse_position()
			var holder_position = holder.global_position - offset_area
			if holder_position.x  <= mouse_position.x and mouse_position.x <= holder_position.x+holder_size.x \
			and holder_position.y+y_offset  <= mouse_position.y and mouse_position.y <= holder_position.y+holder_size.y+y_offset:
				holder.active = true
			else:
				holder.active = false

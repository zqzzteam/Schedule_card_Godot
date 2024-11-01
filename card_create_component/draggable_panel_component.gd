class_name BaseDragableCard extends Panel

@onready var panel = $"." as Panel
@onready var color_pattern_manager = $"../../ColorPatternManager"
@onready var card_move_manager = $"../../VBoxContainer" #这个记得变化后要改

var card_dragable:bool = false

var color_group:int

signal start_drag(card_id:int)
signal stop_drag(card_id:int)

func _ready():
	self.connect("mouse_entered", Callable(self, "mouse_enter"))
	self.connect("mouse_exited", Callable(self, "mouse_exit"))
	self.connect("start_drag", Callable(card_move_manager, "get_card_index_in"))
	self.connect("stop_drag", Callable(card_move_manager, "get_card_index_out"))
	load_form(Vector2(200,300),0)
	pass 

func _process(delta):
	pass

#加载与返回卡组数据文件
func load_form(size:Vector2,group:int):
	self.size = size
	var return_color:Array[Color]
	return_color = color_pattern_manager.search_color(group,0) #后续把判断是否reverse的函数写进来
	var new_stylebox_normal = self.get_theme_stylebox("panel").duplicate()
	new_stylebox_normal.bg_color = return_color[0]
	#这里后续写returncolor[1]的字体颜色
	self.add_theme_stylebox_override("panel", new_stylebox_normal)

func init_load_form_file(load_file:BaseCardData):
	load_form(load_file.size,load_file.color_group)
	
func return_card_file()->BaseCardData:
	var card_file = BaseCardData.new()
	card_file.size = panel.size
	var new_stylebox_normal = panel.get_theme_stylebox("panel").duplicate()
	card_file.color = new_stylebox_normal.bg_color
	card_file.type = card_file.card_type.BASE_CARD
	card_file.color_group = color_group
	return card_file

#处理鼠标进入事件
func mouse_focus():
	pass
	
func mouse_enter():
	emit_signal("start_drag",get_instance_id(),"BaseDragableCard")
	pass

func mouse_exit():
	emit_signal("stop_drag",get_instance_id(),"BaseDragableCard")
	pass

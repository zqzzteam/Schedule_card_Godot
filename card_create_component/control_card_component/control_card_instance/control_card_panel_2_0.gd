extends ControlCard

#有些外部导入项目已经写在了类里面了
#包括
#@onready var main_scene = $"../.."
#@onready var panel = $"." as Panel
#@onready var card_move_manager = $"../../VBoxContainer"

@onready var to_main_button = $MarginContainer/VBoxContainer/HBoxContainer/To_Main_Button
#@onready var to_setting_button = $MarginContainer/VBoxContainer/HBoxContainer/To_Setting_Button
#@onready var minimize_button = $MarginContainer/VBoxContainer/HBoxContainer2/Minimize_Button
#@onready var exit_button = $MarginContainer/VBoxContainer/HBoxContainer3/Exit_Button


var card_dragable:bool = false

signal start_drag(card_id:int)
signal stop_drag(card_id:int)

func _ready():
	self.connect("mouse_entered", Callable(self, "mouse_enter"))
	self.connect("mouse_exited", Callable(self, "mouse_exit"))
	self.connect("start_drag", Callable(card_move_manager, "get_card_index_in"))
	self.connect("stop_drag", Callable(card_move_manager, "get_card_index_out"))
	load_form(Vector2(200,300),Color(randf_range(0,1),randf_range(0,1),randf_range(0,1)))
	#链接按钮信号
	to_main_button.connect("button_up",Callable(self,"to_main_card_deal"))
	#to_setting_button.connect("button_up",Callable(self,"to_setting_button_deal"))
	#minimize_button.connect("button_up",Callable(self,"minimize_button_deal"))
	#exit_button.connect("button_up",Callable(self,"exit_button_deal"))
	pass 

func _process(delta):
	pass

#加载与返回卡组数据文件
func load_form(size:Vector2,color:Color):
	self.size = size
	var new_stylebox_normal = self.get_theme_stylebox("panel").duplicate()
	new_stylebox_normal.bg_color = color
	self.add_theme_stylebox_override("panel", new_stylebox_normal)

func init_load_form_file(load_file:BaseCardData):
	load_form(load_file.size,load_file.color)
	
func return_card_file()->BaseCardData:
	var card_file = BaseCardData.new()
	card_file.size = panel.size
	var new_stylebox_normal = panel.get_theme_stylebox("panel").duplicate()
	card_file.color = new_stylebox_normal.bg_color
	card_file.type = card_file.card_type.CONTROL_CARD
	card_file.control_card_index = Vector2(2,0)
	return card_file

#处理鼠标进入事件
func mouse_focus():
	pass
	
func mouse_enter():
	emit_signal("start_drag",get_instance_id(),"ControlCard")
	pass

func mouse_exit():
	emit_signal("stop_drag",get_instance_id(),"ControlCard")
	pass

#处理按钮输入
signal change_page_signal(page_index:int)
func to_main_card_deal():
	self.connect("change_page_signal",Callable(main_scene,"change_page_to"))
	emit_signal("change_page_signal",1)
	pass
	
#func to_setting_button_deal():
	#self.connect("change_page_signal",Callable(main_scene,"change_page_to"))
	#emit_signal("change_page_signal",3)
	#pass
#
#signal minimize_signal
#func minimize_button_deal():
	#self.connect("minimize_signal",Callable(main_scene,"minimize_page"))
	#emit_signal("minimize_signal")
	#pass
#
#signal exit_signal
#func exit_button_deal():
	#self.connect("exit_signal",Callable(main_scene,"exit_process"))
	#emit_signal("exit_signal")
	#p

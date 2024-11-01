extends ControlCard

#有些外部导入项目已经写在了类里面了
#包括
#@onready var main_scene = $"../.."
#@onready var panel = $"." as Panel
#@onready var card_move_manager = $"../../VBoxContainer"

#@onready var to_edit_card_button = $MarginContainer/VBoxContainer/HBoxContainer/To_EditCard_Button
#@onready var to_setting_button = $MarginContainer/VBoxContainer/HBoxContainer/To_Setting_Button
#@onready var minimize_button = $MarginContainer/VBoxContainer/HBoxContainer2/Minimize_Button
#@onready var exit_button = $MarginContainer/VBoxContainer/HBoxContainer3/Exit_Button

#内部container和button的导入
@onready var color_pattern_container = $MarginContainer/VBoxContainer/color_pattern_container

var card_dragable:bool = false

signal start_drag(card_id:int)
signal stop_drag(card_id:int)

func _ready():
	update_version_and_path()
	color_pattern_button_load()
	#链接鼠标检测
	self.connect("mouse_entered", Callable(self, "mouse_enter"))
	self.connect("mouse_exited", Callable(self, "mouse_exit"))
	self.connect("start_drag", Callable(card_move_manager, "get_card_index_in"))
	self.connect("stop_drag", Callable(card_move_manager, "get_card_index_out"))
	load_form(Vector2(200,500),Color(randf_range(0,1),randf_range(0,1),randf_range(0,1)))
	pass 

func _process(delta):
	update_sound_label()
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
	card_file.control_card_index = Vector2(2,1)
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


#处理设置改变的显示调整
@onready var sound_label = $MarginContainer/VBoxContainer/SoundLabel
@onready var sound_h_slider = $MarginContainer/VBoxContainer/SoundHSlider

func update_sound_label():
	sound_label.text = str(sound_h_slider.value) + "%"

@onready var load_file_link_button = $MarginContainer/VBoxContainer/LoadFileLinkButton

func update_version_and_path():
	load_file_link_button.uri = ProjectSettings.globalize_path("user://") #user://user_data.tres#不考虑直接打开存档文件
	#这里以后还要加进来版本控制的接口

func color_pattern_button_load():
	for color_pattern in color_pattern_manager.color_pattern_group:
		var button_text = color_pattern.name
		var new_button = Button.new()
		new_button.text = button_text
		#这里还要初始化风格
		#new_button.connect() #这里链接一个自身的修改datafile的函数，需要传button的index
		color_pattern_container.add_child(new_button)
	pass

func color_pattern_button_deal():
	pass

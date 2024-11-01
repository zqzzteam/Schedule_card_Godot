extends Control


func _ready():
	self.connect("mouse_entered",Callable(self, "deal_mouse_entered"))
	self.connect("mouse_exited",Callable(self, "deal_mouse_exited"))
	pass


func deal_mouse_entered():
	#self.focus_mode = Control.FOCUS_CLICK
	pass

func deal_mouse_exited():
	#self.focus_mode = Control.FOCUS_NONE
	pass

func _input(event):
	#设置enter取消聚焦
	if event is InputEventKey and event.is_pressed():
		if event.physical_keycode == KEY_ENTER or event.physical_keycode == KEY_KP_ENTER:
			if self.has_focus():
				self.focus_mode = Control.FOCUS_NONE
				self.focus_mode = Control.FOCUS_CLICK
		

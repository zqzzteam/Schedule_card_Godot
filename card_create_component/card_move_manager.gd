extends Node

@onready var _card_panel_container = $"../.."
@onready var _card_panel = $".." as Panel
var _is_drag :bool =false
var _is_dragable :bool =false
var _drag_offset := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	_card_panel.connect("mouse_entered",Callable(self, "start_drag"))
	_card_panel.connect("mouse_exited",Callable(self, "stop_drag"))
	pass # Replace with function body.


func _process(delta):
	#print(_is_dragable)
	drag()
	pass
	
#简易版
func drag():
	if _is_drag == true:
		_drag_offset = _card_panel.global_position-_card_panel_container.get_global_mouse_position()
		_card_panel.global_position = _card_panel_container.get_global_mouse_position()+_drag_offset
	pass

func start_drag():
	_is_dragable = true
	pass

func stop_drag():
	_is_dragable = false
	pass

func _input(event):
	#print(event.is_pressed())
	if event == InputEventMouse and event.is_pressed():
		print("OK1")
		if event.button_mask == MOUSE_BUTTON_LEFT :
			print("OK2")
			if _is_dragable == true:
				print("OK3")
				_is_drag = true
	if event == InputEventMouse and event.is_released():
		if event.button_mask == MOUSE_BUTTON_LEFT :
			if _is_dragable == true:
				_is_drag = false
	pass

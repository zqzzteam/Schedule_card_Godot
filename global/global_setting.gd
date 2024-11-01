extends Node

#这些需不需要个setter方法，设置后自动在savefile里面同步更新，savefile里面建一个setting
var color_pattern:int
var language:String
var global_sound:float #后续需要钳制在0-100？

var save_file_path:String ="user://user_data.tres"

func _ready():
	load_setting()
	pass

func load_setting():
	var now_save_file = load(save_file_path) as SaveFileData
	color_pattern = now_save_file.color_pattern
	language = now_save_file.language
	global_sound = now_save_file.global_sound
	pass

func _process(delta):
	pass

#记得修改完设置后调用load_setting

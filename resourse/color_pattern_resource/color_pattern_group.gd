class_name ColorPatternGroup extends Node

@export var color_pattern_group:Array[ColorPattern]
var pattern_index:int = 0 

func _ready():
	load_pattern_index()

func load_pattern_index(): #记得改完设置后要重新加载
	pattern_index = GlobalSetting.color_pattern

func search_color(card_group_index:int,reverse:bool):
	var select_color_pattern = color_pattern_group[pattern_index] as ColorPattern
	if reverse:
		var return_color:Array[Color]
		return_color.append(select_color_pattern.re_backgroud_color_array[card_group_index])
		return_color.append(select_color_pattern.re_text_color_array[card_group_index])
		return return_color
	else:
		var return_color:Array[Color]
		return_color.append(select_color_pattern.backgroud_color_array[card_group_index])
		return_color.append(select_color_pattern.text_color_array[card_group_index])
		return return_color
	pass

func return_color():
	pass

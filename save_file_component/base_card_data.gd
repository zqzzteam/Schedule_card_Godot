class_name BaseCardData
extends Resource

enum card_type{
	BASE_CARD,
	CONTROL_CARD,
}

@export var type :int
@export var control_card_index:Vector2

@export var color_group :int
@export var size :Vector2
@export var color :Color

@export var title_text :String = ""
@export var task_text :Array[String]

class_name HolderCard extends Panel

var active:bool = false

var minimum_size := Vector2(0,10)
var active_size := Vector2(0,200)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	active_form()
	pass

#实时改变节点大小
func active_form():
	if active == true:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "custom_minimum_size", active_size, 0.5)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "custom_minimum_size", minimum_size, 0.5)

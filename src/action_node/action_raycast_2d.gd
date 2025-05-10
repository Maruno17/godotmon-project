@tool
extends RayCast2D
class_name ActionRaycast2D


## A raycast meant for dectection of entities.
##
## Triggers a list of actions when the raycast is colliding.[br]
## Don't forget to assign the collision mask properly.
##
## @tutorial: TODO


## The length of the raycast, in tiles.
@export_range(1,999) var length : int = 1 :
	set(value):
		length = value
		target_position.y = Constants.TILE_SIZE * value
## Script containing all of the actions this raycast should execute when colliding.
@export var action_script : GDScript


func _ready() -> void:
	target_position.y = Constants.TILE_SIZE * length # For cases where it is left at the default value.
	@warning_ignore("integer_division")
	position = Vector2(Constants.TILE_SIZE / 2, Constants.TILE_SIZE / 2)
	


func _process(_delta: float) -> void:
	force_raycast_update()
	if is_colliding():
		if not _is_method_valid("on_collide") or Engine.is_editor_hint():
			return
		else:
			action_script.call("on_collide", get_collider())


func _is_method_valid(method_name : StringName) -> bool:
	var action_script_methods_dict : Array = action_script.get_script_method_list()
	var action_script_dict_values : Array
	for method in action_script_methods_dict:
		action_script_dict_values.append(method.values()[0])
	
	if action_script == null:
		push_error("This action node doesn't have an action script.")
		return false
	if not action_script_dict_values.has(method_name):
		push_error("The action script of this node doesn't have a \"%s\" function. If you think
		that it does, make sure to check the spelling of your function's name." % method_name)
		return false
	
	return true

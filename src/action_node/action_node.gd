@tool
@icon("uid://dlqcsibc0m0wx")
extends Node2D
class_name ActionNode


## Executes a list of actions.
##
## Lets you run functions in the overworld based on the list of actions given in the actions_script variable.[br]
## Please note that all of the functions from your actions script must be preceded by the "static" keyword.
##
## @tutorial: TODO


enum ActionMode{
	## When the player uses the interact key in this nodes area.
	INTERACT,
	## When the player enters this nodes area.
	PLAYER_CONTACT,
	## When an entity other than the player enters this nodes area.
	ENTITY_CONTACT,
	}


const DEFAULT_COLOR : Color = Color(1,1,1,0.5)


## Determines when the actions associated with this node should be happen.
@export var action_mode : ActionMode :
	set(value):
		action_mode = value
		_update_area_collisions()
## Script containing all of the actions this node should execute.
@export var action_script : GDScript
## Size of the area covered by this action, in tiles.
@export var size : Vector2i = Vector2i.ONE :
	set(value):
		size.x = clampi(value.x, 1, 999)
		size.y = clampi(value.y, 1, 999)
		_update_node_size()


@export var debug_color : Color = DEFAULT_COLOR :
	set(value):
		debug_color = value
		collision_shape_2d.debug_color = debug_color


var area_2d : Area2D = Area2D.new()
var collision_shape_2d: CollisionShape2D = CollisionShape2D.new()


func _ready() -> void:
	top_level = true
	
	_setup_child()
	
	#await Observer.map_entered #TODO
	_call_function("ready")


func _process(delta: float) -> void:
	if not _is_method_valid("process", true):
		set_process(false)
	
	_call_function("process", true, delta)


func _setup_child() -> void:
	_reset_area_collisions()
	_update_area_collisions()
	area_2d.body_entered.connect(run_interaction)
	
	collision_shape_2d.shape = RectangleShape2D.new()
	_update_node_size()
	collision_shape_2d.debug_color = debug_color
	
	add_child(area_2d, false, INTERNAL_MODE_FRONT)
	area_2d.add_child(collision_shape_2d, false, INTERNAL_MODE_FRONT)


func _update_node_size() -> void:
	collision_shape_2d.shape.size = Vector2(size * Constants.TILE_SIZE) - Vector2(2,2)
	collision_shape_2d.position = collision_shape_2d.shape.size / 2 + Vector2.ONE


func _reset_area_collisions() -> void:
	area_2d.collision_layer = 0
	area_2d.collision_mask = 0
	area_2d.monitorable = false
	area_2d.monitoring = false


func _update_area_collisions() -> void:
	_reset_area_collisions()
	match action_mode:
		ActionMode.INTERACT:
			area_2d.monitorable = true
			area_2d.collision_layer = 524288
		ActionMode.PLAYER_CONTACT:
			area_2d.monitoring = true
			area_2d.collision_mask = 2
		ActionMode.ENTITY_CONTACT:
			area_2d.monitoring = true
			area_2d.collision_mask = 4


func run_interaction(_body : CharacterBody2D) -> void:
	_call_function("on_interact", false)


func _call_function(function_name : StringName, ignore_warning : bool = true, optional_parameter : Variant = null) -> void:
	if not _is_method_valid(function_name, ignore_warning) or Engine.is_editor_hint():
		return
	
	if optional_parameter == null:
		action_script.call(function_name)
	else:
		action_script.call(function_name, optional_parameter)


func _is_method_valid(method_name : StringName, ignore_warning : bool) -> bool:
	var action_script_methods_dict : Array = action_script.get_script_method_list()
	var action_script_dict_values : Array
	for method in action_script_methods_dict:
		action_script_dict_values.append(method.values()[0])
	
	if action_script == null:
		if not ignore_warning:
			push_error("This action node doesn't have an action script.")
		return false
	if not action_script_dict_values.has(method_name):
		if not ignore_warning:
			push_error("The action script of this node doesn't have a \"%s\" function. If you think
			 that it does, make sure to check the spelling of your function's name." % method_name)
		return false
	
	return true

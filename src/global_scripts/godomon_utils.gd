extends RefCounted
class_name GDMUtils


static var material : ShaderMaterial


static func grayscale_transition(texture_path : String, duration : float = 0.5, reverse : bool = false, color : Color = Color.BLACK) -> void:
	# Create the ColorRect.
	var color_rect : ColorRect = ColorRect.new()
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_rect.color = color
	color_rect.material = ShaderMaterial.new()
	
	# Create the material and its shader.
	material = color_rect.material
	material.shader = load("uid://crttgv1fw8ehk")
	material.set_shader_parameter("transition_texture", load(texture_path))
	
	# Adds the ColorRect to the tree.
	ScenesManager.main.ui_parent.add_child(color_rect)
	
	# Create the animation.
	var start_value : float = 0.0
	var end_value : float = 1.0
	
	if reverse:
		start_value = 1.0
		end_value = 0.0
	
	Observer.transition_started.emit()
	var tween : Tween = ScenesManager.main.create_tween()
	tween.tween_method(_set_shader_value, start_value, end_value, duration)
	await tween.finished
	Observer.transition_finished.emit()
	
	# Dispose of the ColorRect.
	await Observer.get_tree().process_frame # It isn't clean but it's the only solution I found to avoid flashing between a fade in and a fade out. -Sulucnal
	color_rect.queue_free()


# Sets the current step of the transition.
static func _set_shader_value(value : float) -> void:
	material.set_shader_parameter("progress", value)

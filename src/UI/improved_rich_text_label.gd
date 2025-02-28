extends RichTextLabel
class_name ImprovedRichTextLabel

func better_get_line_count() -> int:
	# Force text if size changed, maybe unessisary
	if size_changed():
		update_content()
	
	# Count visible lines
	var total_lines = 0
	var content_height = get_content_height()
	var line_height = get_theme_constant("line_separation") + get_theme_font("normal_font").get_height()
	
	if line_height > 0:
		total_lines = ceil(content_height / line_height)
	
	return max(1, total_lines + 1)

# All the following code may be unessisary but better safe than sorry and this has near 0 preformance cost
var _previous_size: Vector2

func size_changed() -> bool:
	var current_size = get_size()
	if current_size != _previous_size:
		_previous_size = current_size
		return true
	return false

func update_content():
	visible = false
	visible = true

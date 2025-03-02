extends Control
class_name DialogueBox

## NOTE: Modifying this scripts code while the game is running in the background seems to cuase un explainable crashes. This does not happen if you modify the code of another script so it's probably not an issue but keep it in mind if your making edits to this script

const DIALOGUE_BUST_PATH = "res://assets/graphics/dialogue_busts/"

@onready var dialogue_label = %DialogueLabel
@onready var cursor_texture_rect = %CursorTextureRect
@onready var name_plate_panel = %NamePlatePanel
@onready var name_label = %NameLabel
@onready var message_bust_rect = %MessageBustRect

## The complete message to display
var full_message: String = ""
## The number of characters shown so far
var displayed_chars: int = 0
## The speed at which text is displayed. A time will wait this variable amount of seconds before showing the next character.
var text_speed: float = 0.03
## The max amount of lines allowed to be visible at once in a dialogue box
var max_visible_lines: int = 3
## Weather or not the dialogue box is currently typing text
var typing_in_progress: bool = false
## Weather or not the dialogue box is currently awaiting for input from the user
var waiting_for_input: bool = false
## This bool prevents accidential button spam from the user that could otherwise potentially break the system or cuase them to skip dialogue they didn't want to
var input_cooldown: bool = false

## Fired when the user has gone through all the dialogue in the message
signal dialogue_completed

func _ready() -> void:
	hide()
	_cursor_hover()

func _ready_dialogue_box(message:String, speaker_name:String = "", message_bust_file_path:String = "") -> void:
	# Reset state
	dialogue_label.text = ""
	cursor_texture_rect.hide()
	name_plate_panel.hide()
	message_bust_rect.hide()
	full_message = message
	displayed_chars = 0
	
	# Show speaker name panel if it was specified
	if speaker_name != "":
		name_plate_panel.show()
		name_label.text = speaker_name
	# Show message bust if it was specified
	if message_bust_file_path != "":
		message_bust_rect.show()
		var image = load(DIALOGUE_BUST_PATH + message_bust_file_path)
		if image:
			message_bust_rect.texture = image
		else:
			push_error("Invalid message bust path: ", message_bust_file_path)

func type_message(message:String, speaker_name:String = "", message_bust_file_path:String = "") -> void:
	# Resets dialogue box
	_ready_dialogue_box(message, speaker_name, message_bust_file_path)
	
	# Show the dialogue box with animation
	await _transition(true)
	
	# Display text in chunks until complete
	while displayed_chars < full_message.length():
		await _display_chunk()
	
	dialogue_completed.emit()
	
	# Hide when done
	await _transition(false)

func set_message(message:String, speaker_name:String = "", message_bust_file_path:String = "") -> void:
	# Resets dialogue box
	_ready_dialogue_box(message, speaker_name, message_bust_file_path)
	
	# Show the dialogue box with animation
	await _transition(true)
	
	# Display text in chunks until complete
	while displayed_chars < full_message.length():
		await _display_chunk(false)  # false = no typing animation
	
	dialogue_completed.emit()
	
	# Hide when done
	await _transition(false)

# They typed bool determines weather text should flow on screen or should it all be shown instantly all at once, will in most cases be true
func _display_chunk(typed:bool = true) -> void:
	# Get remaining text and reset display
	var remaining_text = full_message.substr(displayed_chars)
	dialogue_label.text = remaining_text
	dialogue_label.visible_characters = 0
	
	typing_in_progress = typed
	waiting_for_input = false
	
	var last_safe_char_count = 0
	var current_line_count = 1
	
	if typed:
		# Type characters
		for i in range(remaining_text.length()):
			dialogue_label.visible_characters = i + 1
			
			# Check if adding a new line
			if dialogue_label.get_line_count() > current_line_count:
				
				current_line_count = dialogue_label.get_line_count()
				
				# Update last safe position before line break
				last_safe_char_count = i
				
				# If too many lines, go back to the last safe position
				if current_line_count > max_visible_lines:
					dialogue_label.visible_characters = last_safe_char_count
					break
				
			# If user pressed accept, then auto fill rest of dialgue instead of doing text flow
			if not typing_in_progress:
				_display_text_instantly(remaining_text)
				break
			
			# Wait 'text_speed' amount of seconds before typing the next character
			await get_tree().create_timer(text_speed).timeout
	else:
		_display_text_instantly(remaining_text)
	
	# Ensure at least one character is shown
	if dialogue_label.visible_characters == 0:
		dialogue_label.visible_characters = 1
	
	typing_in_progress = false
	waiting_for_input = true
	
	# Update displayed character count
	displayed_chars += dialogue_label.visible_characters
	
	# Wait for user input
	cursor_texture_rect.show()
	while waiting_for_input:
		await get_tree().process_frame

# Show max characters without exceeding line limit all at once
func _display_text_instantly(remaining_text:String) -> void:
	while dialogue_label.get_line_count() <= max_visible_lines and dialogue_label.visible_characters < remaining_text.length():
		dialogue_label.visible_characters += 1
	
	if dialogue_label.get_line_count() > max_visible_lines:
		dialogue_label.visible_characters -= 1

func _input(event) -> void:
	if event.is_action_pressed("ui_accept") and not input_cooldown:
		# Add cooldown to prevent button spam
		input_cooldown = true
		get_tree().create_timer(0.2).timeout.connect(func(): input_cooldown = false)
		
		if typing_in_progress:
			# Skip typing animation
			typing_in_progress = false
		elif waiting_for_input:
			# Continue to next chunk
			cursor_texture_rect.hide()
			waiting_for_input = false

func _clean_up_dialogue_box() -> void:
	hide()

## Animations
func _transition(show:bool) -> void:
	var tween = create_tween()
	if show:
		show()
		var new_y = position.y - get_viewport().get_visible_rect().size.y # NOTE: Not sure if this code is future proof for if/when we add things like changing screen sizes and stuff
		tween.tween_property(self, "position", Vector2(position.x, new_y), 0.5)
		await tween.finished
	else:
		var new_y = position.y + get_viewport().get_visible_rect().size.y # NOTE: Not sure if this code is future proof for if/when we add things like changing screen sizes and stuff
		tween.tween_property(self, "position", Vector2(position.x, new_y), 0.5)
		tween.tween_callback(_clean_up_dialogue_box)
		await tween.finished

func _cursor_hover() -> void:
	var cursor_og_pos = cursor_texture_rect.position
	while true:
		var tween = create_tween()
		tween.tween_property(cursor_texture_rect, "position", cursor_og_pos + Vector2(0, 2), 0.5)
		tween.chain().tween_property(cursor_texture_rect, "position", cursor_og_pos, 0.5)
		await tween.finished

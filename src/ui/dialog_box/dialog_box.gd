extends CanvasLayer


const LINES_IN_BOX : int = 3
const MAX_CHARACTER_PER_CHUNK : int = 150


signal message_closed


@onready var portrait_texture: TextureRect = %PortraitTexture
@onready var name_label: RichTextLabel = %NameLabel
@onready var dialog_label: RichTextLabel = %DialogLabel
@onready var arrow_panel: Panel = %ArrowPanel


var _message : String
var text_chunks : PackedStringArray

##@experimental
##Shows a dialog box with the specified [param message]. Supports [url=https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html]BBCode[/url].
func show_message(message : String, talker_name : String = "", talker_image_path : String = "") -> void:
	_reset_box()
	
	_message = message
	
	if talker_name != "":
		name_label.text = talker_name
		name_label.show()
	
	if talker_image_path != "":
		portrait_texture.texture = load(talker_image_path)
		portrait_texture.show()
	
	get_tree().paused = true
	_divide_message()
	show()
	_handle_message_display()


func _reset_box() -> void:
	name_label.hide()
	portrait_texture.hide()
	dialog_label.visible_ratio = 0


#TODO: Find a way to make it handle BBCode properly. Probably by using RegEx.
func _divide_message() -> void:
	#var raw_message : String = _strip_bbcode(_message)
	#var raw_message_array : PackedStringArray = raw_message.split(" ")
	var message_array : PackedStringArray = _message.split(" ")
	var string_section : String = ""
	for entry in message_array:
		if (string_section + entry).length() > MAX_CHARACTER_PER_CHUNK:
			text_chunks.append(string_section)
			string_section = (entry + " ")
		else:
			string_section += (entry + " ")
	
	text_chunks.append(string_section)


func _strip_bbcode(source:String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)


func _handle_message_display() -> void:
	arrow_panel.hide()
	dialog_label.text = text_chunks[0]
	if GlobalVar.milliseconds_per_char == 0:
			dialog_label.visible_ratio = 1
	while dialog_label.visible_ratio != 1:
		dialog_label.visible_characters += 1
		await get_tree().create_timer(GlobalVar.milliseconds_per_char).timeout


func _process(_delta: float) -> void: #I don't like the way it's done but I'm too tired to solve it right now.
	if dialog_label.visible_ratio == 1:
		arrow_panel.show()


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_accept"):
		return
	
	if dialog_label.visible_ratio == 1 and not text_chunks.is_empty():
		text_chunks.remove_at(0)
		
		if text_chunks.is_empty():
			_on_message_finished()
		else:
			dialog_label.visible_ratio = 0
			_handle_message_display()
	else:
		dialog_label.visible_ratio = 1


func _on_message_finished() -> void:
	hide()
	get_tree().paused = false
	message_closed.emit()

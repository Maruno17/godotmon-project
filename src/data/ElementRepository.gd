class_name ElementRepository
extends Resource
## Repository of elements.
##
## This repository is supposed to be the .tres file holding all the Elements so they can be easily accessed in game.

## List of element held by this repository
@export var _list: Array[Element]:
	set(value):
		_list = value
		_elementRecord.clear()
		for element in value:
			_elementRecord[element.id] = element
		
var _elementRecord: Dictionary
var _defaultElement: Element = Element.new()

func get_element(id: StringName) -> Element:
	if _elementRecord.has(id):
		return _elementRecord[id]
	
	return _defaultElement

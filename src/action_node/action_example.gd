extends RefCounted


static func ready() -> void:
	print("Ready!")


#static func process(_delta : float) -> void:
	#print("Process!")


static func on_interact() -> void:
	print("Interaction!")


static func on_collide(collider) -> void:
	print("Colliding with %s!" %collider.name)

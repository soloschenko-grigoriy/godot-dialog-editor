@tool
extends Resource
class_name IActor

@export var id: int
@export var name: String

func _init(_id: int = 0, _name: String = "") -> void:
    self.id = _id
    self.name = _name
extends Resource
class_name IVariable

@export var id: int
@export var key: String
@export var value: bool

func _init(_id: int, _key: String, _value: bool) -> void:
    self.id = _id
    self.key = _key
    self.value = _value
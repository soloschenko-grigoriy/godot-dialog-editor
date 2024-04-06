extends Resource
class_name IVariable

@export var id: int
@export var key: String
@export var value: bool

func _init(_id: int = 0, _key: String = "", _value: bool = false) -> void:
    self.id = _id
    self.key = _key
    self.value = _value
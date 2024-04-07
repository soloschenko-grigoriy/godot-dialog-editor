@tool
extends Resource
class_name ICondition

@export var id: String
@export var variable_id: int
@export var value: bool

func _init(_id: String = "", _variable_id: int = -1, _value: bool = false) -> void:
    self.id = _id
    self.variable_id = _variable_id
    self.value = _value
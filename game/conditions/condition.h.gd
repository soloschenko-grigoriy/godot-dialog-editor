extends Resource
class_name ICondition

@export var id: String
@export var variable: IVariable
@export var value: bool

func _init(_id: String, _variable: IVariable, _value: bool) -> void:
    self.id = _id
    self.variable = _variable
    self.value = _value
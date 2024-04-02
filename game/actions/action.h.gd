extends Resource
class_name IAction

@export var id: int
@export var variable: IVariable
@export var value: bool

func _init(_id: int, _variable: IVariable, _value: bool) -> void:
    self.id = _id
    self.variable = _variable
    self.value = _value
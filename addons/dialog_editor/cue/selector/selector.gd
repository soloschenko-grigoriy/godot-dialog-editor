@tool
extends BoxContainer

class_name Selector

@onready var key: OptionButton = %Key
@onready var value: OptionButton = %Value

@export var selected_id: int = -1
@export var selected_value: bool


func _ready() -> void:
    key.clear()
    for variable: IVariable in DialogManager.get_variables():
        key.add_item(variable.key, variable.id)

    key.select(get_key_index())
    value.select(get_value_index())
        
    
func setup(_selected_id: int = -1, _selected_value: bool = false) -> void:
    self.selected_id = _selected_id
    self.selected_value = _selected_value


func get_key_index() -> int:
    var variables: Array[IVariable] = DialogManager.get_variables()
    for index: int in variables.size():
        if variables[index].id == selected_id:
            return index
    
    return -1


func get_value_index() -> int:
    return 0 if selected_value == true else 1
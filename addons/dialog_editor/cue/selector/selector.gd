@tool
extends BoxContainer

class_name Selector

signal id_selected
signal value_selected

@onready var key: OptionButton = %Key
@onready var value: OptionButton = %Value

@export var id: String
@export var selected_key: int = -1
@export var selected_value: bool


func _ready() -> void:
    key.clear()
    for variable: IVariable in DialogManager.get_variables():
        key.add_item(variable.key, variable.id)

    key.select(get_key_index())
    value.select(get_value_index())

    key.item_selected.connect(set_key)
    value.item_selected.connect(set_value)

    value.disabled = selected_key == -1
        
    
func setup(_id: String, _selected_key: int = -1, _selected_value: bool = false) -> void:
    self.id = _id
    self.selected_key = _selected_key
    self.selected_value = _selected_value


func get_key_index() -> int:
    var variables: Array[IVariable] = DialogManager.get_variables()
    for index: int in variables.size():
        if variables[index].id == selected_key:
            return index
    
    return -1


func get_value_index() -> int:
    print(selected_value)
    return 0 if selected_value == true else 1


func set_key(index: int) -> void:
    selected_key = key.get_item_id(index)
    id_selected.emit(id, selected_key)

    value.disabled = selected_key == -1
    

func set_value(index: int) -> void:
    selected_value = value.get_item_id(index)
    value_selected.emit(id, selected_value)
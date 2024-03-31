extends GraphNode
class_name Entry

@onready var label: Label = $Label

## Must be set before the node is added to tree
var data: EntryResource


func _ready() -> void:
    label.text = data.text
    
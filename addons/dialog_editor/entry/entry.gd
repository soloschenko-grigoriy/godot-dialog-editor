extends GraphNode
class_name Entry

@onready var label: Label = $Label

## Must be set before the node is added to tree
var data: ICue


func _ready() -> void:
    label.text = data.text


func setup(cue: ICue) -> void:
    print(cue.id)
    self.data = cue

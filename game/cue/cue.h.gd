extends Resource
class_name ICue

@export var id: int
@export var text: String
@export var convoId: int
@export var parentCueId: int
@export var childCueIds: Array[int]
@export var actions: Array[IAction] = []
@export var conditions: Array[ICondition] = []


func _init(
    _id: int, 
    _text: String, 
    _convoId: int, 
    _parent_cue_id: int = 0, 
    _child_cue_ids: Array[int] = [], 
    _actions: Array[IAction] = [], 
    _conditions: Array[ICondition] = []
    ) -> void:
    self.id = _id
    self.text = _text
    self.convoId = _convoId
    self.parentCueId = _parent_cue_id
    self.childCueIds = _child_cue_ids
    self.actions = _actions
    self.conditions = _conditions
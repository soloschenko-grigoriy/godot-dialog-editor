extends Resource
class_name ICue

@export var id: int
@export var text: String
@export var convo_id: int
@export var parent_cue_id: int
@export var child_cue_ids: Array[int]
@export var actions: Array[IAction] = []
@export var conditions: Array[ICondition] = []
@export var position_x: float = 0
@export var position_y: float = 0


func _init(
    _id: int, 
    _text: String, 
    _convoId: int, 
    _parent_cue_id: int = 0, 
    _child_cue_ids: Array[int] = [], 
    _actions: Array[IAction] = [], 
    _conditions: Array[ICondition] = [],
    _position_x: float = 0,
    _position_y: float = 0
    ) -> void:
    self.id = _id
    self.text = _text
    self.convo_id = _convoId
    self.parent_cue_id = _parent_cue_id
    self.child_cue_ids = _child_cue_ids
    self.actions = _actions
    self.conditions = _conditions
    self.position_x = _position_x
    self.position_y = _position_y
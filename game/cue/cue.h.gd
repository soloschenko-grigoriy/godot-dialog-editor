@tool
extends Resource
class_name ICue

@export var id: int
@export var text: String
@export var convo_id: int
@export var parent_cue_id: int
@export var actions: Array[IAction] = []
@export var conditions: Array[ICondition] = []
@export var actor: IActor
@export var position_x: float = 0
@export var position_y: float = 0


func _init(
    _id: int = 0, 
    _text: String = "", 
    _convoId: int = 0, 
    _actor: IActor = null,
    _parent_cue_id: int = 0, 
    _actions: Array[IAction] = [], 
    _conditions: Array[ICondition] = [],
    _position_x: float = 0,
    _position_y: float = 0
    ) -> void:
    self.id = _id
    self.text = _text
    self.convo_id = _convoId
    self.actor = _actor
    self.parent_cue_id = _parent_cue_id
    self.actions = _actions
    self.conditions = _conditions
    self.position_x = _position_x
    self.position_y = _position_y
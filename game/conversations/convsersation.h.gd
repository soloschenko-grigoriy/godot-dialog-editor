extends Resource
class_name IConversation

@export var id: int
@export var title: String
@export var actors: Array[IActor]

func _init(_id: int = 0, _title: String = "", _actors: Array[IActor] = []) -> void:
    self.id = _id
    self.title = _title
    self.actors = _actors
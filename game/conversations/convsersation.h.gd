extends Resource
class_name IConversation

var id: int
var title: String
var actors: Array[IActor]

func _init(_id: int, _title: String, _actors: Array[IActor]) -> void:
    self.id = _id
    self.title = _title
    self.actors = _actors
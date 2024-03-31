extends Resource
class_name IConversation

var id: int
var title: String
var actors: Array[IActor]

func _init(id: int, title: String, actors: Array[IActor]):
    self.id = id
    self.title = title
    self.actors = actors
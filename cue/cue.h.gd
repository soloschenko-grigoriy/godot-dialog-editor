extends Resource
class_name ICue

var id: int
var text: String
var convoId: int

func _init(id: int, text: String, convoId: int):
    self.id = id
    self.text = text
    self.convoId = convoId
extends Resource
class_name ICue

var id: int
var text: String
var convoId: int
var parentCueId: int
var childCueIds: Array[int]

func _init(id: int, text: String, convoId: int, parentCueId: int = 0, childCueIds: Array[int] = []):
    self.id = id
    self.text = text
    self.convoId = convoId
    self.parentCueId = parentCueId
    self.childCueIds = childCueIds
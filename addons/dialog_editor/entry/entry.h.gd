extends Resource
class_name EntryResource

var id: int
var text: String

func _init(id: int, text: String):
    self.id = id
    self.text = text
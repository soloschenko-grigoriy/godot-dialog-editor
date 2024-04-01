@tool
extends Node

## TEMP
var actors: Array[IActor] = [
    IActor.new(1, "Ashley"),
    IActor.new(2, "John Smith"),
    IActor.new(23, "Ms. Burgess")
]

var convos: Array[IConversation] = [
	IConversation.new(1, "Convo 1", [actors[0], actors[1]]), 
	IConversation.new(2, "Convo 2", [actors[0], actors[2]]),
	IConversation.new(3, "Convo 3", [actors[1], actors[2]]),
]

var cues: Array[ICue] = [
	ICue.new(1, "Hello", convos[0].id), 
	ICue.new(2, "Hi", convos[0].id),
    ICue.new(3, "Oh no!", convos[1].id),
    ICue.new(4, "Oh yes!", convos[1].id),
]
## TEMP

func _ready() -> void:
    print("Hello, World!")


func get_conversations() -> Array[IConversation]:
    return convos


func get_conversation_by_id(id: int) -> IConversation:
    for convo: IConversation in convos:
        if(convo.id == id):
            return convo
    
    return null


func get_cues_by_conversation(convo: IConversation) -> Array[ICue]:
    return cues.filter(
        func (cue: ICue) -> bool: return cue.convoId == convo.id)


func get_next_cue_id() -> int:
    return cues.reduce(func (accum: int, cue: ICue) -> int: return cue.id if cue.id > accum else accum, 0) + 1


func create_new_cue(convo: IConversation) -> ICue:
    var newCue: ICue = ICue.new(get_next_cue_id(), "", convo.id)
    
    cues.append(newCue)
    return newCue
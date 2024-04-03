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
	ICue.new(1, "Parent", convos[0].id, 0, [], [], [], 40, 160), 
	ICue.new(2, "Child 1", convos[0].id, 1, [], [], [], 440, 60),
	ICue.new(5, "Child 2", convos[0].id, 1, [], [], [], 460, 320),
    ICue.new(3, "Oh no!", convos[1].id),
    ICue.new(4, "Oh yes!", convos[1].id),
]

var varibales: Array[IVariable] = [
    IVariable.new(1, "my_var_1", false),
    IVariable.new(2, "my_var_2", false),
    IVariable.new(3, "my_var_3", false),
    IVariable.new(4, "my_var_4", false),
]

## TEMP

func _ready() -> void:
    print("Hello, World!")


func get_conversations() -> Array[IConversation]:
    return convos


func get_variables() -> Array[IVariable]:
    return varibales


func get_conversation_by_id(id: int) -> IConversation:
    for convo: IConversation in convos:
        if(convo.id == id):
            return convo
    
    return null


func get_cues_by_conversation(convo: IConversation) -> Array[ICue]:
    return cues.filter(
        func (cue: ICue) -> bool: return cue.convoId == convo.id)


func get_cues_by_conversation_id(convoId: int) -> Array[ICue]:
    return cues.filter(
        func (cue: ICue) -> bool: return cue.convoId == convoId)


func get_next_cue_id() -> int:
    return cues.reduce(func (accum: int, cue: ICue) -> int: return cue.id if cue.id > accum else accum, 0) + 1


func get_actors() -> Array[IActor]:
    return actors


func get_actors_by_conversation_id(convoId: int) -> Array[IActor]:
    var convo: IConversation = get_conversation_by_id(convoId)

    return convo.actors


func get_actors_by_conversation(convo: IConversation) -> Array[IActor]:
    return convo.actors


func create_new_cue(convo: IConversation, parent_id: int = 0) -> ICue:
    var newCue: ICue = ICue.new(
        get_next_cue_id(), 
        "", 
        convo.id,
        parent_id,
        # [],
        # [IAction.new(1, varibales[0], true), IAction.new(2, varibales[1], false)],
        # [ICondition.new(1, varibales[2], false), ICondition.new(2, varibales[3], true)],
        )
    
    cues.append(newCue)
    return newCue


func delete_cue(cue: ICue) -> void:
    cues.remove_at(cues.find(cue))


func attach_cue(parent: ICue, child: ICue) -> void:
    child.parentCueId = parent.id
    parent.childCueIds.append(child.id)

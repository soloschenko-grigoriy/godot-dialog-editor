@tool
extends Node

const uuid_util = preload('res://addons/uuid/uuid.gd')

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
	ICue.new(1, "Parent", convos[0].id, actors[0], 0, [], [], [], 40, 160), 
	ICue.new(2, "Child 1", convos[0].id, actors[1], 1, [], [], [], 440, 60),
	ICue.new(5, "Child 2", convos[0].id, actors[1], 1, [], [], [], 460, 320),
    ICue.new(3, "Oh no!", convos[1].id, actors[2]),
    ICue.new(4, "Oh yes!", convos[1].id, actors[2]),
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


func get_variable_by_id(id: int) -> IVariable:
    for variable: IVariable in varibales:
        if(variable.id == id):
            return variable
    
    return null


func create_new_condition() -> ICondition:
    return ICondition.new(uuid_util.v4(), null, false)
    

func create_new_action() -> IAction:
    return IAction.new(uuid_util.v4(), null, false)


func get_conversation_by_id(id: int) -> IConversation:
    for convo: IConversation in convos:
        if(convo.id == id):
            return convo
    
    return null


func get_cues_by_conversation(convo: IConversation) -> Array[ICue]:
    return cues.filter(
        func (cue: ICue) -> bool: return cue.convo_id == convo.id)


func get_cues_by_conversation_id(convoId: int) -> Array[ICue]:
    return cues.filter(
        func (cue: ICue) -> bool: return cue.convo_id == convoId)


func get_next_cue_id() -> int:
    return cues.reduce(func (accum: int, cue: ICue) -> int: return cue.id if cue.id > accum else accum, 0) + 1


func get_actors() -> Array[IActor]:
    return actors


func get_actors_by_conversation_id(convoId: int) -> Array[IActor]:
    var convo: IConversation = get_conversation_by_id(convoId)

    return convo.actors


func get_actor_by_id(actor_id: int) -> IActor:
    for actor: IActor in actors:
        if(actor.id == actor_id):
            return actor
    
    return null


func get_conversant_by_conversation(convo_id: int, other_actor_id: int) -> IActor:
    var convo: IConversation = get_conversation_by_id(convo_id)
    for actor: IActor in convo.actors:
        if(actor.id != other_actor_id):
            return actor

    return convo.actors[0]


func get_actors_by_conversation(convo: IConversation) -> Array[IActor]:
    return convo.actors


func create_new_cue(convo: IConversation, actor: IActor, parent_id: int = 0) -> ICue:
    var newCue: ICue = ICue.new(
        get_next_cue_id(), 
        "", 
        convo.id,
        actor,
        parent_id,
        # [],
        # [IAction.new("900ffaad-2beb-4b7f-a5ad-70130fa10752", varibales[0], true), IAction.new("900ffaad-2beb-4b7f-a5ad-70130fa10753", varibales[1], false)],
        # [ICondition.new("f3112eb1-a2b1-471b-b69d-fcc74368d395", varibales[2], false), ICondition.new("f3112eb1-a2b1-471b-b69d-fcc74368d396", varibales[3], true)],
        )
    
    cues.append(newCue)
    return newCue


func delete_cue(cue: ICue) -> void:
    cues.remove_at(cues.find(cue))


func attach_cue(parent: ICue, child: ICue) -> void:
    child.parent_cue_id = parent.id
    parent.child_cue_ids.append(child.id)

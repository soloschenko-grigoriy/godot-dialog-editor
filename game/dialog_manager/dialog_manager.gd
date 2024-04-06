@tool
extends Node

const DATABASE_PATH: String = "res://game/dialog_manager/dialog_database.tres"
const uuid_util = preload('res://addons/uuid/uuid.gd')

const auto_save_interval: float = 5.0

## TEMP
# var actors: Array[IActor] = [
#     IActor.new(1, "Ashley"),
#     IActor.new(2, "John Smith"),
#     IActor.new(23, "Ms. Burgess")
# ]

# var convos: Array[IConversation] = [
# 	IConversation.new(1, "Convo 1", [actors[0], actors[1]]), 
# 	IConversation.new(2, "Convo 2", [actors[0], actors[2]]),
# 	IConversation.new(3, "Convo 3", [actors[1], actors[2]]),
# ]

# var cues: Array[ICue] = [
# 	ICue.new(1, "Parent", convos[0].id, actors[0], 0, [], [], [], 40, 160), 
# 	ICue.new(2, "Child 1", convos[0].id, actors[1], 1, [], [], [], 440, 60),
# 	ICue.new(5, "Child 2", convos[0].id, actors[1], 1, [], [], [], 460, 320),
#     ICue.new(3, "Oh no!", convos[1].id, actors[2]),
#     ICue.new(4, "Oh yes!", convos[1].id, actors[2]),
# ]

# var varibales: Array[IVariable] = [
#     IVariable.new(1, "my_var_1", false),
#     IVariable.new(2, "my_var_2", false),
#     IVariable.new(3, "my_var_3", false),
#     IVariable.new(4, "my_var_4", false),
# ]

## TEMP

const database: DialogDatabase = preload(DATABASE_PATH)

func _ready() -> void:
    auto_save()


func get_conversations() -> Array[IConversation]:
    return database.conversations


func get_variables() -> Array[IVariable]:
    return database.variables


func get_variable_by_id(id: int) -> IVariable:
    for variable: IVariable in database.variables:
        if(variable.id == id):
            return variable
    
    return null


func create_new_condition() -> ICondition:
    return ICondition.new(uuid_util.v4(), null, false)
    

func create_new_action() -> IAction:
    return IAction.new(uuid_util.v4(), null, false)


func connect_cues(cue: ICue, parent: ICue) -> void:
    cue.parent_cue_id = parent.id


func diconnect_cues(cue: ICue) -> void:
    cue.parent_cue_id = 0


func get_conversation_by_id(id: int) -> IConversation:
    for convo: IConversation in database.conversations:
        if(convo.id == id):
            return convo
    
    return null


func get_cues_by_conversation(convo: IConversation) -> Array[ICue]:
    return database.cues.filter(
        func (cue: ICue) -> bool: return cue.convo_id == convo.id)


func get_cues_by_conversation_id(convoId: int) -> Array[ICue]:
    return database.cues.filter(
        func (cue: ICue) -> bool: return cue.convo_id == convoId)


func get_actors() -> Array[IActor]:
    return database.actors


func get_actors_by_conversation_id(convoId: int) -> Array[IActor]:
    var convo: IConversation = get_conversation_by_id(convoId)

    return convo.actors


func get_actor_by_id(actor_id: int) -> IActor:
    for actor: IActor in database.actors:
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
        GameManager.generate_next_id(database.cues), 
        "", 
        convo.id,
        actor,
        parent_id,
        # [],
        # [IAction.new("900ffaad-2beb-4b7f-a5ad-70130fa10752", varibales[0], true), IAction.new("900ffaad-2beb-4b7f-a5ad-70130fa10753", varibales[1], false)],
        # [ICondition.new("f3112eb1-a2b1-471b-b69d-fcc74368d395", varibales[2], false), ICondition.new("f3112eb1-a2b1-471b-b69d-fcc74368d396", varibales[3], true)],
        )
    
    database.cues.append(newCue)

    return newCue


func delete_cue(cue: ICue) -> void:
    database.cues.remove_at(database.cues.find(cue))


func attach_cue(parent: ICue, child: ICue) -> void:
    child.parent_cue_id = parent.id
    parent.child_cue_ids.append(child.id)


func auto_save() -> void:
    await get_tree().create_timer(auto_save_interval).timeout
    print("Saving database...")

    var result: Error = ResourceSaver.save(database)
    if(result == OK):
        print("Database saved successfully!")
        auto_save()
    else:
        print("Error saving database!")
        printerr(result)
        
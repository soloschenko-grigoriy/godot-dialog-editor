@tool
extends Node

const DATABASE_PATH: String = "res://game/dialog_manager/dialog_database.tres"
const database: DialogDatabase = preload(DATABASE_PATH)

const uuid_util = preload('res://addons/uuid/uuid.gd')
const auto_save_interval: float = 5.0

func _ready() -> void:
    # auto_save()
    pass


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
    var condition: ICondition = ICondition.new(uuid_util.v4(), -1, false)

    save()
    return condition
    

func create_new_action() -> IAction:
    var action: IAction = IAction.new(uuid_util.v4(), -1, false)
     
    save()

    return action


func connect_cues(cue: ICue, parent: ICue) -> void:
    cue.parent_cue_id = parent.id
    save()


func diconnect_cues(cue: ICue) -> void:
    cue.parent_cue_id = 0
    save()


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
    save()

    return newCue


func delete_cue(cue: ICue) -> void:
    database.cues.remove_at(database.cues.find(cue))
    save()


func attach_cue(parent: ICue, child: ICue) -> void:
    child.parent_cue_id = parent.id
    parent.child_cue_ids.append(child.id)
    save()


func auto_save() -> void:
    await get_tree().create_timer(auto_save_interval).timeout

    save()

    auto_save()
        

func save() ->void:
    print("Saving database...")

    var result: Error = ResourceSaver.save(database)
    if(result == OK):
        print("Database saved successfully!")
        pass
    else:
        print("Error saving database!")
        printerr(result)
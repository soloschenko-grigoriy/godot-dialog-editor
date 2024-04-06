@tool
extends Resource
class_name DialogDatabase

@export var conversations: Array[IConversation] = []
@export var actors: Array[IActor] = []
@export var variables: Array[IVariable] = []
var cues: Array[ICue] = []
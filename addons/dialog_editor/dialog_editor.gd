@tool
extends Panel
class_name DialogEditor

@onready var graph: GraphEdit = $Graph
@onready var menu_box: HBoxContainer = graph.get_menu_hbox()

var add_btn: AddButton
var choose_convo_btn: ChooseConversationButton
var current_conversation: IConversation = null
var last_added: Cue = null

var node: PackedScene = load("res://addons/dialog_editor/cue/cue.tscn")


func _ready() -> void:
	create_add_btn()
	create_choose_cono_btn()
	select_convo(0)

	graph.connection_request.connect(connect_cues)


func create_add_btn() -> void:
	add_btn = AddButton.new()
	graph.get_menu_hbox().add_child(add_btn)
	graph.get_menu_hbox().move_child(add_btn, 0)

	add_btn.pressed.connect(add_cue)


func create_choose_cono_btn() -> void:
	choose_convo_btn = ChooseConversationButton.new()
	menu_box.add_child(choose_convo_btn)
	menu_box.move_child(choose_convo_btn, 1)

	choose_convo_btn.item_selected.connect(select_convo)


func add_cue() -> Cue:
	if current_conversation == null:
		print("No conversation selected")
		return

	var cue: Cue = node.instantiate()
	var data: ICue = DialogManager.create_new_cue(current_conversation)

	cue.setup(data, self, last_added)
	graph.add_child(cue)

	last_added = cue

	return cue


func select_convo(index: int) -> void:
	var convo_id: int = choose_convo_btn.get_item_id(index)
	current_conversation = DialogManager.get_conversation_by_id(convo_id)

	clear_graph()


func clear_graph() -> void:
	for child: Node in graph.get_children():
		if child is Cue:
			delete_cue(child as Cue)
		else:
			graph.remove_child(child)
			child.queue_free()


func show_details_for(cue: ICue) -> void:
	print("Show details for cue: ", cue.id)
	pass


func hide_details_for(cue: ICue) -> void:
	print("Hide details for cue: ", cue.id)
	pass


func connect_cues(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph.connect_node(from_node, from_port, to_node, to_port);


func disconnect_cues(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph.disconnect_node(from_node, from_port, to_node, to_port);


func delete_cue(cue: Cue) -> void:
	if cue == last_added:
		last_added = null
		
	for connection in graph.get_connection_list():
		if connection["from_node"] == cue.get_name() or connection["to_node"] == cue.get_name():
			var from_node: StringName = connection["from_node"];
			var from_port: int = connection["from_port"];
			var to_node: StringName = connection["to_node"];
			var to_port:int = connection["to_port"];

			disconnect_cues(from_node, from_port, to_node, to_port)
	
	DialogManager.delete_cue(cue.data)
	graph.remove_child(cue)
	cue.queue_free()

@tool
extends Panel
class_name DialogEditor

@onready var graph: GraphEdit = $Graph
@onready var menu_box: HBoxContainer = graph.get_menu_hbox()

var add_btn: AddButton
var convo_name_line_edit: LineEdit
var convo_actor_1: OptionButton
var convo_actor_2: OptionButton
var choose_convo_btn: ChooseConversationButton
var current_conversation: IConversation = null
var last_added: Cue = null

var node: PackedScene = load("res://addons/dialog_editor/cue/cue.tscn")


func _ready() -> void:
	create_add_btn()
	create_choose_cono_btn()
	render_convo_name()
	render_convo_actors()
	select_convo(0)

	graph.connection_request.connect(connect_cues)
	convo_name_line_edit.text_changed.connect(update_convo_name)
	convo_actor_1.item_selected.connect(update_actor_1)
	convo_actor_2.item_selected.connect(update_actor_2)


func create_add_btn() -> void:
	add_btn = AddButton.new()
	graph.get_menu_hbox().add_child(add_btn)
	graph.get_menu_hbox().move_child(add_btn, 0)

	add_btn.pressed.connect(func () -> void: add_cue())


func create_choose_cono_btn() -> void:
	choose_convo_btn = ChooseConversationButton.new()
	menu_box.add_child(choose_convo_btn)
	menu_box.move_child(choose_convo_btn, 1)

	choose_convo_btn.item_selected.connect(select_convo)


func add_cue(parent: Cue = null) -> Cue:
	if current_conversation == null:
		print("No conversation selected")
		return

	var parent_id: int = parent.data.id if parent else 0
	var actor: IActor = DialogManager.get_conversant_by_conversation(current_conversation.id, parent.data.actor.id) if parent and parent.data.actor else null
	var data: ICue = DialogManager.create_new_cue(current_conversation, actor, parent_id)

	return render_cue(data)


func render_cue(data: ICue) -> Cue:
	var parent: Cue = get_parent_cue(data)
	var cue: Cue = node.instantiate()
	
	cue.setup(data, self, parent)
	graph.add_child(cue)

	if parent:
		connect_cues(parent.get_name(), 0, cue.get_name(), 0)
		#rearrange(parent, cue)

	return cue


func select_convo(index: int) -> void:
	var convo_id: int = choose_convo_btn.get_item_id(index)
	current_conversation = DialogManager.get_conversation_by_id(convo_id)

	convo_name_line_edit.text = current_conversation.title if current_conversation else ""

	var to_select_1: int = convo_actor_1.get_item_index(current_conversation.actors[0].id) if current_conversation.actors else 0
	convo_actor_1.select(to_select_1)

	var to_select_2: int = convo_actor_2.get_item_index(current_conversation.actors[1].id) if current_conversation.actors else 0
	convo_actor_2.select(to_select_2)

	clear_graph()
	load_cues()


func render_convo_name() -> void:
	convo_name_line_edit = LineEdit.new()
	convo_name_line_edit.placeholder_text = "Conversation name"
	convo_name_line_edit.custom_minimum_size.x = 200
	convo_name_line_edit.size.x = 200
	convo_name_line_edit.size.y = 10

	graph.get_menu_hbox().add_child(convo_name_line_edit)
	graph.get_menu_hbox().move_child(convo_name_line_edit, 2)


func render_convo_actors() -> void:
	convo_actor_1 = OptionButton.new()
	convo_actor_2 = OptionButton.new()

	for actor in DialogManager.get_actors():
		convo_actor_1.add_item(actor.name, actor.id)
		convo_actor_2.add_item(actor.name, actor.id)

	graph.get_menu_hbox().add_child(convo_actor_1)
	graph.get_menu_hbox().add_child(convo_actor_2)

	graph.get_menu_hbox().move_child(convo_actor_1, 3)
	graph.get_menu_hbox().move_child(convo_actor_2, 4)


func clear_graph() -> void:
	for child: Node in graph.get_children():
		if child is Cue:
			clear_cue_from_view(child as Cue)
		else:
			graph.remove_child(child)
			child.queue_free()


func connect_cues(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph.connect_node(from_node, from_port, to_node, to_port);


func disconnect_cues(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph.disconnect_node(from_node, from_port, to_node, to_port);


func delete_cue(cue: Cue) -> void:
	DialogManager.delete_cue(cue.data)
	clear_cue_from_view(cue)


func clear_cue_from_view(cue: Cue) -> void:
	if cue == last_added:
		last_added = null
		
	for connection in graph.get_connection_list():
		if connection["from_node"] == cue.get_name() or connection["to_node"] == cue.get_name():
			var from_node: StringName = connection["from_node"];
			var from_port: int = connection["from_port"];
			var to_node: StringName = connection["to_node"];
			var to_port:int = connection["to_port"];

			disconnect_cues(from_node, from_port, to_node, to_port)
	
	graph.remove_child(cue)
	cue.queue_free()


func rearrange(parent: Cue, child:Cue) -> void:
	var selected_nodes: Array[Cue] = []
	selected_nodes.append(parent)
	selected_nodes.append(child)

	for connection in graph.get_connection_list():
		if connection["from_node"] == parent.get_name():
			var n0: StringName = connection["to_node"]
			var n: NodePath = NodePath(n0)
			selected_nodes.append(graph.get_node(n))

	for cue: Cue in selected_nodes:
		cue.selected = true

	graph.arrange_nodes()

	for cue: Cue in selected_nodes:
		cue.selected = false


func load_cues() -> void:
	var cues: Array[ICue] = DialogManager.get_cues_by_conversation(current_conversation)

	for data: ICue in cues:
		render_cue(data)


func get_parent_cue(cue: ICue) -> Cue:
	var parent_id: int = cue.parent_cue_id

	if parent_id == 0:
		return null

	for child in graph.get_children():
		if child is Cue:
			var c: Cue = child as Cue
			if c.data.id == parent_id:
				return c

	return null


func update_convo_name(convo_name: String) -> void:
	if current_conversation == null:
		return

	current_conversation.title = convo_name
	choose_convo_btn.set_item_text(choose_convo_btn.selected, convo_name)


func update_actor_1(index: int) -> void:
	if current_conversation == null:
		return

	var actor_id: int = convo_actor_1.get_item_id(index)
	current_conversation.actors[0] = DialogManager.get_actor_by_id(actor_id)


func update_actor_2(index: int) -> void:
	if current_conversation == null:
		return

	var actor_id: int = convo_actor_2.get_item_id(index)
	current_conversation.actors[1] = DialogManager.get_actor_by_id(actor_id)

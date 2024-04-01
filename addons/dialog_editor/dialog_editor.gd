@tool
extends Panel
class_name DialogEditor

@onready var graph: GraphEdit = $Graph
@onready var menu_box: HBoxContainer = graph.get_menu_hbox()

var add_btn: AddButton
var choose_convo_btn: ChooseConversationButton
var current_conversation: IConversation = null

var node: PackedScene = load("res://addons/dialog_editor/cue/cue.tscn")


func _ready() -> void:
	create_add_btn()
	create_choose_cono_btn()
	select_convo(0)


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


func add_cue() -> void:
	if current_conversation == null:
		print("No conversation selected")
		return

	var cue: Cue = node.instantiate()
	cue.setup(DialogManager.create_new_cue(current_conversation), self)
	
	graph.add_child(cue)


func select_convo(index: int) -> void:
	var convo_id: int = choose_convo_btn.get_item_id(index)
	current_conversation = DialogManager.get_conversation_by_id(convo_id)

	clear_graph()


func clear_graph() -> void:
	for child: Node in graph.get_children():
		graph.remove_child(child)
		child.queue_free()


func show_details_for(cue: ICue) -> void:
	print("Show details for cue: ", cue.id)
	pass


func hide_details_for(cue: ICue) -> void:
	print("Hide details for cue: ", cue.id)
	pass

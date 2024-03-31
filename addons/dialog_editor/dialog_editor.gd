@tool
extends Panel

@onready var graph: GraphEdit = $Graph
@onready var menuBox: HBoxContainer = graph.get_menu_hbox()

var addBtn: AddButton
var chooseConvoBtn: ChooseConversationButton
var _index = 0

var node: PackedScene = load("res://addons/dialog_editor/entry/entry.tscn")
var data: Array[EntryResource] = [
	EntryResource.new(1, "Hello"), 
	EntryResource.new(2, "Hi")
]


func _ready() -> void:
	create_add_btn()
	create_choose_cono_btn()


func create_add_btn() -> void:
	addBtn = AddButton.new()
	graph.get_menu_hbox().add_child(addBtn)
	graph.get_menu_hbox().move_child(addBtn, 0)

	addBtn.pressed.connect(add_entry)


func create_choose_cono_btn() -> void:
	chooseConvoBtn = ChooseConversationButton.new()
	menuBox.add_child(chooseConvoBtn)
	menuBox.move_child(chooseConvoBtn, 1)

	chooseConvoBtn.item_selected.connect(select_convo)


func add_entry() -> void:
	var entry: Entry = node.instantiate()
	entry.data = data[_index]
	# entry.setup(data[_index])
	graph.add_child(entry)
	
	_index += 1


func select_convo(index: int) -> void:
	print("Selected conversation: ", index, " ", chooseConvoBtn.get_item_text(index))
	pass

@tool
extends GraphNode
class_name Cue

@onready var actors_btn: OptionButton = %Actors

@onready var textEdit: TextEdit = %TextEdit
@onready var collapsed_text: Label = %CollapsedText

@onready var collapsed_view: VBoxContainer = %CollapsedView
@onready var expanded_view: VBoxContainer = %ExpandedView

@onready var add_conditon_btn: Button = %AddConditionBtn
@onready var conditions_container: VBoxContainer = %ConditionsContainer

@onready var add_action_btn: Button = %AddActionBtn
@onready var actions_container: VBoxContainer = %ActionsContainer

@onready var delete_btn: Button = %DeleteBtn

var selectorTscn: PackedScene = preload("res://addons/dialog_editor/cue/selector/selector.tscn")

## Must be set before the node is added to tree
var data: ICue
var dialogEditor: DialogEditor

func _ready() -> void:
	if data == null:
		print("Cue not set")
		return

	collapsed_text.text = textEdit.text
	textEdit.text = data.text

	render_actors()
	collapse()
	add_next_btn()
	render_conditions()
	render_actions()

	set_slot(0, true, 0, Color(1, 1, 1, 1), true, 0, Color(1, 1, 1, 1))

	# Connect signals
	node_selected.connect(show_details)
	node_deselected.connect(hide_details)
	delete_btn.pressed.connect(delete)
	add_action_btn.pressed.connect(add_action)
	add_conditon_btn.pressed.connect(add_condition)


func setup(cue: ICue, editor: DialogEditor, last_cue: Cue = null) -> void:
	self.data = cue
	self.dialogEditor = editor
	
	add_offset(last_cue)
	

# func add_close_btn() -> void:
# 	var btn: Button = Button.new()
# 	btn.text = "X"
# 	btn.pressed.connect(delete)
# 	get_titlebar_hbox().add_child(btn)


func add_next_btn() -> void:
	var btn: Button = Button.new()
	btn.text = "Add"
	btn.pressed.connect(add_next)
	get_titlebar_hbox().add_child(btn)


func add_offset(last_cue: Cue = null) -> void:
	var last_pos: Vector2 = Vector2(0, 150)
	var last_size: Vector2 = Vector2(0, 0)

	if last_cue != null:
		last_pos = last_cue.position_offset
		last_size = last_cue.size

	var offsetX: float = last_pos.x + last_size.x + 50
	var offsetY: float = last_pos.y

	position_offset = Vector2(offsetX, offsetY)


func delete() -> void:
	dialogEditor.delete_cue(self)


func show_details() -> void:
	dialogEditor.show_details_for(data)
	expand()


func hide_details() -> void:
	dialogEditor.hide_details_for(data)
	collapse()
	

func add_next() -> void:
	var child: Cue = dialogEditor.add_cue()
	dialogEditor.connect_cues(get_name(), 0, child.get_name(), 0)


func collapse() -> void:
	collapsed_view.show()
	expanded_view.hide()

	size.y = 135


func expand() -> void:
	collapsed_view.hide()
	expanded_view.show()


func render_actors() -> void:
	actors_btn.clear()
	for actor in DialogManager.get_actors_by_conversation_id(data.convoId):
		actors_btn.add_item(actor.name, actor.id)

	actors_btn.select(0)


func render_conditions() -> void:
	for condition: ICondition in data.conditions:
		add_condition(condition.variable.id, condition.value)


func render_actions() -> void:
	for action: IAction in data.actions:
		add_action(action.variable.id, action.value)


func add_condition(id: int = -1, value: bool = false) -> void:
	conditions_container.add_child(init_selector(id, value))


func add_action(id: int = -1, value: bool = false) -> void:
	actions_container.add_child(init_selector(id, value))


func init_selector(id: int = -1, value: bool = false) -> Selector:
	var selector: Selector = selectorTscn.instantiate()
	selector.setup(id, value)

	return selector
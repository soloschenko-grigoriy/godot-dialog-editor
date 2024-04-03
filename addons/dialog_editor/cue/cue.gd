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

@export var expand_collpase_btn: PackedScene 
@export var selector_tscn: PackedScene

## Must be set before the node is added to tree
var data: ICue
var dialogEditor: DialogEditor
var is_collapsed: bool = true
var toggle_btn: ExpandCollpaseBtn

func _ready() -> void:
	if data == null:
		print("Cue not set")
		return

	collapsed_text.text = data.text if data.text else "..."
	textEdit.text = data.text

	render_actors()
	collapse()
	add_next_btn()
	render_conditions()
	render_actions()
	add_collapse_btn()

	set_slot(0, true, 0, Color(1, 1, 1, 1), true, 0, Color(1, 1, 1, 1))

	# Connect signals
	delete_btn.pressed.connect(delete)
	add_action_btn.pressed.connect(add_action)
	add_conditon_btn.pressed.connect(add_condition)
	textEdit.text_changed.connect(update_text)


func setup(cue: ICue, editor: DialogEditor, last_cue: Cue = null) -> void:
	self.data = cue
	self.dialogEditor = editor
	
	if data.position_x != 0 and data.position_y != 0:
		position_offset = Vector2(data.position_x, data.position_y)
	else:
		add_offset(last_cue)
	

func add_collapse_btn() -> void:
	toggle_btn = expand_collpase_btn.instantiate()
	toggle_btn.pressed.connect(toggle_collapse)
	get_titlebar_hbox().add_child(toggle_btn)


func update_text() -> void:
	data.text = textEdit.text
	collapsed_text.text = data.text if data.text else "..."


func add_next_btn() -> void:
	var btn: Button = Button.new()
	btn.text = "Add next"
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

	
func add_next() -> void:
	dialogEditor.add_cue(self)


func toggle_collapse() -> void:
	if is_collapsed:
		expand()
	else:
		collapse()


func collapse() -> void:
	is_collapsed = true

	collapsed_view.show()
	expanded_view.hide()

	size.y = 80


func expand() -> void:
	is_collapsed = false

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
	var selector: Selector = selector_tscn.instantiate()
	selector.setup(id, value)

	return selector

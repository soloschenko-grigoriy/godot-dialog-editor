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
@onready var confirm_popup: ConfirmationDialog = %ConfirmDelete

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
	actors_btn.item_selected.connect(update_actor)
	delete_btn.pressed.connect(show_confirm_delete)
	add_action_btn.pressed.connect(create_action)
	add_conditon_btn.pressed.connect(create_condition)
	textEdit.text_changed.connect(update_text)
	position_offset_changed.connect(update_position)
	confirm_popup.get_ok_button().pressed.connect(delete)
	confirm_popup.get_cancel_button().pressed.connect(hide_confirm_delete)


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

	DialogManager.save()


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


func hide_confirm_delete() -> void:
	confirm_popup.hide()


func show_confirm_delete() -> void:
	confirm_popup.popup_centered()


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

	for actor in DialogManager.get_actors_by_conversation_id(data.convo_id):
		actors_btn.add_item(actor.name, actor.id)

	var to_select: int = actors_btn.get_item_index(data.actor.id) if data.actor else 0
	actors_btn.select(to_select)


func render_conditions() -> void:
	for condition: ICondition in data.conditions:
		add_condition(condition.id, condition.variable_id, condition.value)


func render_actions() -> void:
	for action: IAction in data.actions:
		add_action(action.id, action.variable_id, action.value)


func create_condition() -> void:
	var condition: ICondition = DialogManager.create_new_condition()
	data.conditions.append(condition)
	add_condition(condition.id, -1, condition.value)


func create_action() -> void:
	var action: IAction = DialogManager.create_new_action()
	data.actions.append(action)
	add_action(action.id, -1, action.value)


func add_condition(condition_id: String, variable_id: int = -1, value: bool = false) -> void:
	var item: Selector = init_selector(condition_id, variable_id, value)
	conditions_container.add_child(item)

	item.id_selected.connect(update_condition)
	item.value_selected.connect(update_condition_value)


func add_action(action_id: String, id: int = -1, value: bool = false) -> void:
	var item: Selector = init_selector(action_id, id, value)
	actions_container.add_child(item)

	item.id_selected.connect(update_action)
	item.value_selected.connect(update_action_value)


func init_selector(item_id: String, variable_id: int = -1, value: bool = false) -> Selector:
	var selector: Selector = selector_tscn.instantiate()
	selector.setup(item_id, variable_id, value)

	return selector


func update_position() -> void:
	data.position_x = position_offset.x
	data.position_y = position_offset.y

	DialogManager.save()


func update_actor(index: int) -> void:
	var id: int = actors_btn.get_item_id(index)
	data.actor = DialogManager.get_actor_by_id(id)

	DialogManager.save()


func update_condition(id: String, selected_variable_id: int) -> void:
	for condition:ICondition in data.conditions:
		if condition.id == id:
			condition.variable_id = DialogManager.get_variable_by_id(selected_variable_id).id
			DialogManager.save()
			return


func update_action(id: String, selected_variable_id: int) -> void:
	for action:IAction in data.actions:
		if action.id == id:
			action.variable_id = DialogManager.get_variable_by_id(selected_variable_id).id
			DialogManager.save()
			return

	
func update_condition_value(id: String, selected_variable_value: bool) -> void:
	for condition:ICondition in data.conditions:
		if condition.id == id and condition.variable_id > 0:
			condition.value = selected_variable_value
			DialogManager.save()
			return

	


func update_action_value(id: String, selected_variable_value: bool) -> void:
	print("action", id, " ", selected_variable_value)
	for action:IAction in data.actions:
		if action.id == id and action.variable_id  > 0:
			action.value = selected_variable_value
			DialogManager.save()
			return

	
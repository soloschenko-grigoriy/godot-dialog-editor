@tool
extends GraphNode
class_name Cue

@onready var label: Label = $Label

## Must be set before the node is added to tree
var cue: ICue
var dialogEditor: DialogEditor

func _ready() -> void:
	if cue == null:
		print("Cue not set")
		return

	label.text = cue.text

	add_close_btn()
	set_slot(0, true, 0, Color(1, 1, 1, 1), true, 0, Color(1, 1, 1, 1))

	# Connect signals
	resize_request.connect(resize)
	node_selected.connect(show_details)
	node_deselected.connect(hide_details)


func setup(data: ICue, editor: DialogEditor) -> void:
	self.cue = data
	self.dialogEditor = editor
	
	add_offset()
	

func add_close_btn() -> void:
	var close_button: Button = Button.new()
	close_button.text = "X"
	close_button.pressed.connect(delete)
	get_titlebar_hbox().add_child(close_button)


func add_offset() -> void:
	var count: int = DialogManager.get_cues_by_conversation_id(cue.convoId).size()
	var offsetX: int = 50 + count * 50
	var offsetY: int = 50 + count * 50
	position_offset = Vector2(offsetX, offsetY)


func resize(new_min_size: Vector2) -> void:
	size = new_min_size


func delete() -> void:
	print("Delete cue")
	DialogManager.delete_cue(cue)
	queue_free()


func show_details() -> void:
	dialogEditor.show_details_for(cue)


func hide_details() -> void:
	dialogEditor.hide_details_for(cue)
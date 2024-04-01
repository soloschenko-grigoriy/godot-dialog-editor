@tool
extends GraphNode
class_name Entry

@onready var label: Label = $Label

## Must be set before the node is added to tree
var cue: ICue
var dialogEditor: DialogEditor

func _ready() -> void:
	if cue == null:
		print("Entry cue not set")
		return

	label.text = cue.text

	add_close_btn()

	# Connect signals
	resize_request.connect(resize)
	node_selected.connect(show_details)
	node_deselected.connect(hide_details)

func setup(data: ICue, editor: DialogEditor) -> void:
	self.cue = data
	self.dialogEditor = editor

func add_close_btn() -> void:
	var close_button: Button = Button.new()
	close_button.text = "X"
	close_button.pressed.connect(delete)
	get_titlebar_hbox().add_child(close_button)

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
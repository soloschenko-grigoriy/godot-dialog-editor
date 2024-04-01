@tool
extends GraphNode
class_name Cue

@onready var label: Label = $Label

## Must be set before the node is added to tree
var data: ICue
var dialogEditor: DialogEditor

func _ready() -> void:
	if data == null:
		print("Cue not set")
		return

	label.text = data.text

	add_next_btn()
	add_close_btn()
	set_slot(0, true, 0, Color(1, 1, 1, 1), true, 0, Color(1, 1, 1, 1))

	# Connect signals
	resize_request.connect(resize)
	node_selected.connect(show_details)
	node_deselected.connect(hide_details)


func setup(cue: ICue, editor: DialogEditor, last_cue: Cue = null) -> void:
	self.data = cue
	self.dialogEditor = editor
	
	add_offset(last_cue)
	

func add_close_btn() -> void:
	var btn: Button = Button.new()
	btn.text = "X"
	btn.pressed.connect(delete)
	get_titlebar_hbox().add_child(btn)


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


func resize(new_min_size: Vector2) -> void:
	size = new_min_size


func delete() -> void:
	dialogEditor.delete_cue(self)


func show_details() -> void:
	dialogEditor.show_details_for(data)


func hide_details() -> void:
	dialogEditor.hide_details_for(data)
	

func add_next() -> void:
	var child: Cue = dialogEditor.add_cue()
	dialogEditor.connect_cues(get_name(), 0, child.get_name(), 0)
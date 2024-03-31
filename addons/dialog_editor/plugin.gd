@tool
extends EditorPlugin

const AUTOLOAD_NAME = "DialogEditor"

## Constants
const PLUGIN_PATH = "res://addons/dialog_editor/"
const MAIN_PANEL =  preload(PLUGIN_PATH + "dialog_editor.tscn")
const MAIN_PANEL_ICON = preload(PLUGIN_PATH + "chat.svg")

## Variables
var main_panel_instance = null

## Lifecycle events
func _enter_tree() -> void:
	main_panel_instance = MAIN_PANEL.instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)

	_make_visible(false)

func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool) -> void:
	main_panel_instance.visible = visible

func _get_plugin_name() -> String:
	return "Dialogue Editor"

func _get_plugin_icon() -> Texture2D:
	# return EditorInterface.get_editor_theme().get_icon("ScriptCreateDialog", "EditorIcons")
	return MAIN_PANEL_ICON

func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()
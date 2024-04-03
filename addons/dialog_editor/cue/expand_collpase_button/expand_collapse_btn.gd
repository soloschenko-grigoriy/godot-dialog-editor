extends Button
class_name ExpandCollpaseBtn

@export var icon_expand: Texture2D
@export var icon_collapse: Texture2D

func _ready() -> void:
    pressed.connect(toggle_collapse)
    icon = icon_expand

func toggle_collapse() -> void:
    if icon == icon_collapse:
        icon = icon_expand 
    else:
        icon = icon_collapse
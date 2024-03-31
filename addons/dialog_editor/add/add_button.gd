extends Button
class_name AddButton

func _ready():
    self.pressed.connect(_on_pressed)
    print("Button ready!")

func _on_pressed():
    print("Button pressed!")
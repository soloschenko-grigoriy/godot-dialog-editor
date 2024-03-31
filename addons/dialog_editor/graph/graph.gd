extends GraphEdit

func _ready():
    var btn = AddButton.new()
    btn.text = "Add"    
    get_menu_hbox().add_child(btn)
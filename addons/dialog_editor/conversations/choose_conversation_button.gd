@tool
extends OptionButton
class_name ChooseConversationButton

@onready var data: Array[IConversation] = DialogManager.get_conversations()

func _ready() -> void:
    for data_item: IConversation in data:
        add_item(data_item.title, data_item.id)
@tool
extends Node


func generate_next_id(items: Array) -> int:
    if items.size() == 0:
        return 1

    return items.reduce(func (accum: int, item) -> int: return item.id if item.id > accum else accum, 0) + 1
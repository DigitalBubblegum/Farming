extends Node2D
@onready var player = $Objects/Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_tool_use(tool: int, pos: Vector2) -> void:
	print(tool,pos)

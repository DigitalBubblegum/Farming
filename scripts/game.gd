extends Node2D
@onready var player = $Objects/Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_tool_use(tool: int, pos: Vector2) -> void:
	var grid_pos = Vector2i(int(pos.x/16),int(pos.y/16))
	if tool == player.Tools.HOE:
		$Layers/GroundTileMapLayer.set_cells_terrain_connect([grid_pos],0,0)
	if tool == player.Tools.AXE:
		print('AXE')
	if tool == player.Tools.WATER:
		print('WATER')

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
		var cell = $Layers/GrassTileMapLayer.get_cell_tile_data(grid_pos) as TileData
		if(cell and cell.get_custom_data('usable')):
			$Layers/GroundTileMapLayer.set_cells_terrain_connect([grid_pos],0,0)
	if tool == player.Tools.AXE:
		for tree in get_tree().get_nodes_in_group('Trees'):
			if tree.position.distance_to(pos)<10:
				tree.hit()
	if tool == player.Tools.WATER:
		if $Layers/GroundTileMapLayer.get_cell_tile_data(grid_pos):
			$Layers/SolilWaterTileMapLayer.set_cell(grid_pos,0,Vector2i(randi_range(0,2),0))


func _on_player_seed_use(_seed: int, pos: Vector2) -> void:
	var grid_pos = Vector2i(int(pos.x/16),int(pos.y/16))
	var cell = $Layers/GroundTileMapLayer.get_cell_tile_data(grid_pos) as TileData
	if cell:
		print(grid_pos)

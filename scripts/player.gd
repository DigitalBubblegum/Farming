extends CharacterBody2D
var direction: Vector2
var speed: int = 100
@onready var move_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/ToolStateMachine/playback")
var can_move: bool = true
enum Tools {HOE, AXE, WATER}
var current_tool: Tools = Tools.HOE
var last_direction: Vector2
@export var tool_direction_offset:= 16
@export var tool_direction_x_offset: = 0
@export var tool_direction_y_offset: = 8
const tool_connection = {
	Tools.HOE : 'hoe',
	Tools.AXE: 'axe',
	Tools.WATER: 'water',
}
enum Seeds {CORN,TOMATO,PUMPKIN}
var current_seed: Seeds = Seeds.CORN
signal tool_use(tool:Tools, pos:Vector2)
signal seed_use(seed:Seeds,pos:Vector2)


func _physics_process(_delta: float) -> void:
	if can_move:
		get_input()
	if direction:
		last_direction = direction
	velocity = direction * speed * int(can_move)
	move_and_slide()
	animation()

func get_input():
	direction = Input.get_vector("left","right","up","down")
	if(Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward")):
		var tool_direction = Input.get_axis("tool_backward","tool_forward") as int
		current_tool = posmod(current_tool + tool_direction, Tools.size()) as Tools
	if(Input.is_action_just_pressed("action")):
		tool_state_machine.travel(tool_connection[current_tool])
		$AnimationTree.set("parameters/OneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		can_move = false
		if current_tool == Tools.HOE:
			await $AnimationTree.animation_finished
		#tool_use.emit(current_tool,position+last_direction*tool_direction_offset+Vector2(tool_direction_x_offset,tool_direction_y_offset))
		if(current_tool!=Tools.AXE):
			tool_use.emit(current_tool,position+last_direction*tool_direction_offset+Vector2(tool_direction_x_offset,0))
	if(Input.is_action_just_pressed("seed_toggle")):
		current_seed = posmod(current_seed+1,Seeds.size()) as Seeds
		print(current_seed)
	if(Input.is_action_just_pressed("plant")):
		print("planting")

func animation():
	if direction:
		move_state_machine.travel('move')
		var target_vector: Vector2 = Vector2(round(direction.x),round(direction.y))
		$AnimationTree.set("parameters/MoveStateMachine/move/blend_position",target_vector)
		$AnimationTree.set("parameters/MoveStateMachine/idle/blend_position",target_vector)
		for state in tool_connection.values():
			$AnimationTree.set("parameters/ToolStateMachine/"+state+"/blend_position",target_vector)
	else:
		move_state_machine.travel('idle')


func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	can_move = true

func axe_use():
	tool_use.emit(current_tool,position+last_direction*tool_direction_offset+Vector2(tool_direction_x_offset,0))

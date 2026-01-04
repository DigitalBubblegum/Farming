extends CharacterBody2D
var direction: Vector2
var speed: int = 500
@onready var move_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/MoveStateMachine/playback")
enum Tools {HOE, AXE, WATERINGCAN}
var current_tool: Tools = Tools.AXE

func _physics_process(_delta: float) -> void:
	get_input()
	animation()
	velocity = direction * speed
	move_and_slide()

func get_input():
	direction = Input.get_vector("left","right","up","down")
	if(Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward")):
		var tool_direction = Input.get_axis("tool_backward","tool_forward") as int
		current_tool = posmod(current_tool + tool_direction, Tools.size()) as Tools

func animation():
	if direction:
		move_state_machine.travel('move')
		var target_vector: Vector2 = Vector2(round(direction.x),round(direction.y))
		$AnimationTree.set("parameters/MoveStateMachine/move/blend_position",target_vector)
		$AnimationTree.set("parameters/MoveStateMachine/idle/blend_position",target_vector)
	else:
		move_state_machine.travel('idle')

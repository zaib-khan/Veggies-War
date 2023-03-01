extends ColorRect

export(String, MULTILINE) var instruction_text = "put text here"




func _ready():
	get_node("Label").text = instruction_text
	
	match name :
		"Run_instruction":
			$AnimatedSprite.play("demo_run")
		"Jump_instruction":
			$AnimatedSprite.play("demo_jump")
		"Dash_instruction":
			$AnimatedSprite.play("demo_dash")
		"Wall_jump_instruction":
			$AnimatedSprite.play("demo_wall_jump")
	

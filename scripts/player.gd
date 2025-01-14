extends CharacterBody2D

@export var speed = 100

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	$Sprite2D.flip_h = velocity.x < 0

func _physics_process(delta):
	get_input()
	move_and_slide()


func _on_area_2d_area_entered(area):
	get_tree().change_scene_to_file("res://scenes/room.tscn")
	
	pass # Replace with function body.

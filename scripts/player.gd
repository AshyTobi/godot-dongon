extends CharacterBody2D

@export var speed = 60

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	if Input.is_key_label_pressed(KEY_SHIFT):
		velocity *= 5
	$Sprite2D.flip_h = velocity.x < 0

func _physics_process(delta):
	get_input()
	move_and_slide()


func _on_area_2d_body_entered(body):
	var rect = $"../Area2D/CollisionShape2D".shape.get_rect()
	print(rect.position)
	print(rect.size)
	
	pass # Replace with function body.

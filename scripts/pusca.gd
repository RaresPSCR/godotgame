extends Node3D

var dropped = false

func _process(delta):
	if Input.is_action_pressed("e"):
		if dropped==false:
			var neww=load("res://scenes/weapons/rigidbody/pusca_rb.tscn")

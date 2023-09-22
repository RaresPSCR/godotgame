extends Node3D

var dropped = false

func _process(delta):
	if Input.is_action_just_pressed("e"):
		if dropped==false:
			var neww=preload("res://scenes/weapons/rigidbody/pusca_rb.tscn")
			var facing_direction = -get_parent().global_transform.basis.z
			neww=neww.instantiate()
			neww.position=get_parent().get_parent().position+Vector3(0.5,1.5,0)
			neww.linear_velocity = facing_direction.normalized() * 5
			get_parent().get_parent().get_parent().add_child(neww)
			queue_free()

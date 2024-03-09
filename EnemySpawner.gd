class_name spawnerNode
extends Node

var slime_scene = preload("res://scenes/enemies/slime.tscn")
var zombie_scene = preload("res://scenes/enemies/zombie.tscn")

# Called when the node enters the scene tree for the first time.
func spawn():
	var slime = slime_scene.instantiate()
	var zombie = zombie_scene.instantiate()
	slime.startIndex = 0
	zombie.startIndex = 1
	get_parent().add_child.call_deferred(slime)
	get_parent().add_child.call_deferred(zombie)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _unhandled_input(_event):
	if Input.is_action_just_pressed("space"):
		spawn()

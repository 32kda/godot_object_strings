@tool
extends EditorPlugin

func _enter_tree():	
	add_custom_type("ObjectString", "Node3D", ObjectString, preload("object_string.png"))

func _exit_tree():
	remove_custom_type("ObjectString")
	

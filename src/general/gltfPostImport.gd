@tool
extends EditorScenePostImport


# Called by the editor when a scene has this script set as the import script in the import tab.
func _post_import(scene: Node) -> Object:
	# Modify the contents of the scene upon import.
	checkChildren(scene, scene, scene.transform)
	#print(scene)
	#print(scene.get_children())
	return scene # Return the modified root node when you're done.


func checkChildren(node: Node3D, topLevel: Node, transform: Transform3D):
	for child in node.get_children():
		if child is MeshInstance3D or child is CollisionShape3D:
			if child is MeshInstance3D and child.get_surface_override_material_count() >= 256:
				push_warning(child.name + " Mesh may have too many surfaces: Surface count == " + str(child.get_surface_override_material_count()))
			child.owner = null
			node.remove_child(child)
			topLevel.add_child(child)
			child.transform = (transform * node.transform)
			child.owner = topLevel
		else:
			checkChildren(child, topLevel, transform * node.transform)
	if node != topLevel:
		node.queue_free()

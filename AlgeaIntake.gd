class_name AlgeaIntake extends IntakeArea


func _on_body_entered(body: Node3D) -> void:
	if body is Cargo:
		contacts.append(body)


func _on_body_exited(body: Node3D) -> void:
	if body is Cargo and contacts.has(body):
		contacts.remove_at(contacts.find(body))

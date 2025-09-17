class_name HatchIntake extends IntakeArea


func _on_body_entered(body: Node3D) -> void:
	if body is HatchPanel:
		contacts.append(body)


func _on_body_exited(body: Node3D) -> void:
	if body is HatchPanel and contacts.has(body):
		contacts.remove_at(contacts.find(body))

class_name CargoIntake extends IntakeArea


func _ready() -> void:
	body_entered.connect(addToContacts)
	body_exited.connect(removeFromContacts)

func addToContacts(body: Node3D) -> void:
	if body is Cargo:
		contacts.append(body)


func removeFromContacts(body: Node3D) -> void:
	if body is Cargo and contacts.has(body):
		contacts.remove_at(contacts.find(body))

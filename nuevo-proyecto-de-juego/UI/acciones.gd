extends Control

func _ready():
	cerrar_menu()

func abrir_Menu():
	for p in get_tree().get_nodes_in_group("Jugador"):
		p.get_node("Acciones").cerrar_menu()
	visible = true
	

func cerrar_menu():
	visible = false 


func _on_b_atacar_button_down() -> void:
	cerrar_menu()
	Manager.mostrar_seleccion()
	print("Atacar")


func _on_b_defender_button_down() -> void:
	cerrar_menu()
	print("Defender")


func _on_b_cerrar_button_down() -> void:
	cerrar_menu()

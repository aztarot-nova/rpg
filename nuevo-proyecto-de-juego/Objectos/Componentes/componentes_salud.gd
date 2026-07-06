extends Node
signal salud_cero()
signal daño_recibido()

@export var progress_bar : ProgressBar

var salud_maxima : float
var salud_actual : float
var sin_salud : bool = false

func recibir_daño(cantidad : float):
	if sin_salud:
		return
	salud_actual -= cantidad
	
	actualizar_progress_bar()
	
	if (salud_actual <= 0):
		emit_signal("salud_cero")
		sin_salud = true
	else:
		emit_signal("daño_recibido")


func actualizar_progress_bar():
	if  progress_bar:
		progress_bar.value = salud_actual / salud_maxima

extends Node
signal jugador_selecciona_enemigo()
signal ataque_iniciado()
var turno_jugador : bool = true
var puede_abrir_menu : bool = true

var personaje_seleccionado 
var personaje_objectivo 

var enemigos = []
var turno_enemigo : int = 0
var jugadores = []

var juego_finalizado : bool = false

func obtener_personajes():
	enemigos = get_tree().get_nodes_in_group("Enemigo")
	jugadores = get_tree().get_nodes_in_group("Jugador")
	
	if enemigos.size() == 0:
		print("El jugador Gano")
		juego_finalizado = true
	if jugadores.size() == 0:
		print("El Enemigo Gano")
		juego_finalizado = true

func cambiar_turno():
	turno_jugador = !turno_jugador
	print(turno_jugador)
	if turno_jugador == false:
		await get_tree().create_timer(1).timeout
		if juego_finalizado:
			return
		iniciar_turno_enemigo()

func mostrar_seleccion():
	puede_abrir_menu = false
	emit_signal("jugador_selecciona_enemigo")

func establecer_personaje(personaje):
	personaje_seleccionado = personaje

func establecer_objectivo(personaje):
	personaje_objectivo = personaje

func iniciar_ataque():
	emit_signal("ataque_iniciado")
	personaje_seleccionado.atacar_personaje(personaje_objectivo)

func defender_personaje():
	personaje_seleccionado.defenderse()

func iniciar_turno_enemigo():
	if turno_enemigo >= enemigos.size():
		turno_enemigo = 0
		
	var enemigo_actual = enemigos[turno_enemigo]
	print("Iniciar turno del enemigo: ",enemigo_actual.name)
	###funcion atacar
	establecer_personaje(enemigo_actual)
	establecer_objectivo(jugadores.pick_random())
	iniciar_ataque()
	
	turno_enemigo += 1
	

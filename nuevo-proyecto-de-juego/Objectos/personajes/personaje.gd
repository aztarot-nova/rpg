class_name Personaje extends CharacterBody2D

@export var data : PersonajeData
@onready var animacion: AnimatedSprite2D = $animacion
@onready var componente_salud: Node = $componenteSalud


var personaje_objectivo

var atacando : bool = false 

var posicion_incial : Vector2
var regresar_posicion : bool = false


const Velocidad = 600.0

func _ready():
	animacion.play("idle")
	posicion_incial = global_position
	
	componente_salud.salud_maxima = data.salud_Maxima
	componente_salud.salud_actual = data.salud_Maxima
	componente_salud.actualizar_progress_bar()
	
	if data.jugador == false:
		add_to_group("Enemigo")
		animacion.flip_h = true
		animacion.offset.x = 30.5
		Manager.connect("jugador_selecciona_enemigo", mostrar_seleccion)
		Manager.connect("ataque_iniciado", ocultar_seleccion)
	else:
		add_to_group("Jugador")

func _on_panel_gui_input(_event: InputEvent) -> void:
	if data.jugador:
		if Input.is_action_just_pressed("mouse_izquierdo") and Manager.puede_abrir_menu and Manager.turno_jugador:
			$Acciones.abrir_Menu()
			Manager.establecer_personaje(self)
	else:
		if Input.is_action_just_pressed("mouse_izquierdo") and $seleccionar.visible:
			Manager.establecer_objectivo(self)
			Manager.iniciar_ataque()

func _physics_process(_delta):
	if personaje_objectivo and atacando == false:
		var distancia = global_position.distance_to(personaje_objectivo.global_position)
		if distancia  > 150.0:
			var direccion = (personaje_objectivo.global_position - global_position).normalized()
			velocity = Velocidad * direccion
			move_and_slide()
			animacion.play("Correr")
		else:
			### atacar al enemigo
			atacando = true
			animacion.play("Ataque")
	if regresar_posicion:
		var distancia = global_position.distance_to(posicion_incial)
		if distancia > 1:
			var direccion = (posicion_incial - global_position).normalized()
			velocity = Velocidad * direccion
			move_and_slide()
			animacion.play("Correr")
		else:
			regresar_posicion = false
			animacion.play("idle")
			Manager.cambiar_turno()
			Manager.puede_abrir_menu = true
		

### Funciones generales
func atacar_personaje(target):
	personaje_objectivo = target
	
### acciones del enemigo
func mostrar_seleccion():
	$seleccionar.visible = true

func ocultar_seleccion():
	$seleccionar.visible = false

func _on_animacion_animation_finished() -> void:
	if animacion.animation == "Ataque":
		print("Hacer daño al personaje")
		personaje_objectivo.componente_salud.recibir_daño(data.daño)
		
		personaje_objectivo = null
		atacando = false
		regresar_posicion = true
		
		



	


func _on_componente_salud_daño_recibido() -> void:
	animacion.play("Dolor")


func _on_componente_salud_salud_cero() -> void:
	animacion.play("Muerte")
	if data.jugador:
		remove_from_group("Jugador")
	else:
		remove_from_group("Enemigo")
		Manager.obtener_personajes()

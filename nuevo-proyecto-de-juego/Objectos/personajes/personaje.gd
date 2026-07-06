extends CharacterBody2D
@export var Data : PersonajeData

@onready var animacion: AnimatedSprite2D = $animacion

const Velocidad = 300.0

func _ready():
	animacion.play("idle")

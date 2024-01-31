extends Node3D

@onready var universe:Universe = $Universe
@onready var player:Player = $Player

var stars_db:StarsDB

func _ready():
	stars_db = $Universe.stars_db
	var star:Star = stars_db.get_star_proper("Sirius")
	player.position = star.position


extends Node3D

@onready var universe:Universe = $Universe



func _ready():
	print(StarsDB.get_star_proper("Sirius"))


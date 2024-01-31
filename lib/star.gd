class_name Star extends Object

var id:int
var hip:int
var proper:String
var absmag:float
var ci:float
var position:Vector3
var lum:float

func _init(entry:Dictionary):
	id = entry["id"]
	hip = entry["hip"]
	proper = entry["proper"]
	absmag = entry["absmag"]
	ci = entry["ci"]
	position = Vector3(entry["x"], entry["y"], entry["z"])
	lum = entry["lum"]
	

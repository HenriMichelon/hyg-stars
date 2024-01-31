class_name StarsDB extends Object

# http://www.astronexus.com/hyg
const columns:Array[String] = [
	"id",		# The database primary key.
	"hip",		# The star's ID in the Hipparcos catalog, if known.
	"proper",	# A common name for the star, such as "Barnard's Star" or "Sirius"
	"absmag",	# The star's absolute visual magnitude (its apparent magnitude from a distance of 10 parsecs).
	"ci",		#  The star's color index (blue magnitude - visual magnitude), where known.
	"x",		# The Cartesian coordinates of the star, in a system based on the equatorial coordinates as seen from Earth. +X is in the direction of the vernal equinox (at epoch 2000), +Z towards the north celestial pole, and +Y in the direction of R.A. 6 hours, declination 0 degrees.
	"y",
	"z",
	"lum"		#  Star's luminosity as a multiple of Solar luminosity.
]
enum ColumnsType {
	TYPE_INT	= 0,
	TYPE_FLOAT	= 1,
	TYPE_STRING = 2
}
const columns_types:Array[ColumnsType] = [
	ColumnsType.TYPE_INT,
	ColumnsType.TYPE_INT,
	ColumnsType.TYPE_STRING,
	ColumnsType.TYPE_FLOAT,
	ColumnsType.TYPE_FLOAT,
	ColumnsType.TYPE_FLOAT,
	ColumnsType.TYPE_FLOAT,
	ColumnsType.TYPE_FLOAT,
	ColumnsType.TYPE_FLOAT
]

var stars : Array[Star] = []
var id_index : Dictionary = {}
var hip_index : Dictionary = {}
var proper_index : Dictionary = {}

func _init():
	_load()

func _convert():
	print("StarsDB : converting...")
	hyg_convert("res://assets/databases/sources/hygdata_v41.csv", "res://assets/databases/hygdata_v41.data")
	print("StarsDB : finished converting...")
	
func _load():
	print("StarsDB : loadind database...")
	hyg_load("res://assets/databases/hygdata_v41.data")
	print("StarsDB : finished loadind database, %s stars..." % str(stars.size()))

func get_star_id(id: int):
	if id in id_index:
		return stars[id_index[id]]
	return null

func get_star_hip(hip: String):
	if hip in hip_index:
		return stars[hip_index[hip]]
	return null

func get_star_proper(proper: String):
	if proper in proper_index:
		return stars[proper_index[proper]]
	return null
	
func hyg_load(file_path_in: String):
	var file = FileAccess.open(file_path_in, FileAccess.READ)
	var i = 0
	while not file.eof_reached():
		var entry: Dictionary = {}
		for index in columns.size():
			var value
			match (columns_types[index]):
				ColumnsType.TYPE_INT:
					value = file.get_32()
				ColumnsType.TYPE_FLOAT:
					value = file.get_float()
				ColumnsType.TYPE_STRING:
					value = file.get_pascal_string()
			if (file.eof_reached()):
				break
			entry[columns[index]] = value
			match (columns[index]):
				"id": id_index[value]  = i
				"hip": hip_index[value] = i
				"proper":
					if (not value.is_empty()):
						proper_index[value] = i
		if (entry.is_empty()):
			break
		stars.append(Star.new(entry))
		i += 1
	file.close()
	
func hyg_convert(file_path_in: String, file_path_out: String, delimiter: String = ","):
	var file_in = FileAccess.open(file_path_in, FileAccess.READ)
	var file_out = FileAccess.open(file_path_out, FileAccess.WRITE)
	var columns_index:Array[int] = [ -1, -1, -1, -1, -1, -1, -1, -1, -1 ]
	assert(columns_index.size() == columns.size())
	var file_column_index = 0
	for column_name in file_in.get_csv_line(delimiter):
		var index = columns.find(column_name)
		if (index > -1):
			columns_index[index] = file_column_index
		file_column_index += 1
	var i = 0
	while not file_in.eof_reached():
		var line: PackedStringArray = file_in.get_csv_line(delimiter)
		if line.size() <= 1:
			break
		for index in columns.size():
			var value = line[columns_index[index]]
			match (columns_types[index]):
				ColumnsType.TYPE_INT:
					file_out.store_32(value.to_int())
				ColumnsType.TYPE_FLOAT:
					file_out.store_float(value.to_float())
				ColumnsType.TYPE_STRING:
					file_out.store_pascal_string(value)
		i += 1
		print(i)
	file_in.close()
	file_out.close()




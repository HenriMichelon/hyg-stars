class_name Universe extends MultiMeshInstance3D

@export var player:Player
@export var celestial_coords: Vector3
@export var mag_limit : float = 8.0
@export var star_labels_visible: bool = true

var stars_db:StarsDB = StarsDB.new()

func _ready():
	generate_stars()
	var data = stars_db.stars
	for i in multimesh.instance_count:
		var star = stars_db.stars[i]
		var star_name = star.proper
		if not star_name:
			star_name = star.bf
		if (star_name):
			var label = Label3D.new()
			label.text = star_name
			label.billboard = 1
			label.transform = Transform3D(Basis(), Vector3(star.position.x, star.position.y + 0.11, star.position.z))
			$StarsLabels.add_child(label)
	star_labels_visible = $StarsLabels.visible

func generate_stars():
	multimesh.instance_count = stars_db.stars.size()
	print("Generating stars...")
	for i in multimesh.instance_count:
		var star = stars_db.stars[i]
		multimesh.set_instance_transform(i, Transform3D(Basis(), star.position))
		# Convert color index to temperature
		# https://en.wikipedia.org/wiki/Color_index#cite_note-PyAstronomy-6
		var color_index = star.ci
		var temperature = 4600 * ((1 / (0.92 * color_index + 1.7)) + (1 / (0.92 * color_index + 0.62)))
		
		# Temperature to RGB
		# https://tannerhelland.com/2012/09/18/convert-temperature-rgb-algorithm-code.html
		# and https://gist.github.com/petrklus/b1f427accdf7438606a6
		
		# TODO try vs the gaia sky algorithem
		# http://stackoverflow.com/questions/21977786/star-b-v-color-index-to-apparent-rgb-color
		# https://gitlab.com/langurmonkey/gaiasky/-/blob/master/core/src/gaiasky/util/color/ColorUtils.java#L394
		
		if temperature < 1000:
			temperature = 1000
		elif temperature > 40000:
			temperature = 40000
		
		var tmp_internal = temperature / 100.0
		
		var red = 0.0
		var green = 0.0
		var blue = 0.0
		
		# red 
		if tmp_internal <= 66:
			red = 255
		else:
			var tmp_red = 329.698727446 * pow(tmp_internal - 60, -0.1332047592)
			if tmp_red < 0:
				red = 0
			elif tmp_red > 255:
				red = 255
			else:
				red = tmp_red
		
		# green
		if tmp_internal <=66:
			var tmp_green = 99.4708025861 * log(tmp_internal) - 161.1195681661
			if tmp_green < 0:
				green = 0
			elif tmp_green > 255:
				green = 255
			else:
				green = tmp_green
		else:
			var tmp_green = 288.1221695283 * pow(tmp_internal - 60, -0.0755148492)
			if tmp_green < 0:
				green = 0
			elif tmp_green > 255:
				green = 255
			else:
				green = tmp_green
		
		# blue
		if tmp_internal >=66:
			blue = 255
		elif tmp_internal <= 19:
			blue = 0
		else:
			var tmp_blue = 138.5177312231 * log(tmp_internal - 10) - 305.0447927307
			if tmp_blue < 0:
				blue = 0
			elif tmp_blue > 255:
				blue = 255
			else:
				blue = tmp_blue
		multimesh.set_instance_color(i, Color(red/255.0 , green/255.0, blue/255.0))
		# X is abs magnitude, y relative
		multimesh.set_instance_custom_data(i, Color(star.absmag, star.lum, mag_limit))
	print("Finihed generating stars...")

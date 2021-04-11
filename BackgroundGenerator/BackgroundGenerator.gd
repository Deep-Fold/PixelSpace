extends Control

onready var background = $CanvasLayer/Background
onready var starstuff = $StarStuff
onready var nebulae = $Nebulae
onready var particles = $StarParticles
onready var planet_scene = preload("res://BackgroundGenerator/Planet.tscn")
onready var big_star_scene = preload("res://BackgroundGenerator/BigStar.tscn")

export (GradientTexture) var colorscheme
var space_objects = []

#func _ready():
#	_set_new_colors(colorscheme, background_color)

func generate_new():
	starstuff.material.set_shader_param("seed", rand_range(1.0, 10.0))
	starstuff.material.set_shader_param("pixels", rect_size.x)
	
	nebulae.material.set_shader_param("seed", rand_range(1.0, 10.0))
	nebulae.material.set_shader_param("pixels", rect_size.x)
	
	
	particles.speed_scale = 1.0
	particles.amount = 1
	particles.position = rect_size * 0.5
	particles.process_material.set_shader_param("emission_box_extents", Vector3(rect_size.x * 0.5, rect_size.y*0.5,1.0))
	
	var p_amount = (rect_size.x * rect_size.y) / 150
	particles.amount = randi()%(int(p_amount * 0.75)) + int(p_amount * 0.25)

	$PauseParticles.start()
	
	for o in space_objects:
		o.queue_free()
	space_objects = []
	
#	var star_amount = int(rect_size.x * rect_size.y) / 4000
	var star_amount = int(rect_size.x / 20)
	star_amount = max(star_amount, 1)
	for i in randi()%star_amount:
		_place_big_star()
	
	var planet_amount = 5#int(rect_size.x * rect_size.y) / 8000
	for i in randi()%planet_amount:
		_place_planet()

func _set_new_colors(new_scheme, new_background):
	colorscheme = new_scheme

	starstuff.material.set_shader_param("colorscheme", colorscheme)
	nebulae.material.set_shader_param("colorscheme", colorscheme)
	nebulae.material.set_shader_param("background_color", new_background)
	
	particles.process_material.set_shader_param("colorscheme", colorscheme)
	for o in space_objects:
		o.material.set_shader_param("colorscheme", colorscheme)

func _place_planet():
	var pos = Vector2(int(rand_range(10, rect_size.x - 10)), int(rand_range(10, rect_size.y - 10)))
	var scale = Vector2(1,1)*(rand_range(0.2, 0.7)*rand_range(0.5, 1.0)*rect_size.x*0.005)
	var planet = planet_scene.instance()
	planet.scale = scale
	planet.position = pos
	$PlanetContainer.add_child(planet)
	space_objects.append(planet)

func _place_big_star():
	var pos = Vector2(int(rand_range(0, rect_size.x)), int(rand_range(0, rect_size.y)))
	var star = big_star_scene.instance()
	star.position = pos
	$StarContainer.add_child(star)
	space_objects.append(star)

func _on_PauseParticles_timeout():
	particles.speed_scale = 0.0

func set_background_color(c):
	background.color = c
	nebulae.material.set_shader_param("background_color", c)

func toggle_dust():
	starstuff.visible = !starstuff.visible

func toggle_stars():
	$StarContainer.visible = !$StarContainer.visible
	particles.visible = !particles.visible

func toggle_nebulae():
	$Nebulae.visible = !$Nebulae.visible

func toggle_planets():
	$PlanetContainer.visible = !$PlanetContainer.visible

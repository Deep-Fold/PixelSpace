extends Control

onready var background = $CanvasLayer/Background
onready var starstuff = $StarStuff
onready var nebulae = $Nebulae
onready var particles = $StarParticles
onready var starcontainer = $StarContainer
onready var planetcontainer = $PlanetContainer
onready var planet_scene = preload("res://BackgroundGenerator/Planet.tscn")
onready var big_star_scene = preload("res://BackgroundGenerator/BigStar.tscn")

var should_tile = false
var reduce_background = false
var mirror_size = Vector2(200,200)

export (GradientTexture) var colorscheme
var planet_objects = []
var star_objects = []

#func _ready():
#	_set_new_colors(colorscheme, background_color)

func set_mirror_size(new):
	mirror_size = new

func toggle_tile():
	should_tile = !should_tile
	starstuff.material.set_shader_param("should_tile", should_tile)
	nebulae.material.set_shader_param("should_tile", should_tile)
	
	_make_new_planets()
	_make_new_stars()

func toggle_reduce_background():
	reduce_background = !reduce_background
	starstuff.material.set_shader_param("reduce_background", reduce_background)
	nebulae.material.set_shader_param("reduce_background", reduce_background)

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
	
	_make_new_planets()
	_make_new_stars()

func _make_new_stars():
	for s in star_objects:
		s.queue_free()
	star_objects = []
	
	var star_amount = int(rect_size.x / 20)
	star_amount = max(star_amount, 1)
	for i in randi()%star_amount:
		_place_big_star()
	
func _make_new_planets():
	for p in planet_objects:
		p.queue_free()
	planet_objects = []

	var planet_amount = 5#int(rect_size.x * rect_size.y) / 8000
	for i in randi()%planet_amount:
		_place_planet()

func _set_new_colors(new_scheme, new_background):
	colorscheme = new_scheme

	starstuff.material.set_shader_param("colorscheme", colorscheme)
	nebulae.material.set_shader_param("colorscheme", colorscheme)
	nebulae.material.set_shader_param("background_color", new_background)
	
	particles.process_material.set_shader_param("colorscheme", colorscheme)
	for p in planet_objects:
		p.material.set_shader_param("colorscheme", colorscheme)
	for s in star_objects:
		s.material.set_shader_param("colorscheme", colorscheme)

func _place_planet():
	var scale = Vector2(1,1)*(rand_range(0.2, 0.7)*rand_range(0.5, 1.0)*rect_size.x*0.005)
	
	var pos = Vector2()
	if (should_tile):
		var offs = scale.x * 100.0 * 0.5
		pos = Vector2(int(rand_range(offs, rect_size.x - offs)), int(rand_range(offs, rect_size.y - offs)))
	else:
		pos = Vector2(int(rand_range(0, rect_size.x)), int(rand_range(0, rect_size.y)))
	
	var planet = planet_scene.instance()
	planet.scale = scale
	planet.position = pos
	planetcontainer.add_child(planet)
	planet_objects.append(planet)

func _place_big_star():
	var pos = Vector2()
	if (should_tile):
		var offs = 10.0
		pos = Vector2(int(rand_range(offs, rect_size.x - offs)), int(rand_range(offs, rect_size.y - offs)))
	else:
		pos = Vector2(int(rand_range(0, rect_size.x)), int(rand_range(0, rect_size.y)))
	
	var star = big_star_scene.instance()
	star.position = pos
	starcontainer.add_child(star)
	star_objects.append(star)

func _on_PauseParticles_timeout():
	particles.speed_scale = 0.0

func set_background_color(c):
	background.color = c
	nebulae.material.set_shader_param("background_color", c)

func toggle_dust():
	starstuff.visible = !starstuff.visible

func toggle_stars():
	starcontainer.visible = !starcontainer.visible
	particles.visible = !particles.visible

func toggle_nebulae():
	$Nebulae.visible = !$Nebulae.visible

func toggle_planets():
	planetcontainer.visible = !planetcontainer.visible

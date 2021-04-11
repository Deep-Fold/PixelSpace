extends Sprite

func _ready():
	material = material.duplicate()
	var light_x = rand_range(0.0, 1.0)
	var light_y = rand_range(0.0, 1.0)
	material.set_shader_param("light_origin", Vector2(light_x, light_y))
	material.set_shader_param("seed", rand_range(1.0, 10.0))
	material.set_shader_param("pixels", int(scale.x*100))

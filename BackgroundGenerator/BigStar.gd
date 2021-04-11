extends Sprite

func _ready():
	texture = texture.duplicate()
	texture.region.position.x = (randi()%5)*25.0

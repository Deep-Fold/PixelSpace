extends Button

export (PoolColorArray) var colorscheme
onready var colorbutton_scene = preload("res://GUI/ColorPickerButton.tscn")

func _ready():
	for i in colorscheme.size():
		var b = ColorPickerButton.new()

		b.color = colorscheme[i]
		b.size_flags_horizontal = SIZE_EXPAND_FILL
		b.connect("color_changed", self, "_on_color_changed", [i])
		$HBoxContainer.add_child(b)

func _on_color_changed(color, index):
	colorscheme[index] = color
	get_tree().root.get_node("GUI").select_colorscheme(colorscheme)

func _on_Button_pressed():
	get_tree().root.get_node("GUI").select_colorscheme(colorscheme)

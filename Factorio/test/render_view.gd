extends SubViewportContainer

@onready var sub_viewport = $SubViewport

# Called when the node enters the scene tree for the first time.
func _ready():
	await RenderingServer.frame_post_draw
	sub_viewport.get_texture().get_image().save_png(r"user://test.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

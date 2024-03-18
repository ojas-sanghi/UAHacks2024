extends CanvasLayer

func fade():
	$AnimationPlayer.play("fade")
	await $AnimationPlayer.animation_finished

func go_to_scene(scene_path):
	await fade()
	get_tree().change_scene_to_file(scene_path)

func go_to_end_screen():
	# Switch instantly, don't fade in or whatever
	get_tree().change_scene_to_file("res://GameEnd.tscn")

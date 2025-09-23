extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

func play_anim(mine_time:float):
	animated_sprite_2d.sprite_frames.set_animation_speed("default", animated_sprite_2d.sprite_frames.get_frame_count("default") / mine_time)

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

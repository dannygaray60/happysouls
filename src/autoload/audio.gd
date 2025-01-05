extends Node

## ej musica interactiva
#func _ready() -> void:
	#play_bgm("town")
	#await get_tree().create_timer(4).timeout
	#play_bgm("town","high")
	#await get_tree().create_timer(4).timeout
	#play_bgm("town","low")

func play_sfx(sfx_name:String) -> void:
	get_node("SFX/"+sfx_name).play()
func stop_sfx(sfx_name:String) -> void:
	get_node("SFX/"+sfx_name).stop()

##TODO implementar fadeout/in para musica
func play_bgm(bgm_name:String,mode:String="") -> void:
	var BGM : AudioStreamPlayer = get_node("BGM/"+bgm_name)
	if BGM.playing == false:
		BGM.play()
	if mode != "":
		BGM.get_stream_playback().switch_to_clip_by_name(mode)

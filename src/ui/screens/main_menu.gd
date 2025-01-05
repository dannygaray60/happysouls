extends Control

func _ready() -> void:
	Audio.play_bgm("good_old_days")
	%BtnStart.grab_focus()
	$LblVersion.text = ProjectSettings.get_setting("application/config/version")

func _on_btn_pressed(opt:String) -> void:
	Audio.play_sfx("accept")
	match opt:
		"start":
			pass
		"options":
			pass
		"about":
			pass
		"exit":
			get_tree().quit()

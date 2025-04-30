extends Control


func _ready() -> void:
	$OptionsPane/MasterSetting/HSlider.value = AudioManager.volumes['master']
	$OptionsPane/MusicSetting/HSlider.value = AudioManager.volumes['sfx']
	$OptionsPane/SFXSetting/HSlider.value = AudioManager.volumes['music']
	MusicManager.play_music()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/tutorial_level_1.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})


func _on_en_button_pressed() -> void:
	TranslationServer.set_locale("en")
	%SFX.play()


func _on_fr_button_pressed() -> void:
	TranslationServer.set_locale("fr")
	%SFX.play()


func _on_settings_button_pressed() -> void:
	%ButtonsMenu.visible = false
	%OptionsPane.visible = true
	%TitleContainer.visible = false
	%SFX.play()

func _on_save_button_pressed() -> void:
	%ButtonsMenu.visible = true
	%OptionsPane.visible = false
	%TitleContainer.visible = true
	%SFX.play()


func _on_level_buttons_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels_selection.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})
	%SFX.play()



func _on_h_slider_master_value_changed(value: float) -> void:
	AudioManager.change_volume(AudioManager.AUDIO_BUSES.Master, value)


func _on_h_slider_music_value_changed(value: float) -> void:
	AudioManager.change_volume(AudioManager.AUDIO_BUSES.Music, value)


func _on_h_slider_sfx_value_changed(value: float) -> void:
	AudioManager.change_volume(AudioManager.AUDIO_BUSES.SFX, value)

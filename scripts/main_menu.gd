extends Control


func _ready() -> void:
	MusicManager.play_music()

	$OptionsPane/MasterSetting/HSlider.value = AudioManager.volumes['master']
	$OptionsPane/MusicSetting/HSlider.value = AudioManager.volumes['sfx']
	$OptionsPane/SFXSetting/HSlider.value = AudioManager.volumes['music']
	


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	MusicManager.stop_music()
	SceneManager.change_scene("res://scenes/storyteller_scene.tscn", {
		"speed": 5,
		"pattern": "scribbles",
		"language": TranslationServer.get_locale() 
	})



func _on_en_button_pressed() -> void:
	TranslationServer.set_locale("en")
	MusicManager.play_sfx()


func _on_fr_button_pressed() -> void:
	TranslationServer.set_locale("fr")
	MusicManager.play_sfx()


func _on_settings_button_pressed() -> void:
	%ButtonsMenu.visible = false
	%OptionsPane.visible = true
	%TitleContainer.visible = false
	MusicManager.play_sfx()

func _on_save_button_pressed() -> void:
	%ButtonsMenu.visible = true
	%OptionsPane.visible = false
	%TitleContainer.visible = true
	MusicManager.play_sfx()


func _on_level_buttons_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels_selection.tscn", {
		"speed": 5,
		"pattern": "scribbles",
	})
	MusicManager.play_sfx()



func _on_h_slider_master_value_changed(value: float) -> void:
	AudioManager.change_volume(AudioManager.AUDIO_BUSES.Master, value)


func _on_h_slider_music_value_changed(value: float) -> void:
	AudioManager.change_volume(AudioManager.AUDIO_BUSES.Music, value)


func _on_h_slider_sfx_value_changed(value: float) -> void:
	AudioManager.change_volume(AudioManager.AUDIO_BUSES.SFX, value)

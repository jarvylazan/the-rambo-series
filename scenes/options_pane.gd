extends Panel

func _ready() -> void:
	# Load saved settings into sliders
	$MasterSetting/HSlider.value = SettingsManager.volume_master
	$MusicSetting/HSlider.value = SettingsManager.volume_music
	$SFXSetting/HSlider.value = SettingsManager.volume_sfx

	# Apply audio settings
	AudioManager.change_volume(AudioManager.AUDIO_BUSES.Master, SettingsManager.volume_master)
	AudioManager.change_volume(AudioManager.AUDIO_BUSES.Music, SettingsManager.volume_music)
	AudioManager.change_volume(AudioManager.AUDIO_BUSES.SFX, SettingsManager.volume_sfx)

func _on_en_button_pressed() -> void:
	MusicManager.play_sfx()
	TranslationServer.set_locale("en")
	SettingsManager.current_language = "en"
	SettingsManager.save_settings()
	

func _on_fr_button_pressed() -> void:
	MusicManager.play_sfx()
	TranslationServer.set_locale("fr")
	SettingsManager.current_language = "fr"
	SettingsManager.save_settings()
	

func _on_h_slider_master_value_changed(value: float) -> void:
	AudioManager.change_volume(AudioManager.AUDIO_BUSES.Master, value)
	SettingsManager.volume_master = value

func _on_h_slider_music_value_changed(value: float) -> void:
	AudioManager.change_volume(AudioManager.AUDIO_BUSES.Music, value)
	SettingsManager.volume_music = value

func _on_h_slider_sfx_value_changed(value: float) -> void:
	AudioManager.change_volume(AudioManager.AUDIO_BUSES.SFX, value)
	SettingsManager.volume_sfx = value

func _on_save_button_pressed() -> void:
	MusicManager.play_sfx()
	SettingsManager.save_settings()
	
	visible = false  # hide OptionsPane
	if has_node("%ButtonsMenu") and has_node("%TitleContainer"):
		%ButtonsMenu.visible = true
		%TitleContainer.visible = true
	elif get_parent().has_node("Panel/VBoxContainer"):
		get_parent().get_node("Panel/VBoxContainer").visible = true
	

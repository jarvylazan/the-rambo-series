extends Node

const SETTINGS_PATH := "user://game_settings.save"

var volume_master: float = 0.5
var volume_music: float = 0.5
var volume_sfx: float = 0.5
var current_language: String = "en"
var fullscreen := false

func _ready():
	load_settings()
	apply_settings()

func save_settings():
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		var data = {
			"volume_master": volume_master,
			"volume_music": volume_music,
			"volume_sfx": volume_sfx,
			"language": current_language,
			"fullscreen": fullscreen
		}
		file.store_var(data)
		file.close()
		print("Settings saved.")

func load_settings():
	if FileAccess.file_exists(SETTINGS_PATH):
		var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		if file:
			var data = file.get_var()
			volume_master = data.get("volume_master", 0.5)
			volume_music = data.get("volume_music", 0.5)
			volume_sfx = data.get("volume_sfx", 0.5)
			current_language = data.get("language", "en")
			fullscreen = data.get("fullscreen", false)
			
			file.close()
			print(" Settings loaded.")
	else:
		print("No save file found, using default settings.")

func apply_settings():
	# Apply audio levels (assuming AudioManager is available)
	if Engine.has_singleton("AudioManager"):
		var am = Engine.get_singleton("AudioManager")
		am.change_volume(am.AUDIO_BUSES.Master, volume_master)
		am.change_volume(am.AUDIO_BUSES.Music, volume_music)
		am.change_volume(am.AUDIO_BUSES.SFX, volume_sfx)

	# Apply language
	TranslationServer.set_locale(current_language)
	
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED
	)

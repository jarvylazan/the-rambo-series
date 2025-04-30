extends Node

@onready var music_player := $MusicPlayer
@onready var sfx_player := $SFXPlayer

func play_music():
	if not music_player.playing:
		music_player.play()

func stop_music():
	music_player.stop()

func set_volume(volume: float):
	music_player.volume_db = linear_to_db(clamp(volume, 0.0, 1.0))

func play_sfx():
	if sfx_player.playing:
		sfx_player.stop()
	sfx_player.play()

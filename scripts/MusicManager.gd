extends Node

@onready var music_player := $MusicPlayer
@onready var sfx_player := $SFXPlayer

func play_music():
	if not music_player.playing:
		music_player.play()

func stop_music():
	music_player.stop()

func play_sfx():
	if sfx_player.playing:
		sfx_player.stop()
	sfx_player.play()

extends Node2D


@onready var music_player := $MusicPlayer
@onready var sfx_player := $SFXPlayer
@onready var spear_sfx := $SpearSFX
@onready var gun_sfx := $GunSFX
@onready var enemy_death_sfx := $EnemyDeathSFX



func play_music():
	if not music_player.playing:
		music_player.play()

func stop_music():
	music_player.stop()

func play_sfx():
	if sfx_player.playing:
		sfx_player.stop()
	sfx_player.play()


func play_spear():
	if spear_sfx.playing:
		spear_sfx.stop()
	spear_sfx.play()

func play_gun():
	if gun_sfx.playing:
		gun_sfx.stop()
	gun_sfx.play()
	
func play_enemy_death():
	if enemy_death_sfx.playing:
		enemy_death_sfx.stop()
	enemy_death_sfx.play()

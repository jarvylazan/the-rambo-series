extends Node

enum AUDIO_BUSES {
	Master,
	SFX,
	Music,
}

var volumes := {
	'master': 1.0,  # Linear scale 0-1, not dB
	'sfx': 1.0,
	'music': 1.0,
}

func change_volume(audio_bus: AUDIO_BUSES, value: float):
	
	match audio_bus:
		AUDIO_BUSES.Master:
			volumes['master'] = clamp(value, 0,1)  
		AUDIO_BUSES.SFX:
			volumes['sfx'] = clamp(value, 0, 1)
		AUDIO_BUSES.Music:
			volumes['music'] = clamp(value, 0, 1)
	apply_volumes()

func apply_volumes():
	AudioServer.set_bus_volume_db(AUDIO_BUSES.Master, linear_to_db(volumes['master']))
	AudioServer.set_bus_volume_db(AUDIO_BUSES.SFX, linear_to_db(volumes['sfx']))
	AudioServer.set_bus_volume_db(AUDIO_BUSES.Music, linear_to_db(volumes['music']))

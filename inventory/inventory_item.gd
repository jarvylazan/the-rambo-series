extends Resource
class_name InvItem

@export var name: String
@export var texture: Texture2D
@export var description: String = ""
@export var stackable: bool = true
@export_enum("common", "rare", "unique", "legendary") var rarity: String = "common"


# NEW: Unique key ID for portal logic (optional)
@export var key_id: String = ""

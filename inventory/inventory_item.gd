extends Resource
class_name InvItem

@export var name: String
@export var texture: Texture2D
@export var description: String = ""
@export var stackable: bool = true

# ✅ NEW: Unique key ID for portal logic (optional)
@export var key_id: String = ""

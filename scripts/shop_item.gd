extends Resource
class_name ShopItem

@export var id: String
@export var name: String
@export var description: String
@export var price: int
@export var icon: Texture2D
@export var item_type: String  # "attack", "health", "ability" 
@export var is_purchased: bool = false

# Pour les attaques
@export var attack_animation: String
@export var attack_damage: int
@export var attack_input: String  # ex: "attack2", "attack3"

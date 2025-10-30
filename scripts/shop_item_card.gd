extends Panel

signal purchase_requested(item: ShopItem)

var icon: TextureRect
var name_label: Label
var description_label: RichTextLabel
var price_label: Label
var purchase_button: Button
var status_label: Label


var item: ShopItem

func _ready() -> void:
	icon = $VBoxContainer/Icon
	name_label = $VBoxContainer/Name
	description_label = $VBoxContainer/Description
	price_label = $VBoxContainer/PriceContainer/PriceLabel
	purchase_button = $VBoxContainer/PurchaseButton
	status_label = $VBoxContainer/Status
	
	if item:
		_apply_item_data()
	
func setup(shop_item: ShopItem):
	item = shop_item
	
	if is_node_ready():
		_apply_item_data()

func _apply_item_data():
	if not item:
		return
	
	if item.icon:
		icon.texture = item.icon
	
	
	name_label.text = item.name
	description_label.text = item.description
	price_label.text = str(item.price)
	
	if not purchase_button.pressed.is_connected(_on_purchase_pressed):
		purchase_button.pressed.connect(_on_purchase_pressed)
	
	update_appearance()


func update_appearance():
	if not item:
		return
		
	if item.is_purchased:
		purchase_button.visible = false
		status_label.visible = true
		status_label.text = "✓ DONE"
		modulate = Color(0.7, 0.7, 0.7)
	else:
		purchase_button.visible = true
		status_label.visible = false
		
		if GameManager.coins >= item.price:
			purchase_button.disabled = false
		else:
			purchase_button.disabled = true

func _on_purchase_pressed():
	emit_signal("purchase_requested", item)

extends CharacterBody2D
class_name Player # Bu çok önemli, engelin bizi tanımasını sağlıyor

@export var yercekimi: float = 1200.0
@export var ziplama_gucu: float = -450.0


var oldu: bool = false 

func _ready():
	Global.oyun_basladi = false
	# 1. Globalden özel resmi, boyutu ve DARALTMA payını al
	var resim_yolu = Global.secilen_karakter["resim"]
	var hedef_yukseklik = Global.secilen_karakter["boyut"]
	var daraltma = Global.secilen_karakter.get("hitbox_daraltma", Vector2(1.0, 1.0))
	
	$Sprite2D.texture = load(resim_yolu)
	
	# 2. Her Karaktere Özel Dinamik Hacim
	var resim_yuksekligi = $Sprite2D.texture.get_height()
	var yeni_olcek = float(hedef_yukseklik) / float(resim_yuksekligi)
	$Sprite2D.scale = Vector2(yeni_olcek, yeni_olcek)
	
	# 3. Hitbox'ı Kırpılmış Haliyle Ayarla
	var shape = $CollisionShape2D.shape
	if shape is RectangleShape2D:
		# Resmin boyutunu ölçekle çarp, sonra da daraltma oranımızla çarpıp hitbox'ı cillop gibi yap!
		shape.size = ($Sprite2D.texture.get_size() * yeni_olcek) * daraltma

func _physics_process(delta):
	if oldu: return 
	
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# Tıkladığımızda GLOBAL şalteri kaldırıyoruz
		if not Global.oyun_basladi:
			Global.oyun_basladi = true
		velocity.y = ziplama_gucu
	
	# GLOBAL şaltere bakıyoruz
	if not Global.oyun_basladi:
		velocity.y = 0
		return
		
	velocity.y += yercekimi * delta
	move_and_slide()
	rotation = deg_to_rad(velocity.y * 0.05)

func carpisma_oldu():
	if oldu: return
	oldu = true
	
	# 1. Kıvılcım
	var kivilcim_sahne = load("res://Scenes/kivilcim.tscn")
	var patlama = kivilcim_sahne.instantiate()
	get_parent().add_child(patlama)
	patlama.global_position = self.global_position
	
	# 2. Zamanı Yavaşlat (Hit-Stop efekti)
	Engine.time_scale = 0.1 
	
	# 3. Gerçek dünyada 0.5 saniye bekle (Donmadan etkilenmemesi için son parametre 'true')
	await get_tree().create_timer(0.5, true, false, true).timeout
	
	# 4. Zamanı normale döndür ve "Oyun Bitti" emrini şimdi yolla!
	Engine.time_scale = 1.0 
	get_tree().call_group("merkez", "oyunu_bitir")

extends CharacterBody2D

# --- FİZİK AYARLARI ---
@export var yercekimi: float = 1200.0
@export var ziplama_gucu: float = -450.0

# Oyunun başlayıp başlamadığını kontrol eden şalter
var oyun_basladi: bool = false
var oldu: bool = false # Oyunun bitip bitmediğini takip eder

func _ready():
	# --- GÖRSEL VE HACİM OTOMASYONU ---
	
	# 1. Globalden seçilen resmi alıp Sprite'a giydir
	if Global.secilen_karakter_resmi != "":
		$Sprite2D.texture = load(Global.secilen_karakter_resmi)
	
	# 2. Boyutu (Scale) ayarla (Dirençle aynı hacme getirme)
	var hedef_yukseklik = 25.0
	var resim_yuksekligi = $Sprite2D.texture.get_height()
	var yeni_olcek = hedef_yukseklik / resim_yuksekligi
	$Sprite2D.scale = Vector2(yeni_olcek, yeni_olcek)
	
	# 3. COLLISION SHAPE'İ OTOMATİK AYARLA (Hitbox Koruması)
	var shape = $CollisionShape2D.shape
	if shape is RectangleShape2D:
		var yeni_boyut = $Sprite2D.texture.get_size() * yeni_olcek
		shape.size = yeni_boyut

func _physics_process(delta):
	if oldu: return # Eğer öldüysek kodun geri kalanını çalıştırma
	
	# --- ZIPLAMA VE OYUNU BAŞLATMA ---
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not oyun_basladi:
			oyun_basladi = true
		
		velocity.y = ziplama_gucu
	
	# --- YERÇEKİMİ ---
	if not oyun_basladi:
		velocity.y = 0
		return
		
	velocity.y += yercekimi * delta
	
	move_and_slide()
	
	# Görsel Şölen: Karakter zıplarken burnu havaya kalkar, düşerken yere eğilir
	rotation = deg_to_rad(velocity.y * 0.05)

# --- ÇARPIŞMA (GAME OVER) FONKSİYONU ---
# Bu fonksiyonu, engelin (Engel.gd) içinden çağıracağız
func carpisma_oldu():
	if oldu: return
	oldu = true
	
	# 1. Kıvılcım Efektini Çarpışma Yerinde Oluştur
	var kivilcim_sahne = load("res://Scenes/kivilcim.tscn")
	var patlama = kivilcim_sahne.instantiate()
	get_parent().add_child(patlama)
	patlama.global_position = self.global_position
	
	# 2. Zamanı Yavaşlat (Hit-Stop efekti)
	Engine.time_scale = 0.2
	await get_tree().create_timer(0.5).timeout
	Engine.time_scale = 1.0 # Zamanı normale döndür
	
	# 3. Game Over Sinyali (İleride Game Over menüsünü açacağız)
	print("Game Over! Kıvılcım ve donma efekti bitti.")

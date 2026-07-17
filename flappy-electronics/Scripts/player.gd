extends CharacterBody2D

var yercekimi = 1500.0
var ziplama_gucu = -500.0

func _physics_process(delta):
	velocity.y += yercekimi * delta
	move_and_slide()
	
	# YENİ EKLEDİĞİMİZ HAYATİ KONTROL:
	if is_on_floor() or is_on_ceiling():
		if is_on_floor() or is_on_ceiling():
			get_tree().call_group("merkez", "oyunu_bitir")

func _input(event):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or (event is InputEventScreenTouch and event.pressed):
		velocity.y = ziplama_gucu

func _ready():
	# 1. Resmi giydir
	$Sprite2D.texture = load(Global.secilen_karakter_resmi)
	
	# 2. Boyutu (Scale) ayarla (Dirençle aynı hacme getirme)
	var hedef_yukseklik = 50.0
	var resim_yuksekligi = $Sprite2D.texture.get_height()
	var yeni_olcek = hedef_yukseklik / resim_yuksekligi
	$Sprite2D.scale = Vector2(yeni_olcek, yeni_olcek)
	
	# 3. COLLISION SHAPE'İ OTOMATİK AYARLA (Mühendislik Harikası)
	# CollisionShape2D düğümünün adının "CollisionShape2D" olduğunu varsayıyorum
	var shape = $CollisionShape2D.shape
	
	if shape is RectangleShape2D:
		# Resmin gerçek genişliğini ve yüksekliğini alıp hitbox'ı ona uyduruyoruz
		var yeni_boyut = $Sprite2D.texture.get_size() * yeni_olcek
		shape.size = yeni_boyut

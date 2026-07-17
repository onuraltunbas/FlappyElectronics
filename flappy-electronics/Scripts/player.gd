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
	# Globalden resmi alıp giydir
	$Sprite2D.texture = load(Global.secilen_karakter_resmi)
	
	# OTOMATİK HACİM SABİTLEYİCİ (Hitbox Koruması)
	# Hangi resim gelirse gelsin, yüksekliğini "25" piksel civarına (direncin boyutuna) sabitler
	var resim_yuksekligi = $Sprite2D.texture.get_height()
	var hedef_yukseklik = 25.0 # Senin orjinal direncinin oyundaki yaklaşık yüksekliği
	
	var yeni_olcek = hedef_yukseklik / resim_yuksekligi
	$Sprite2D.scale = Vector2(yeni_olcek, yeni_olcek)

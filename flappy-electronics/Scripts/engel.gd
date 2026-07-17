extends Area2D

var hiz = 300.0

func _ready():
	# Çarpışma (kısa devre) sensörünü bağla
	body_entered.connect(_kisa_devre)
	# Lazer (puan) sensörünü bağla
	$Lazer.body_entered.connect(_lazer_kesildi)

func _process(delta):
	# Engeli her saniye sola doğru kaydır
	position.x -= hiz * delta
	
	# Ekranın solundan tamamen çıkınca RAM'den temizle
	if position.x < -200:
		queue_free()

# Çarpışma anı: Merkeze "Oyunu Bitir" emrini gönder ve EFEKTLERİ PATLAT
func _kisa_devre(body):
	if body is Player: # Eğer çarpan şey Player sınıfındansa
		
		# 1. Player'daki kıvılcım ve donma efektini tetikle
		body.carpisma_oldu()
		
		# 2. Ana sahneye (MainGame) "Oyun Bitti" sinyalini yolla
		get_tree().call_group("merkez", "oyunu_bitir")
		
		# 3. Çarptıktan sonra engel dursun (Karakterin içinden geçip gitmesin)
		set_process(false)

# Lazer kesilme anı: Merkeze "Puan Arttır" emrini gönder
func _lazer_kesildi(body):
	if body is Player:
		get_tree().call_group("merkez", "puan_arttir")

# Kapı aralığını ayarlayan mühendislik fonksiyonu
func aralik_ayarla(tam_mesafe: float):
	# 1. Gelen toplam boşluğu (örn: 600) gerçek yarı mesafeye (300) çeviriyoruz
	var yari_mesafe = tam_mesafe / 2.0
	
	# 2. Havya (Üst Engel)
	$SpriteUst.position.y = -yari_mesafe - 521.0
	$CollisionUst.position.y = -yari_mesafe - 521.0
	
	# 3. Prob (Alt Engel)
	$SpriteAlt.position.y = yari_mesafe + 541.0
	$CollisionAlt.position.y = yari_mesafe + 541.0

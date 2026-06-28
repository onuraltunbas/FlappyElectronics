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

# Çarpışma anı: Merkeze "Oyunu Bitir" emrini gönder
func _kisa_devre(body):
	if body.name == "Player":
		get_tree().call_group("merkez", "oyunu_bitir")

# Lazer kesilme anı: Merkeze "Puan Arttır" emrini gönder
func _lazer_kesildi(body):
	if body.name == "Player":
		get_tree().call_group("merkez", "puan_arttir")

# Kapı aralığını ayarlayan mühendislik fonksiyonu
func aralik_ayarla(yari_mesafe: float):
	$SpriteUst.position.y = -yari_mesafe
	$CollisionUst.position.y = -yari_mesafe
	$SpriteAlt.position.y = yari_mesafe
	$CollisionAlt.position.y = yari_mesafe

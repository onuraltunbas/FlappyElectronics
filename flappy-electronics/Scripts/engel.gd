extends Area2D

var hiz = 300.0

func _ready():
	body_entered.connect(_kisa_devre)
	$Lazer.body_entered.connect(_lazer_kesildi)
	
	# Rastgele %50 ihtimalle bonus elektirik çıksın
	if has_node("BonusElektrik"):
		if randf() > 0.5:
			$BonusElektrik.queue_free()
		else:
			$BonusElektrik.body_entered.connect(_bonus_alindi)

func _bonus_alindi(body):
	if body is Player:
		var bonus_para = randi_range(20, 200)
		get_tree().call_group("merkez", "bonus_para_ekle", bonus_para)
		if has_node("BonusElektrik"):
			$BonusElektrik.queue_free()

func _process(delta):
	# Eğer oyun başlamadıysa fonksiyonu burada kes, engeli hareket ettirme!
	if not Global.oyun_basladi:
		return 
		
	# Engeli her saniye sola doğru kaydır
	position.x -= hiz * delta
	
	if position.x < -200:
		queue_free()

func _kisa_devre(body):
	if body is Player:
		# Sadece "Sen çarptın, efektleri başlat" diyoruz. Oyunu bitirme emrini Player kendi halledecek!
		body.carpisma_oldu()
		set_process(false)
		set_physics_process(false)

func _lazer_kesildi(body):
	if body is Player:
		get_tree().call_group("merkez", "puan_arttir")

func aralik_ayarla(tam_mesafe: float):
	var yari_mesafe = tam_mesafe / 2.0
	$SpriteUst.position.y = -yari_mesafe - 521.0
	$CollisionUst.position.y = -yari_mesafe - 521.0
	$SpriteAlt.position.y = yari_mesafe + 541.0
	$CollisionAlt.position.y = yari_mesafe + 541.0
	
	if has_node("BonusElektrik"):
		# Y ekseninde boşluğun sınırları içinde kalacak şekilde rastgele bir konum
		var rastgele_y = randf_range(-yari_mesafe + 60, yari_mesafe - 60)
		# X ekseninde (sağ sol olarak) engelin 250px önüne veya arkasına rastgele dağıl
		var rastgele_x = randf_range(-400, 400)
		$BonusElektrik.position = Vector2(rastgele_x, rastgele_y)

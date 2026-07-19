extends Area2D

# Engelin sola doğru kayma hızı. Değer ne kadar büyükse engeller o kadar hızlı gelir.
var hiz = 300.0

# _ready fonksiyonu, bu nesne (engel) sahneye ilk eklendiğinde 1 kez çalışır.
func _ready():
	# Engelin gövdesine (boru kısmına) bir karakter çarptığında '_kisa_devre' fonksiyonunu çalıştır
	body_entered.connect(_kisa_devre)
	
	# Engelin ortasındaki görünmez lazer (Area2D) kısmına karakter girdiğinde '_lazer_kesildi' fonksiyonunu çalıştır
	$Lazer.body_entered.connect(_lazer_kesildi)
	
	# Eğer engelin içinde "BonusElektrik" isminde bir düğüm (Node) varsa...
	if has_node("BonusElektrik"):
		# randf() fonksiyonu 0.0 ile 1.0 arası rastgele bir sayı üretir.
		# Eğer bu sayı 0.5'ten büyükse (%50 ihtimal), elektrik simgesini sil (bu engelde bonus çıkmasın).
		if randf() > 0.5:
			$BonusElektrik.queue_free()
		else:
			# Eğer silinmediyse (bonus çıktıysa), karakter bu elektriğe değdiğinde '_bonus_alindi' fonksiyonunu çalıştır
			$BonusElektrik.body_entered.connect(_bonus_alindi)

# Karakter (Player) elektrik bonusuna değdiğinde bu fonksiyon tetiklenir
func _bonus_alindi(body):
	# Çarpan şeyin gerçekten oyuncu (Player) olup olmadığını kontrol ediyoruz
	if body is Player:
		# 20 ile 200 arasında rastgele bir miktar belirliyoruz
		var bonus_para = randi_range(20, 200)
		
		# Ana sahnedeki (main_game.gd) 'bonus_para_ekle' fonksiyonunu çağırıp bu miktarı ona yolluyoruz
		get_tree().call_group("merkez", "bonus_para_ekle", bonus_para)
		
		# Bonus toplandığı için onu ekrandan siliyoruz (yok ediyoruz)
		if has_node("BonusElektrik"):
			$BonusElektrik.queue_free()

# _process fonksiyonu, oyun çalıştığı sürece her saniyenin küçük bir kesitinde (kare/frame başı) sürekli çalışır
func _process(delta):
	# Eğer oyun henüz başlamadıysa (veya bittiyse), fonksiyonu burada kes (return). 
	# Böylece engeller hareket etmez.
	if not Global.oyun_basladi:
		return 
		
	# Engeli yatay (X) ekseninde sürekli sola doğru kaydır. 
	# 'delta' ile çarpmak, bilgisayarın kasma durumundan bağımsız hep aynı hızda gitmesini sağlar.
	position.x -= hiz * delta
	
	# Eğer engel ekranın çok soluna (-200 piksel) gittiyse ve artık görünmüyorsa...
	if position.x < -200:
		# Belleği şişirmemek için engeli tamamen sil.
		queue_free()

# Oyuncu boruya (engele) veya yere çarptığında bu fonksiyon çalışır
func _kisa_devre(body):
	# Çarpan şey bir oyuncu mu (Player)?
	if body is Player:
		# Oyuncunun içindeki 'carpisma_oldu' fonksiyonunu tetikle (Kıvılcım çıksın, ölsün vs.)
		body.carpisma_oldu()
		
		# Bu engelin hareket etmesini ve fiziksel işlemler yapmasını durdur
		set_process(false)
		set_physics_process(false)

# Oyuncu iki borunun arasındaki görünmez lazere (Area2D) değdiğinde bu fonksiyon çalışır
func _lazer_kesildi(body):
	# Değen nesne oyuncu ise
	if body is Player:
		# Ana oyun yöneticisine (main_game.gd içindeki 'merkez' grubuna) haber ver ve 'puan_arttir' fonksiyonunu tetikle
		get_tree().call_group("merkez", "puan_arttir")

# Bu fonksiyon engelin üst ve alt borusu arasındaki boşluğu belirler. 'main_game.gd' tarafından çağrılır.
func aralik_ayarla(tam_mesafe: float):
	# Toplam boşluğun yarısını buluyoruz (Örn: 200 ise yarısı 100)
	var yari_mesafe = tam_mesafe / 2.0
	
	# Üst boruyu yukarıya doğru itiyoruz (Eksi yönde)
	$SpriteUst.position.y = -yari_mesafe - 521.0
	$CollisionUst.position.y = -yari_mesafe - 521.0
	
	# Alt boruyu aşağıya doğru itiyoruz (Artı yönde)
	$SpriteAlt.position.y = yari_mesafe + 541.0
	$CollisionAlt.position.y = yari_mesafe + 541.0
	
	# Eğer sahnede BonusElektrik nesnesi varsa...
	if has_node("BonusElektrik"):
		# Elektriğin çıkacağı dikey (Y) konumu, boşluğun en üstü ile en altı arasında rastgele belirliyoruz
		# (Borulara çok yakın olmasın diye +- 60 piksel pay bırakıyoruz)
		var rastgele_y = randf_range(-yari_mesafe + 60, yari_mesafe - 60)
		
		# Elektriğin çıkacağı yatay (X) konumu, borunun bulunduğu hizadan sağa veya sola doğru rastgele dağıtıyoruz (-400 ile +400 arası)
		var rastgele_x = randf_range(-400, 400)
		
		# Belirlediğimiz bu rastgele konumu elektrik simgesine uyguluyoruz
		$BonusElektrik.position = Vector2(rastgele_x, rastgele_y)

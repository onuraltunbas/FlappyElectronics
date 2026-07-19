extends CharacterBody2D
class_name Player # Bu satır çok önemli, engellerin bize değen şeyin "Oyuncu" olduğunu anlamasını sağlar.

# --- FİZİKSEL AYARLAR ---
@export var yercekimi: float = 1200.0 # Bizi aşağı çeken kuvvet
@export var ziplama_gucu: float = -450.0 # Tıkladığımızda bizi yukarı fırlatan güç (Eksi değer yukarı demektir)

# Karakterin o an ölüp ölmediğini (yere/engele çarpıp çarpmadığını) tutan değişken
var oldu: bool = false 

# Karakter ilk doğduğunda (oyun açıldığında) 1 kez çalışır
func _ready():
	# Oyun başlar başlamaz karakter hemen yere düşmesin diye şalteri kapalı tutuyoruz
	Global.oyun_basladi = false
	
	# 1. Global dosyamızdan (marketten veya varsayılan olarak) seçtiğimiz karakterin özelliklerini çekiyoruz
	var resim_yolu = Global.secilen_karakter["resim"]
	var hedef_yukseklik = Global.secilen_karakter["boyut"]
	var daraltma = Global.secilen_karakter.get("hitbox_daraltma", Vector2(1.0, 1.0))
	var en_olcegi = Global.secilen_karakter.get("en_olcegi", 1.0)
	
	# Karakterin resmini (Sprite2D) marketten aldığımız resimle değiştiriyoruz
	$Sprite2D.texture = load(resim_yolu)
	
	# 2. Her Karaktere Özel Dinamik Hacim Ayarlama (Artık en ve boy bağımsız!)
	# Gerçek resmin yüksekliğini piksel olarak bul
	var resim_yuksekligi = $Sprite2D.texture.get_height()
	
	# Hedef yüksekliğimize (Örn: 50) ulaşmak için resmi ne kadar küçültmemiz/büyütmemiz gerektiğini hesaplıyoruz
	var yeni_olcek_y = float(hedef_yukseklik) / float(resim_yuksekligi)
	
	# Hesapladığımız bu oranı, yatay (X) için en_olcegi ile çarparak uyguluyoruz
	var gercek_olcek = Vector2(yeni_olcek_y * en_olcegi, yeni_olcek_y)
	$Sprite2D.scale = gercek_olcek
	
	# 3. Hitbox (Çarpışma Alanı) Ayarlama
	var shape = $CollisionShape2D.shape
	if shape is RectangleShape2D:
		# Resmin boyutunu asimetrik ölçekle çarpıp, sonra da daraltma oranımızla (örn: %20 daha küçük) 
		# çarparak çarpışma alanını resme tam oturtuyoruz. Bu sayede haksız yere ölmüyoruz.
		shape.size = ($Sprite2D.texture.get_size() * gercek_olcek) * daraltma

# Oyun motorunun fizik işlemlerini hesapladığı fonksiyondur. (Saniyede 60 kez çalışır)
func _physics_process(delta):
	# Eğer öldüysek fiziksel işlemleri yapma, hiçbir tuşa basamasın
	if oldu: return 
	
	# Ekrana veya boşluk (Space) tuşuna tıklandığında...
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# Eğer oyun başlamamışsa şalteri aç (İlk tıklamayla oyunu başlatırız)
		if not Global.oyun_basladi:
			Global.oyun_basladi = true
		
		# Karakteri yukarı doğru zıplat (velocity.y dikey hız demektir)
		velocity.y = ziplama_gucu
	
	# GLOBAL şalter kapalıyken (yani ilk defa tıklanana kadar)
	if not Global.oyun_basladi:
		# Karakter havada asılı kalsın
		velocity.y = 0
		return
		
	# Eğer oyun başladıysa karaktere sürekli yer çekimi uygula ve aşağı çek
	velocity.y += yercekimi * delta
	
	# Karakterin hareketlerini (hız, yerçekimi vs.) fizik motoruna ilet
	move_and_slide()
	
	# Karakter düşerken burnunu aşağı, zıplarken yukarı çevirmesi için küçük bir rotasyon hilesi
	rotation = deg_to_rad(velocity.y * 0.05)

# Karakterimiz borulara veya yere değdiğinde (engel.gd içinden) tetiklenir
func carpisma_oldu():
	# Eğer zaten öldüysek fonksiyonu tekrar çalıştırma (bugları önler)
	if oldu: return
	
	# Artık öldük, tuş basmaları iptal
	oldu = true
	
	# 1. Çarpma efektini (Kıvılcım) oluştur
	var kivilcim_sahne = load("res://Scenes/kivilcim.tscn")
	var patlama = kivilcim_sahne.instantiate()
	get_parent().add_child(patlama) # Kıvılcımı ekrana ekle
	patlama.global_position = self.global_position # Kıvılcımın yerini karakterin öldüğü yer yap
	
	# 2. Zamanı Yavaşlat (Oyun dünyası %90 yavaşlar - Hit-Stop efekti verir)
	Engine.time_scale = 0.1 
	
	# 3. Yavaşlamış halde oyuncunun olayı hissetmesi için gerçek zamanda yarım saniye bekle
	# (Son parametrenin 'true' olması, oyun dondurulmuş olsa bile bu sürenin gerçek hayattaki süreye göre akmasını sağlar)
	await get_tree().create_timer(0.5, true, false, true).timeout
	
	# 4. Yarım saniyelik efekt bitince zamanı normale döndür
	Engine.time_scale = 1.0 
	
	# 5. Ana oyuna "Oyun Bitti" emrini yolla (Game over ekranı gelsin, her şey dursun)
	get_tree().call_group("merkez", "oyunu_bitir")

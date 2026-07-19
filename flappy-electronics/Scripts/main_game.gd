extends Node2D

# Ekrandan geçip gidecek olan engellerin (boruların) kalıbını yüklüyoruz
var engel_kalibi = preload("res://Scenes/engel.tscn")

# --- KONTROL PANELİMİZ (ARTIK HER ŞEY RASTGELE!) ---

@export_group("Fabrika Bant Hızı (Yatay Rastgelelik)")
# Engellerin ne sıklıkla geleceğini saniye cinsinden ayarlıyoruz
@export var en_hizli_kapi: float = 1.0  # Bir engel en erken 1 saniyede gelebilir
@export var en_yavas_kapi: float = 2.5  # Bir engel en geç 2.5 saniyede gelebilir

@export_group("Yükseklik Sınırları (Oynaklık)")
# Deliğin (geçiş yerinin) ekranın neresinde olabileceği
@export var en_ust_delik: float = 350.0  # En yukarıda çıkabileceği nokta
@export var en_alt_delik: float = 930.0  # En aşağıda çıkabileceği nokta

@export_group("Delik Boyutu (Dikey Rastgelelik)")
# İki boru arasındaki boşluğun ne kadar büyük veya küçük olacağı
@export var en_genis_delik: float = 800.0 # Oyuncuya çok kolaylık sağlayan devasa boşluk
@export var en_dar_delik: float = 600.0   # Oyuncuyu zorlayacak dar boşluk

# Oyuncunun o anki oynadığı turdaki skorunu ve kazandığı parayı tutan geçici değişkenler
var skor: int = 0  
var bu_tur_kazanilan_para: int = 0

# --- HAFIZA SİSTEMİ ---
# Oyuncunun parası ve aldığı karakterlerin kaydedileceği dosyanın yolu
var kayit_yolu = "user://oyun_hafizasi.save" 

# Oyun sahnesi açılır açılmaz (ilk saniyede) bu fonksiyon çalışır
func _ready():
	# Eğer pause (durdurma) ekranı varsa, oyun dondurulduğunda bile bu ekranın
	# çalışmaya devam edebilmesi için 'PROCESS_MODE_ALWAYS' ayarını yapıyoruz.
	if $Arayuz.has_node("DurdurmaEkrani"):
		$Arayuz/DurdurmaEkrani.process_mode = Node.PROCESS_MODE_ALWAYS
		
	# Daha önceden kaydedilmiş verileri (paramız, aldığımız karakterler) yüklüyoruz
	hafizayi_yukle()
	
	# Oyun başlarken ilk engelin gelme süresini (1.0 ile 2.5 sn arası) rastgele kuruyoruz
	$Timer.wait_time = randf_range(en_hizli_kapi, en_yavas_kapi)

# Zamanlayıcı (Timer) her sıfırlandığında bu fonksiyon çalışır ve ekrana yeni engel basar
func _on_timer_timeout():
	# Eğer oyun başlamadıysa veya öldüysek yeni engel yaratma, bekle!
	if not Global.oyun_basladi:
		return 
		
	# Kalıptan yeni bir engel oluştur
	var yeni_kapi = engel_kalibi.instantiate()
	
	# 1. Deliğin ekrandaki dikey (Y) konumunu rastgele seçiyoruz
	var rastgele_y = randf_range(en_ust_delik, en_alt_delik)
	yeni_kapi.position = Vector2(800, rastgele_y) # 800, ekranın sağ dışı demektir
	
	# 2. İki boru arasındaki boşluğu (aralık boyutunu) rastgele seçip engele iletiyoruz
	var rastgele_bosluk = randf_range(en_dar_delik, en_genis_delik)
	yeni_kapi.aralik_ayarla(rastgele_bosluk)
		
	# Ayarları biten engeli sahneye ekliyoruz
	add_child(yeni_kapi)
	
	# 3. Bir sonraki engelin ne zaman geleceğini yine rastgele kuruyoruz
	$Timer.wait_time = randf_range(en_hizli_kapi, en_yavas_kapi)

# --- SKOR VE SİNYAL BÖLÜMÜ ---

# Karakter lazerden her geçtiğinde engel tarafından bu fonksiyon çağrılır
func puan_arttir():
	skor += 1
	$Arayuz/PuanTabelasi.text = "Skor: " + str(skor)
	
	# Geçtiğimiz engel aynı zamanda bize 1 para (Toplam Skor) kazandırır
	bu_tur_kazanilan_para += 1
	Global.toplam_skor += 1
	
	# Arayüzdeki toplam paramızı yazan kısmı da güncelliyoruz
	if $Arayuz.has_node("ToplamSkorTabelasi"):
		$Arayuz/ToplamSkorTabelasi.text = "Toplam Skor: " + str(Global.toplam_skor)

# Karakter yere veya boruya çarptığında player.gd tarafından çağrılır
func oyunu_bitir():
	# Oyun bittiğini sisteme bildiriyoruz. Bu sayede engeller duruyor.
	Global.oyun_basladi = false 
	
	# O anki toplam paramızı kalıcı olarak dosyaya kaydediyoruz
	hafizayi_kaydet()
	
	# Ekranda "Game Over" paneli varsa onu göster, yoksa oyunu direkt baştan başlat
	if $Arayuz.has_node("GameOverEkrani"):
		$Arayuz/GameOverEkrani.show()
	else:
		get_tree().call_deferred("reload_current_scene")

# Oyuncu engellerin arasından elektrik simgesi (bonus) topladığında çağrılır
func bonus_para_ekle(miktar: int):
	# Alınan bonus miktarı kadar toplam paramızı artırıyoruz
	bu_tur_kazanilan_para += miktar
	Global.toplam_skor += miktar
	if $Arayuz.has_node("ToplamSkorTabelasi"):
		$Arayuz/ToplamSkorTabelasi.text = "Toplam Skor: " + str(Global.toplam_skor)

# --- BUTON SİNYALLERİ VE OYUNU DURDURMA ---

# Game Over ekranındaki "Yeniden Başlat" butonuna tıklandığında
func _on_yeniden_baslat_butonu_pressed():
	get_tree().call_deferred("reload_current_scene")

# Game Over ekranındaki "Ana Menüye Dön" butonuna tıklandığında
func _on_gameover_ana_menu_pressed():
	# Ölerek oyun bittiği için kazandığımız paralar bizim hakkımızdır, silinmez!
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")

# --- DURDURMA (PAUSE) MENÜSÜ SİNYALLERİ ---

# Oyun oynarken "Durdur" butonuna tıklandığında
func _on_durdurma_butonu_pressed():
	if Global.oyun_basladi:
		# Tüm oyun motorunu (fizik, engeller vs.) dondurur
		get_tree().paused = true
		
		# Durdurma menüsünü ekranda gösterir
		if $Arayuz.has_node("DurdurmaEkrani"):
			$Arayuz/DurdurmaEkrani.show()

# Durdurma menüsündeki "Devam Et" butonuna tıklandığında
func _on_devam_et_butonu_pressed():
	# Oyun motorunu tekrar akmaya (çalışmaya) başlatır
	get_tree().paused = false
	
	if $Arayuz.has_node("DurdurmaEkrani"):
		$Arayuz/DurdurmaEkrani.hide()

# Oyuncu durdurma menüsünden oyunu terk etmek isterse çalışan ortak güvenlik fonksiyonu
func kazanci_iptal_et_ve_cikis(hedef_sahne: String):
	# Oyuncu oyunu haksız yere yarıda kestiği için, bu tur boyunca kazandığı 
	# tüm puanları (paraları) toplam parasından geri siliyoruz! (Anti-Hile)
	Global.toplam_skor -= bu_tur_kazanilan_para
	bu_tur_kazanilan_para = 0
	
	# Silinmiş haliyle dosyaya kaydediyoruz
	hafizayi_kaydet()
	
	# Oyunu dondurulmuş halden çıkarıp istenilen sahneye geçiş yapıyoruz
	get_tree().paused = false
	get_tree().change_scene_to_file(hedef_sahne)

# Durdurma menüsündeki "Yeniden Başlat" butonuna tıklandığında
func _on_durdurma_yeniden_baslat_pressed():
	kazanci_iptal_et_ve_cikis("res://Scenes/main_game.tscn")

# Durdurma menüsündeki "Ana Menüye Dön" butonuna tıklandığında
func _on_durdurma_ana_menu_pressed():
	kazanci_iptal_et_ve_cikis("res://Scenes/start_menu.tscn")

# --- KAYIT SİSTEMİ ---

# Sahip olunanları ve skoru kalıcı olarak dosyaya yazar
func hafizayi_kaydet():
	# Dosyayı "YAZMA" (WRITE) modunda aç
	var dosya = FileAccess.open(kayit_yolu, FileAccess.WRITE)
	dosya.store_var(Global.toplam_skor)    # Skoru kaydet
	dosya.store_var(Global.satin_alinanlar) # Satın alınanlar listesini kaydet
	dosya.close() # Dosyayı kapat

# Oyuna girerken kaydedilmiş dosyayı okur
func hafizayi_yukle():
	# Eğer böyle bir kayıt dosyası cihazda varsa:
	if FileAccess.file_exists(kayit_yolu):
		# Dosyayı "OKUMA" (READ) modunda aç
		var dosya = FileAccess.open(kayit_yolu, FileAccess.READ)
		
		# Sırayla yazıldığı gibi değerleri çek
		var okunan_skor = dosya.get_var()
		var okunan_liste = dosya.get_var()
		
		# Eğer değerler boş (null) değilse, bizim Global değişkenlerimize eşitle
		if okunan_skor != null: Global.toplam_skor = okunan_skor
		if okunan_liste != null: Global.satin_alinanlar = okunan_liste
		
		dosya.close() # Okuma bitince kapat
	
	# Okuduğumuz skoru ekrana yazdırıyoruz
	if $Arayuz.has_node("ToplamSkorTabelasi"):
		$Arayuz/ToplamSkorTabelasi.text = "Toplam Skor: " + str(Global.toplam_skor)


func _on_button_pressed() -> void:
	pass # Replace with function body.

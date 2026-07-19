extends Control

# Oyunun hafıza (kayıt) dosyasının bilgisayarda tutulduğu yer
var kayit_yolu = "user://oyun_hafizasi.save"

# Bu ekran (Ana Menü) açıldığında otomatik olarak çalışır
func _ready():
	# 1. Ekran açılır açılmaz cihazda daha önceden oluşturulmuş bir hafıza dosyası var mı diye bakıyoruz
	if FileAccess.file_exists(kayit_yolu):
		# Varsa dosyayı 'OKUMA' (READ) modunda açıyoruz
		var dosya = FileAccess.open(kayit_yolu, FileAccess.READ)
		
		# İçindeki verileri sırasıyla okuyoruz
		var okunan_skor = dosya.get_var()
		var okunan_liste = dosya.get_var()
		
		# Okuduğumuz veriler boş değilse, Global değişkenlere (sisteme) aktarıyoruz
		if okunan_skor != null: Global.toplam_skor = okunan_skor
		if okunan_liste != null: Global.satin_alinanlar = okunan_liste
		
		# Dosyayı kapatıyoruz
		dosya.close()
		
	# 2. Okuduğumuz toplam skoru (paramızı) ekrandaki tabelaya yazdırıyoruz
	if has_node("ToplamSkorTabelasi"):
		$ToplamSkorTabelasi.text = "TOPLAM SKOR: " + str(Global.toplam_skor)
		
	# 3. Oyuncunun seçili karakterini ana ekranda tam ortada gösteriyoruz
	if has_node("SeciliKarakterGorseli"):
		$SeciliKarakterGorseli.texture = load(Global.secilen_karakter["resim"])

# Ana menüdeki "OYNA" butonuna tıklandığında çalışacak olan fonksiyon
func _on_oyna_butonu_pressed():
	# Sahneyi değiştirerek ana oyunu (main_game.tscn) başlat
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

# Ana menüdeki "BİLEŞEN SEÇ" (Market) butonuna tıklandığında çalışacak olan fonksiyon
func _on_bilesen_sec_butonu_pressed() -> void:
	# Sahneyi değiştirerek market (SecimEkrani) sayfasına git
	get_tree().change_scene_to_file("res://Scenes/SecimEkrani.tscn")

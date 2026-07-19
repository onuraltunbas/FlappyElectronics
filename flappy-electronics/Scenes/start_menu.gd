extends Control

var kayit_yolu = "user://oyun_hafizasi.save"

func _ready():
	# Ekran açılır açılmaz hafızadaki kaydı okuyoruz
	if FileAccess.file_exists(kayit_yolu):
		var dosya = FileAccess.open(kayit_yolu, FileAccess.READ)
		var okunan_skor = dosya.get_var()
		var okunan_liste = dosya.get_var()
		
		if okunan_skor != null: Global.toplam_skor = okunan_skor
		if okunan_liste != null: Global.satin_alinanlar = okunan_liste
		dosya.close()
		
	# Okuduğumuz skoru ekrandaki tabelaya yazdırıyoruz
	if has_node("ToplamSkorTabelasi"):
		$ToplamSkorTabelasi.text = "TOPLAM SKOR: " + str(Global.toplam_skor)
		
	# Seçili karakteri ana ekranda göster
	if has_node("SeciliKarakterGorseli"):
		$SeciliKarakterGorseli.texture = load(Global.secilen_karakter["resim"])

# Butona tıklandığında çalışacak olan fonksiyon
func _on_oyna_butonu_pressed():
	# Oyunu başlat (main_game sahnesine geçiş yap)
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

func _on_bilesen_sec_butonu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/SecimEkrani.tscn")

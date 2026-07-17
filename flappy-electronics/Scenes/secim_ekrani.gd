extends Control

func _ready():
	# Liste kutumuzu koda tanıtıyoruz
	var liste_kutusu = $ScrollContainer/Liste
	
	# Global veritabanındaki tüm kategorileri (DİRENÇLER, ENTEGRELER vb.) geziyoruz
	for kategori_adi in Global.bilesen_katalogu.keys():
		
		# 1. Kategori Başlığını Otomatik Oluştur
		var baslik = Label.new()
		baslik.text = "--- " + kategori_adi + " ---"
		baslik.add_theme_font_size_override("font_size", 40)
		baslik.add_theme_color_override("font_color", Color("4fe3d4")) # Ana menüdeki o efsanevi yeşil renk
		baslik.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		liste_kutusu.add_child(baslik)
		
		# Başlık ile butonlar arasına ufak boşluk
		var ufak_bosluk = Control.new()
		ufak_bosluk.custom_minimum_size = Vector2(0, 10)
		liste_kutusu.add_child(ufak_bosluk)
		
		# 2. O Kategorinin İçindeki Elemanları Gez ve Butonlarını Oluştur
		for eleman in Global.bilesen_katalogu[kategori_adi]:
			var buton = Button.new()
			buton.text = eleman["isim"]
			buton.custom_minimum_size = Vector2(0, 90) # Butonlar kalın ve telefonda basması kolay olsun
			buton.add_theme_font_size_override("font_size", 28)
			
			# Butona tıklandığında _karakter_secildi fonksiyonunu çalıştır ve ona "resim" yolunu gönder
			buton.pressed.connect(self._karakter_secildi.bind(eleman["resim"]))
			
			liste_kutusu.add_child(buton)
			
		# Kategoriler (Dirençler bittip Entegreler başlarken) arasına büyük boşluk ekle
		var buyuk_bosluk = Control.new()
		buyuk_bosluk.custom_minimum_size = Vector2(0, 50)
		liste_kutusu.add_child(buyuk_bosluk)

# Herhangi bir bileşen butonuna basıldığında burası tetiklenir
func _karakter_secildi(resim_yolu: String):
	# Global hafızaya yeni resmi kaydediyoruz
	Global.secilen_karakter_resmi = resim_yolu
	
	# Karakteri seçer seçmez ana menüye geri atıyoruz (İşlem tamam hissi için)
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")

# Geri Butonuna basılınca çalışacak fonksiyon
func _on_geri_butonu_pressed():
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")

extends Control

func _ready():
	var liste_kutusu = $ScrollContainer/Liste
	
	for kategori_adi in Global.bilesen_katalogu.keys():
		
		# 1. Kategori Başlığı (Tertemiz, sadece kategori adı)
		var baslik = Label.new()
		baslik.text = kategori_adi
		baslik.add_theme_font_size_override("font_size", 40)
		baslik.add_theme_color_override("font_color", Color("08080eff"))
		baslik.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		liste_kutusu.add_child(baslik)
		
		var ufak_bosluk = Control.new()
		ufak_bosluk.custom_minimum_size = Vector2(0, 20)
		liste_kutusu.add_child(ufak_bosluk)
		
		# 2. Resimleri Yan Yana Ortalı Dizmek İçin Taşıyıcı
		var ortalayici = HBoxContainer.new()
		ortalayici.alignment = BoxContainer.ALIGNMENT_CENTER
		liste_kutusu.add_child(ortalayici)
		
		# Yan yana dizme ızgarası
		var grid = GridContainer.new()
		grid.columns = 4 # Yan yana 4 resme kadar sığar
		grid.add_theme_constant_override("h_separation", 30) # Resimler arası yatay boşluk
		grid.add_theme_constant_override("v_separation", 30) # Resimler arası dikey boşluk
		ortalayici.add_child(grid)
		
		# 3. Sadece Resimli Butonları (Yazısız) Oluştur
		for eleman in Global.bilesen_katalogu[kategori_adi]:
			var resimli_buton = TextureButton.new()
			
			# Resmi yükle
			var doku = load(eleman["resim"])
			resimli_buton.texture_normal = doku
			
			# Resim boyutu ne olursa olsun menüdeki kutusunu 100x100 e sabitle
			resimli_buton.ignore_texture_size = true
			resimli_buton.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
			resimli_buton.custom_minimum_size = Vector2(120, 120) 
			
			# Tıklanıldığında çalışacak sinyal
			resimli_buton.pressed.connect(self._karakter_secildi.bind(eleman["resim"]))
			
			grid.add_child(resimli_buton)
			
		# Kategoriler arası büyük boşluk
		var buyuk_bosluk = Control.new()
		buyuk_bosluk.custom_minimum_size = Vector2(0, 50)
		liste_kutusu.add_child(buyuk_bosluk)

func _karakter_secildi(resim_yolu: String):
	Global.secilen_karakter_resmi = resim_yolu
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")

func _on_geri_butonu_pressed():
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")

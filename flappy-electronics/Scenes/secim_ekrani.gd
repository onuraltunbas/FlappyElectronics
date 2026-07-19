extends Control

func _ready():
	var liste_kutusu = $ScrollContainer/Liste
	
	for kategori_adi in Global.bilesen_katalogu.keys():
		
		var baslik = Label.new()
		baslik.text = kategori_adi
		baslik.add_theme_font_size_override("font_size", 40)
		baslik.add_theme_color_override("font_color", Color("4fe3d4"))
		baslik.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		liste_kutusu.add_child(baslik)
		
		var ufak_bosluk = Control.new()
		ufak_bosluk.custom_minimum_size = Vector2(0, 20)
		liste_kutusu.add_child(ufak_bosluk)
		
		var ortalayici = HBoxContainer.new()
		ortalayici.alignment = BoxContainer.ALIGNMENT_CENTER
		liste_kutusu.add_child(ortalayici)
		
		var grid = GridContainer.new()
		grid.columns = 4 
		grid.add_theme_constant_override("h_separation", 30) 
		grid.add_theme_constant_override("v_separation", 30) 
		ortalayici.add_child(grid)
		
		for eleman in Global.bilesen_katalogu[kategori_adi]:
			var dikey_kutu = VBoxContainer.new()
			dikey_kutu.alignment = BoxContainer.ALIGNMENT_CENTER
			
			var resimli_buton = TextureButton.new()
			resimli_buton.texture_normal = load(eleman["resim"])
			resimli_buton.ignore_texture_size = true
			resimli_buton.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
			
			# Menüdeki görünüm boyutu (oyun içi değil)
			resimli_buton.custom_minimum_size = Vector2(150, 150) 
			
			# Butona basıldığında artık direkt tüm 'eleman' sözlüğünü yolluyoruz
			resimli_buton.pressed.connect(self._karakter_secildi.bind(eleman))
			
			dikey_kutu.add_child(resimli_buton)
			
			# Fiyat ve Sahiplik Bilgisi
			var fiyat_yazisi = Label.new()
			if eleman["id"] in Global.satin_alinanlar:
				fiyat_yazisi.text = "SAHİP"
				fiyat_yazisi.add_theme_color_override("font_color", Color("00ff00"))
			else:
				fiyat_yazisi.text = str(eleman["fiyat"]) + " Skor"
				fiyat_yazisi.add_theme_color_override("font_color", Color("ff0000"))
			fiyat_yazisi.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			
			dikey_kutu.add_child(fiyat_yazisi)
			grid.add_child(dikey_kutu)
			
		var buyuk_bosluk = Control.new()
		buyuk_bosluk.custom_minimum_size = Vector2(0, 50)
		liste_kutusu.add_child(buyuk_bosluk)

func _karakter_secildi(eleman: Dictionary):
	var id = eleman["id"]
	var fiyat = eleman["fiyat"]
	
	if id in Global.satin_alinanlar:
		# Zaten sahip
		Global.secilen_karakter = eleman
		get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
	else:
		# Satın alınacak
		if Global.toplam_skor >= fiyat:
			Global.toplam_skor -= fiyat
			Global.satin_alinanlar.append(id)
			
			# Hafızaya hemen kaydet ki para gitmesin
			var dosya = FileAccess.open("user://oyun_hafizasi.save", FileAccess.WRITE)
			dosya.store_var(Global.toplam_skor)
			dosya.store_var(Global.satin_alinanlar)
			dosya.close()
			
			# Seç ve dön
			Global.secilen_karakter = eleman
			get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
		else:
			print("Paraniz (Skor) yetersiz! Gereken:", fiyat, " Sizin:", Global.toplam_skor)

func _on_geri_butonu_pressed():
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")

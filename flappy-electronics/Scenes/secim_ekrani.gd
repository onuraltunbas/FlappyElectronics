extends Control

# Ekran ilk açıldığında otomatik çalışan fonksiyon
func _ready():
	# Ekranda butonları alt alta veya yan yana dizeceğimiz ana kutuyu (Liste) buluyoruz
	var liste_kutusu = $ScrollContainer/Liste
	
	# Global kataloğumuzdaki her bir kategoriyi (DİRENÇLER, ENTEGRELER vb.) tek tek dönüyoruz
	for kategori_adi in Global.bilesen_katalogu.keys():
		
		# 1. Her kategori için büyük bir Başlık (Label) oluşturuyoruz
		var baslik = Label.new()
		baslik.text = kategori_adi
		baslik.add_theme_font_size_override("font_size", 40) # Başlık boyutu
		baslik.add_theme_color_override("font_color", Color("4fe3d4")) # Turkuaz renk
		baslik.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER # Ortala
		liste_kutusu.add_child(baslik) # Başlığı ana kutuya ekle
		
		# 2. Başlığın altına minik bir boşluk bırakıyoruz ki sıkışık durmasın
		var ufak_bosluk = Control.new()
		ufak_bosluk.custom_minimum_size = Vector2(0, 20)
		liste_kutusu.add_child(ufak_bosluk)
		
		# 3. Butonların ortada durmasını sağlayacak yatay bir hizalayıcı (HBoxContainer) yapıyoruz
		var ortalayici = HBoxContainer.new()
		ortalayici.alignment = BoxContainer.ALIGNMENT_CENTER
		liste_kutusu.add_child(ortalayici)
		
		# 4. Butonları yan yana dizecek olan ızgarayı (GridContainer) kuruyoruz
		var grid = GridContainer.new()
		grid.columns = 4 # Yan yana en fazla 4 buton sığsın
		grid.add_theme_constant_override("h_separation", 30) # Butonlar arası yatay boşluk
		grid.add_theme_constant_override("v_separation", 30) # Butonlar arası dikey boşluk
		ortalayici.add_child(grid) # Izgarayı hizalayıcının içine koyuyoruz
		
		# 5. Şimdi o kategorinin (Örn: DİRENÇLER) içindeki her bir karakter (eleman) için buton üretiyoruz
		for eleman in Global.bilesen_katalogu[kategori_adi]:
			
			# Her karakter için buton ve fiyatını alt alta tutacak dikey bir kutu yapıyoruz
			var dikey_kutu = VBoxContainer.new()
			dikey_kutu.alignment = BoxContainer.ALIGNMENT_CENTER
			
			# Karakterin tıklanabilir resmini (TextureButton) oluşturuyoruz
			var resimli_buton = TextureButton.new()
			resimli_buton.texture_normal = load(eleman["resim"])
			resimli_buton.ignore_texture_size = true
			resimli_buton.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
			
			# Menüdeki görünüm boyutu (oyun içi değil, sadece marketteki büyüklüğü)
			resimli_buton.custom_minimum_size = Vector2(150, 150) 
			
			# Butona basıldığında '_karakter_secildi' fonksiyonunu çalıştır ve 'eleman' bilgilerini yolla
			resimli_buton.pressed.connect(self._karakter_secildi.bind(eleman))
			
			dikey_kutu.add_child(resimli_buton) # Butonu dikey kutuya ekle
			
			# 6. Fiyat ve Sahiplik Bilgisini (Label) yazıyoruz
			var fiyat_yazisi = Label.new()
			
			# Eğer oyuncu bu karaktere zaten sahipse
			if eleman["id"] in Global.satin_alinanlar:
				fiyat_yazisi.text = "SAHİP"
				fiyat_yazisi.add_theme_color_override("font_color", Color("00ff00")) # Yeşil renk
			else:
				# Sahip değilse fiyatını yazdır
				fiyat_yazisi.text = str(eleman["fiyat"]) + " Skor"
				fiyat_yazisi.add_theme_color_override("font_color", Color("ff0000")) # Kırmızı renk
				
			fiyat_yazisi.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			
			dikey_kutu.add_child(fiyat_yazisi) # Fiyat yazısını butonun altına ekle
			grid.add_child(dikey_kutu) # Dikey kutuyu ızgaraya ekle
			
		# Bir kategori bittikten sonra diğerine geçmeden önce büyük bir boşluk bırak
		var buyuk_bosluk = Control.new()
		buyuk_bosluk.custom_minimum_size = Vector2(0, 50)
		liste_kutusu.add_child(buyuk_bosluk)

# Bir karaktere tıklandığında çalışacak fonksiyon (Satın alma ve Seçme)
func _karakter_secildi(eleman: Dictionary):
	var id = eleman["id"]
	var fiyat = eleman["fiyat"]
	
	# Eğer bu id "satin_alinanlar" listesinde varsa, zaten bizimdir.
	if id in Global.satin_alinanlar:
		# Direkt karakteri seçili karakter yap ve ana menüye dön
		Global.secilen_karakter = eleman
		get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
	else:
		# Satın alınmamış, parayı (Toplam Skoru) kontrol etmemiz lazım
		if Global.toplam_skor >= fiyat:
			# Para yeterli, skordan fiyatı düş
			Global.toplam_skor -= fiyat
			
			# Karakteri sahip olduklarımız listesine ekle
			Global.satin_alinanlar.append(id)
			
			# Paramız azaldığı ve yeni karakter aldığımız için bunu hemen bilgisayara (dosyaya) kaydediyoruz
			var dosya = FileAccess.open("user://oyun_hafizasi.save", FileAccess.WRITE)
			dosya.store_var(Global.toplam_skor)
			dosya.store_var(Global.satin_alinanlar)
			dosya.close()
			
			# Artık bizim olduğu için direkt seçili karakter yapıp ana menüye dön
			Global.secilen_karakter = eleman
			get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
		else:
			# Para yetmezse burası çalışır (Şimdilik arka planda konsola yazdırıyor, ekrana hata mesajı çıkartmıyor)
			print("Paraniz (Skor) yetersiz! Gereken:", fiyat, " Sizin:", Global.toplam_skor)

# Geri dön butonuna tıklandığında ana menüye (start_menu) geç
func _on_geri_butonu_pressed():
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")

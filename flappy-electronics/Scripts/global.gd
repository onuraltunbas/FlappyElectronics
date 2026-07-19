extends Node

# --- GLOBAL DEĞİŞKENLER ---
# Bu script Godot'ta "AutoLoad" (Otomatik Yükleme) olarak ayarlanmıştır.
# Yani oyun başladığından itibaren her zaman arka planda aktiftir ve 
# diğer tüm scriptler (main_game, player, engel vs.) buradaki değişkenlere anında ulaşabilir.

# Oyunun o an oynanıp oynanmadığını tutan ana şalter. 
# Eğer false ise engeller hareket etmez, yer çekimi çalışmaz.
var oyun_basladi: bool = false

# Oyuncunun kazandığı ve biriktirdiği toplam puan/para.
var toplam_skor: int = 0

# Oyuncunun marketten satın aldığı veya zaten sahip olduğu karakterlerin listesi.
# Oyun ilk açıldığında herkesin ilk karaktere (direnc_1) sahip olması için içine varsayılan olarak ekliyoruz.
var satin_alinanlar: Array = ["direnc_1"] 

# OYUN İLK AÇILDIĞINDAKİ VARSAYILAN KARAKTER
# Eğer oyuncu menüden hiç karakter seçmeden oyuna girerse bu karakter özellikleri geçerli olur.
var secilen_karakter = {
	"resim": "res://Assets/Sprites/resistor.png", # Karakterin resmi
	"boyut": 30.0,                                # Karakterin dikey boyutu (yüksekliği)
	"en_olcegi": 1.0,                             # Karakterin en/boy oranı
	"hitbox_daraltma": Vector2(0.9, 0.4)          # Çarpışma alanını (Hitbox) ne kadar küçülteceğimiz
}

# --- BİLEŞEN (KARAKTER) KATALOĞU ---
# Tüm karakterlerin bilgilerinin (fiyat, boyut, çarpışma alanı) tutulduğu sözlük yapısı.
var bilesen_katalogu = {
	"DİRENÇLER": [
		{
			"id": "direnc_1",               # Satın alma listesine eklenecek olan benzersiz isim
			"fiyat": 0,                     # Karakterin fiyatı (Bu ilk karakter olduğu için ücretsiz)
			"resim": "res://Assets/Sprites/resistor.png",
			"boyut": 50.0,
			"en_olcegi": 1.0,
			"hitbox_daraltma": Vector2(0.75, 0.25)  # Sağdan-soldan biraz daralt, üstten-alttan çok daralt
		}
	],
	
	"ENTEGRELER": [
		{
			"id": "entegre_1",
			"fiyat": 100,                   # Bu karakteri almak için 100 Skor gereklidir
			"resim": "res://Assets/Sprites/mp1584.png",
			"boyut": 70.0,
			"en_olcegi": 1.0,
			"hitbox_daraltma": Vector2(0.8, 0.8) # Entegre kareye benzediği için kenarları az kırptık
		}
	],
	
	"SİGORTALAR": [
		{
			"id": "sigorta_1",
			"fiyat": 250,                   # Bu karakteri almak için 250 Skor gereklidir
			"resim": "res://Assets/Sprites/4a_csigorta.png",
			"boyut": 15.0, 
			"en_olcegi": 0.7,               # Bu karakter biraz daha ince görünmeli
			"hitbox_daraltma": Vector2(0.90, 0.80)
		}
	]
}

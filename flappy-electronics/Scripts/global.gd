extends Node

# Tüm oyunun (player, engeller, ana sahne) kontrol edeceği ana şalter
var oyun_basladi: bool = false
var toplam_skor: int = 0
var satin_alinanlar: Array = ["direnc_1"] # İlk karakter varsayılan olarak açık

# OYUN İLK AÇILDIĞINDAKİ VARSAYILAN KARAKTER (Burası eksik olduğu için küçük başlıyordu!)
var secilen_karakter = {
	"resim": "res://Assets/Sprites/resistor.png",
	"boyut": 30.0,
	"en_olcegi": 1.0,
	"hitbox_daraltma": Vector2(0.9, 0.4) 
}

var bilesen_katalogu = {
	"DİRENÇLER": [
		{
			"id": "direnc_1",
			"fiyat": 0,
			"resim": "res://Assets/Sprites/resistor.png",
			"boyut": 50.0,
			"en_olcegi": 1.0,
			"hitbox_daraltma": Vector2(0.75, 0.25) 
		}
	],
	
	"ENTEGRELER": [
		{
			"id": "entegre_1",
			"fiyat": 100, # Fiyatı buradan kolayca değiştirebilirsiniz
			"resim": "res://Assets/Sprites/mp1584.png",
			"boyut": 70.0,
			"en_olcegi": 1.0,
			"hitbox_daraltma": Vector2(0.8, 0.8) # Entegre daha karemsi, sadece şeffaf kenarları %20 kırptık
		}
	],
	
	"SİGORTALAR": [
		{
			"id": "sigorta_1",
			"fiyat": 250, # Fiyatı buradan kolayca değiştirebilirsiniz
			"resim": "res://Assets/Sprites/4a_csigorta.png",
			"boyut": 15.0, 
			"en_olcegi": 0.7,
			"hitbox_daraltma": Vector2(0.90, 0.80)
		}
	]
}

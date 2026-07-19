extends Node

# Tüm oyunun (player, engeller, ana sahne) kontrol edeceği ana şalter
var oyun_basladi: bool = false

# OYUN İLK AÇILDIĞINDAKİ VARSAYILAN KARAKTER (Burası eksik olduğu için küçük başlıyordu!)
var secilen_karakter = {
	"resim": "res://Assets/Sprites/resistor.png",
	"boyut": 30.0,
	"hitbox_daraltma": Vector2(0.9, 0.4) 
}

var bilesen_katalogu = {
	"DİRENÇLER": [
		{
			"resim": "res://Assets/Sprites/resistor.png",
			"boyut": 50.0,
			"hitbox_daraltma": Vector2(0.75, 0.25) 
		}
	],
	
	"ENTEGRELER": [
		{
			"resim": "res://Assets/Sprites/mp1584.png",
			"boyut": 70.0,
			"hitbox_daraltma": Vector2(0.8, 0.8) # Entegre daha karemsi, sadece şeffaf kenarları %20 kırptık
		}
	]
}

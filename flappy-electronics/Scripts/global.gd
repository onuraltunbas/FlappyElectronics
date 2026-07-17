extends Node

# Artık sadece resmi değil, o resme ait boyutu da bir paket (Dictionary) olarak tutuyoruz
var secilen_karakter = {
	"resim": "res://Assets/Sprites/resistor.png",
	"boyut": 30.0 # Direncin varsayılan boyutu
}

var bilesen_katalogu = {
	"DİRENÇLER": [
		{
			"resim": "res://Assets/Sprites/resistor.png",
			"boyut": 30.0 # Direnç ince olduğu için 30 yeterli
		}
	],
	
	"ENTEGRELER": [
		{
			"resim": "res://Assets/Sprites/mp1584.png",
			"boyut": 70.0 # Entegre devasa, o yüzden 70 veya 80 yapabilirsin!
		}
	]
}

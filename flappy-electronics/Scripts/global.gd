extends Node

# Oyun başladığında varsayılan olarak seçili olan karakterin resmi
var secilen_karakter_resmi = "res://Assets/Sprites/resistor.png"

# Kategoriler ve Bileşenler Veritabanı (Dictionary Mimarisi)
# Yarın yeni bir kategori veya eleman eklemek istersen SADECE BURAYA yazman yetecek!
var bilesen_katalogu = {
	"DİRENÇLER": [
		{
			"isim": "Karbon Film Direnç", 
			"resim": "res://Assets/Sprites/resistor.png", 
			"kilitli": false # İleride puanla açtırmak istersek diye şimdiden ekledim
		}
		# Buraya virgül koyup "Mavi Direnç", "Taş Direnç" vs. ekleyeceğiz.
	],
	
	"ENTEGRELER": [
		{
			"isim": "555 Zamanlayıcı", 
			"resim": "res://Assets/Sprites/555_timer.png", 
			"kilitli": false
		}
		# Buraya "Op-Amp", "Mikrodenetleyici" vs. ekleyeceğiz.
	]
	
	# Buraya "KONDANSATÖRLER", "TRANSİSTÖRLER" gibi sonsuz kategori eklenebilir.
}

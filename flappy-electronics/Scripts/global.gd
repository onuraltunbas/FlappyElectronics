extends Node

# Oyun başladığında varsayılan olarak seçili olan karakterin resmi
var secilen_karakter_resmi = "res://Assets/Sprites/resistor.png"

# Kategoriler ve Bileşenler Veritabanı (Dictionary Mimarisi)
# Yarın yeni bir kategori veya eleman eklemek istersen SADECE BURAYA yazman yetecek!
var bilesen_katalogu = {
	"DİRENÇLER": [
		{ 
			"resim": "res://Assets/Sprites/resistor.png", 
			"kilitli": false # İleride puanla açtırmak istersek diye şimdiden ekledim
		}
		# Buraya virgül koyup "Mavi Direnç", "Taş Direnç" vs. ekleyeceğiz.
	],
	
	"ENTEGRELER": [
		{
			"resim": "res://Assets/Sprites/mp1584.png", # Yeni entegremizin tam yolu
			"kilitli": false
		}
		# Buraya "Op-Amp", "Mikrodenetleyici" vs. ekleyeceğiz.
	]
	
	# Buraya "KONDANSATÖRLER", "TRANSİSTÖRLER" gibi sonsuz kategori eklenebilir.
}

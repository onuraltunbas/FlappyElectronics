extends Control

var kayit_yolu = "user://oyun_hafizasi.save"

func _ready():
	# Ekran açılır açılmaz hafızadaki rekoru okuyoruz
	var rekor = 0
	
	if FileAccess.file_exists(kayit_yolu):
		var dosya = FileAccess.open(kayit_yolu, FileAccess.READ)
		rekor = dosya.get_32()
		# son skoru da okuyup geçiyoruz (hata vermemesi için)
		var son_skor = dosya.get_32() 
		dosya.close()
		
	# Okuduğumuz rekoru ekrandaki tabelaya yazdırıyoruz
	$RekorTabelasi.text = "REKOR: " + str(rekor)

# Butona tıklandığında çalışacak olan fonksiyon
func _on_oyna_butonu_pressed():
	# Oyunu başlat (main_game sahnesine geçiş yap)
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")


func _on_bilesen_sec_butonu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/SecimEkrani.tscn")

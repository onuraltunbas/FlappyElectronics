extends Node2D

var engel_kalibi = preload("res://Scenes/engel.tscn")

# --- KONTROL PANELİMİZ (ARTIK HER ŞEY RASTGELE!) ---

@export_group("Fabrika Bant Hızı (Yatay Rastgelelik)")
@export var en_hizli_kapi: float = 1.0  # Bir kapı en erken kaç saniyede gelebilir?
@export var en_yavas_kapi: float = 2.5  # Bir kapı en geç kaç saniyede gelebilir?

@export_group("Yükseklik Sınırları (Oynaklık)")
@export var en_ust_delik: float = 350.0  
@export var en_alt_delik: float = 930.0  

@export_group("Delik Boyutu (Dikey Rastgelelik)")
@export var en_genis_delik: float = 800.0 # Bazen kocaman bir boşluk
@export var en_dar_delik: float = 600.0   # Bazen iğne deliği kadar dar

var skor: int = 0  
var bu_tur_kazanilan_para: int = 0

# --- HAFIZA SİSTEMİ ---
var kayit_yolu = "user://oyun_hafizasi.save" 

func _ready():
	# Eğer pause ekranı varsa, oyun durduğunda bile çalışabilmesi için ayarını yap
	if $Arayuz.has_node("DurdurmaEkrani"):
		$Arayuz/DurdurmaEkrani.process_mode = Node.PROCESS_MODE_ALWAYS
		
	hafizayi_yukle()
	# Oyun başlarken ilk kapının geliş süresini rastgele kur
	$Timer.wait_time = randf_range(en_hizli_kapi, en_yavas_kapi)

func _on_timer_timeout():
	if not Global.oyun_basladi:
		return # Oyun başlamadıysa yeni engel yaratma, bekle!
	var yeni_kapi = engel_kalibi.instantiate()
	
	# 1. Deliğin ekrandaki yüksekliği tamamen rastgele (Aşırı oynak)
	var rastgele_y = randf_range(en_ust_delik, en_alt_delik)
	yeni_kapi.position = Vector2(800, rastgele_y)
	
	# 2. Deliğin büyüklüğü (aralık) tamamen rastgele
	var rastgele_bosluk = randf_range(en_dar_delik, en_genis_delik)
	yeni_kapi.aralik_ayarla(rastgele_bosluk)
		
	add_child(yeni_kapi)
	
	# 3. MUHTEŞEM DOKUNUŞ: Bir sonraki kapının ne zaman geleceğini de rastgele kur!
	$Timer.wait_time = randf_range(en_hizli_kapi, en_yavas_kapi)

# --- SKOR VE SİNYAL BÖLÜMÜ ---

func puan_arttir():
	skor += 1
	$Arayuz/PuanTabelasi.text = "Skor: " + str(skor)
	
	# Toplam skoru (parayı) da anında artır
	bu_tur_kazanilan_para += 1
	Global.toplam_skor += 1
	if $Arayuz.has_node("ToplamSkorTabelasi"):
		$Arayuz/ToplamSkorTabelasi.text = "Toplam Skor: " + str(Global.toplam_skor)

func oyunu_bitir():
	Global.oyun_basladi = false # EKLENDİ: Oyun bitince her şey (engeller, yeni engellerin gelişi) dursun!
	hafizayi_kaydet()
	
	# Sahnede GameOverEkrani varsa göster, yoksa mecburen yeniden başlat
	if $Arayuz.has_node("GameOverEkrani"):
		$Arayuz/GameOverEkrani.show()
	else:
		get_tree().call_deferred("reload_current_scene")

func bonus_para_ekle(miktar: int):
	bu_tur_kazanilan_para += miktar
	Global.toplam_skor += miktar
	if $Arayuz.has_node("ToplamSkorTabelasi"):
		$Arayuz/ToplamSkorTabelasi.text = "Toplam Skor: " + str(Global.toplam_skor)

# --- BUTON SİNYALLERİ VE OYUNU DURDURMA ---

# Godot Editör'de butondan buraya sinyal bağlayacağız (Game Over Ekranı)
func _on_yeniden_baslat_butonu_pressed():
	get_tree().call_deferred("reload_current_scene")

func _on_gameover_ana_menu_pressed():
	# Game Over olunduğunda kazanılan para oyuncunun hakkıdır, silinmez!
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")

# --- DURDURMA (PAUSE) MENÜSÜ SİNYALLERİ ---

func _on_durdurma_butonu_pressed():
	if Global.oyun_basladi:
		get_tree().paused = true
		if $Arayuz.has_node("DurdurmaEkrani"):
			$Arayuz/DurdurmaEkrani.show()

func _on_devam_et_butonu_pressed():
	get_tree().paused = false
	if $Arayuz.has_node("DurdurmaEkrani"):
		$Arayuz/DurdurmaEkrani.hide()

func kazanci_iptal_et_ve_cikis(hedef_sahne: String):
	# Oyundan kaçıldığı için bu tur kazanılan parayı (ve skoru) geri siliyoruz
	Global.toplam_skor -= bu_tur_kazanilan_para
	bu_tur_kazanilan_para = 0
	hafizayi_kaydet()
	get_tree().paused = false
	get_tree().change_scene_to_file(hedef_sahne)

func _on_durdurma_yeniden_baslat_pressed():
	kazanci_iptal_et_ve_cikis("res://Scenes/main_game.tscn")

func _on_durdurma_ana_menu_pressed():
	kazanci_iptal_et_ve_cikis("res://Scenes/start_menu.tscn")

# --- KAYIT SİSTEMİ ---

func hafizayi_kaydet():
	var dosya = FileAccess.open(kayit_yolu, FileAccess.WRITE)
	dosya.store_var(Global.toplam_skor)
	dosya.store_var(Global.satin_alinanlar)
	dosya.close()

func hafizayi_yukle():
	if FileAccess.file_exists(kayit_yolu):
		var dosya = FileAccess.open(kayit_yolu, FileAccess.READ)
		var okunan_skor = dosya.get_var()
		var okunan_liste = dosya.get_var()
		if okunan_skor != null: Global.toplam_skor = okunan_skor
		if okunan_liste != null: Global.satin_alinanlar = okunan_liste
		dosya.close()
	
	if $Arayuz.has_node("ToplamSkorTabelasi"):
		$Arayuz/ToplamSkorTabelasi.text = "Toplam Skor: " + str(Global.toplam_skor)


func _on_button_pressed() -> void:
	pass # Replace with function body.

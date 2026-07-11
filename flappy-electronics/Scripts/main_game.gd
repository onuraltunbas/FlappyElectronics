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

# --- HAFIZA SİSTEMİ ---
var kayit_yolu = "user://oyun_hafizasi.save" 
var rekor: int = 0
var son_skor: int = 0

func _ready():
	hafizayi_yukle()
	# Oyun başlarken ilk kapının geliş süresini rastgele kur
	$Timer.wait_time = randf_range(en_hizli_kapi, en_yavas_kapi)

func _on_timer_timeout():
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
	$Arayuz/PuanTabelasi.text = str(skor)

func oyunu_bitir():
	son_skor = skor
	if skor > rekor:
		rekor = skor
	
	hafizayi_kaydet()
	get_tree().call_deferred("reload_current_scene")

func hafizayi_kaydet():
	var dosya = FileAccess.open(kayit_yolu, FileAccess.WRITE)
	dosya.store_32(rekor)
	dosya.store_32(son_skor)
	dosya.close()

func hafizayi_yukle():
	if FileAccess.file_exists(kayit_yolu):
		var dosya = FileAccess.open(kayit_yolu, FileAccess.READ)
		rekor = dosya.get_32()
		son_skor = dosya.get_32()
		dosya.close()
	
	$Arayuz/RekorTabelasi.text = "Rekor: " + str(rekor)
	$Arayuz/SonSkorTabelasi.text = "Son Skor: " + str(son_skor)

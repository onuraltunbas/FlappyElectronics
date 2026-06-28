extends Node2D

var engel_kalibi = preload("res://Scenes/engel.tscn")

@export_group("Fabrika Bant Hızı")
@export var uretim_sikligi: float = 1.6  

@export_group("Yükseklik Sınırları")
@export var en_ust_delik: float = 350.0  
@export var en_alt_delik: float = 930.0  

@export_group("Zorluk ve Daralma Ayarları")
@export var baslangic_genisligi: float = 800.0 
@export var en_dar_sinir: float = 400.0        
@export var daralma_hizi: float = 25.0          

var anlik_mesafe: float
var skor: int = 0  

# --- YENİ HAFIZA SİSTEMİ ---
var kayit_yolu = "user://oyun_hafizasi.save" # Telefonun güvenli kasası
var rekor: int = 0
var son_skor: int = 0

func _ready():
	anlik_mesafe = baslangic_genisligi
	$Timer.wait_time = uretim_sikligi
	hafizayi_yukle() # Oyun açılır açılmaz dosyayı oku!

func _on_timer_timeout():
	var yeni_kapi = engel_kalibi.instantiate()
	var rastgele_y = randf_range(en_ust_delik, en_alt_delik)
	yeni_kapi.position = Vector2(800, rastgele_y)
	yeni_kapi.aralik_ayarla(anlik_mesafe)
	
	if anlik_mesafe > en_dar_sinir:
		anlik_mesafe -= daralma_hizi
		
	add_child(yeni_kapi)

func puan_arttir():
	skor += 1
	$Arayuz/PuanTabelasi.text = str(skor)

# --- TELEFONA KAYDETME VE BİTİRME MOTORU ---

func oyunu_bitir():
	son_skor = skor
	if skor > rekor:
		rekor = skor
	
	hafizayi_kaydet()
	get_tree().call_deferred("reload_current_scene") # Kaydettikten sonra başa sar

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
	
	# Tabelalara yazdır
	$Arayuz/RekorTabelasi.text = "Rekor: " + str(rekor)
	$Arayuz/SonSkorTabelasi.text = "Son Skor: " + str(son_skor)

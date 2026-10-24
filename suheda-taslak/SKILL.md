
---
name: ciltizi-development
description: >-
  ciltİzi kişiselleştirilmiş kozmetik içerik analizi
  Flutter uygulamasının geliştirme kılavuzu.
  Clean Architecture, SOLID, Riverpod, Hive CE,
  OCR, INCI normalizasyonu, cilt profili,
  ürün kütüphanesi, kullanıcı deneyimleri,
  kişiselleştirilmiş içerik eşleştirme,
  uygunluk skoru, Material 3, güvenlik,
  test ve sürüm yönetimini kapsar.
  ciltİzi projesinde özellik geliştirirken,
  kod yazarken, ekran tasarlarken,
  algoritma oluştururken, veritabanı işlemlerinde,
  hata düzeltirken veya refactoring yaparken kullan.
---

# ciltİzi - Geliştirici Kılavuzu

Bu doküman, ciltİzi Flutter projesinde çalışan
Antigravity AI Agent ve geliştiriciler için
bağlayıcı geliştirme standartlarını tanımlar.

**Temel amaç:** Kullanıcıların kozmetik ürünlerle
yaşadıkları deneyimleri INCI içerik listeleriyle
karşılaştırarak kişiselleştirilmiş içerik analizi
yapabilen, güvenilir ve sürdürülebilir bir
mobil uygulama geliştirmek.

Agent, görevlerini mevcut proje mimarisini,
kullanıcı verilerini ve çalışan özellikleri
koruyarak gerçekleştirmelidir.

---

# 1. PROJE TANIMI VE TEKNOLOJİLER

## 1.1. Proje Bilgileri

| Özellik | Değer |
|---|---|
| Uygulama adı | ciltİzi |
| Paket adı | ciltizi |
| Proje türü | Flutter uygulaması |
| Flutter SDK | 3.47.7 |
| Dart SDK | 3.13.5 |
| Mimari yaklaşım | Local-First, Clean Architecture |
| Tasarım sistemi | Material Design 3 |
| Durum yönetimi | Riverpod |
| Yerel veritabanı | Hive CE |
| Varsayılan dil | Türkçe |
| Ek dil | İngilizce |
| Temalar | Light / Dark |
| Öncelikli platformlar | Android / iOS |
| Gelecek platformlar | Web / Masaüstü |

Uygulama, temel özellikleri için harici bir
backend veya sürekli internet bağlantısı
gerektirmemelidir.

## 1.2. Teknolojik Altyapı

| Paket | Sorumluluk |
|---|---|
| flutter_riverpod | Reaktif durum yönetimi |
| hive_ce | Yerel veri saklama |
| hive_ce_flutter | Flutter-Hive entegrasyonu |
| google_mlkit_text_recognition | OCR metin tanıma |
| image_picker | Kamera ve galeri |
| path_provider | Dosya dizinleri |
| intl | Yerelleştirme ve tarih biçimlendirme |
| flutter_localizations | Flutter dil desteği |
| uuid | Benzersiz kayıt kimlikleri |
| cupertino_icons | iOS uyumlu ikonlar |
| flutter_test | Otomatik testler |
| flutter_lints | Kod kalitesi |

Paket ekleme veya değiştirme öncesinde
mevcut pubspec.yaml kontrol edilmelidir.

Yeni bağımlılıklar yalnızca gerekli olduğunda
ve SDK uyumluluğu doğrulandıktan sonra eklenir.

Hive model kod üretimi kullanılacaksa
hive_ce_generator ve build_runner
geliştirme bağımlılıklarına eklenmelidir.

## 1.3. Platform Stratejisi

İlk geliştirme hedefi Android ve iOS'tur.

Google ML Kit tabanlı OCR işlevi,
desteklenen mobil platformlarda çalışmalıdır.

Web ve masaüstünde desteklenmeyen OCR
özellikleri için manuel içerik girişi
alternatifi sunulmalıdır.

Desteklenmeyen özellikler uygulamanın
diğer işlevlerini engellememelidir.

---

# 2. UYGULAMA ÖZELLİKLERİ

## 2.1. Cilt Profili

Kullanıcı kişiselleştirilmiş analizler için
bir cilt profili oluşturabilir ve düzenleyebilir.

### Cilt Tipleri

- Normal
- Kuru
- Yağlı
- Karma

### Cilt Problemleri ve Özellikleri

- Hassasiyet
- Akne eğilimi
- Aktif akne
- Kızarıklık
- Rozasea
- Kuruluk
- Diğer kullanıcı tanımlı problemler

Cilt tipi ile cilt problemleri farklı
alanlarda saklanmalıdır.

### Bileşen Tercihleri

Kullanıcı iki farklı liste oluşturabilir:

1. Bildirdiği alerjenler
2. Kaçınmak istediği bileşenler

Örnek tercihler:

- Parfüm
- Belirli alkol türleri
- Parabenler
- Sülfatlar
- Uçucu yağlar
- Kullanıcı tarafından eklenen maddeler

Madde aileleri, farklı kimyasal bileşenleri
yanlışlıkla aynı kabul edecek şekilde
otomatik birleştirilmemelidir.

Profil, skin_profile_box içerisinde
tekil kullanıcı yapılandırması olarak saklanır.

## 2.2. Ürün Kütüphanesi

Kullanıcı kozmetik ürünlerini
ekleyebilir, düzenleyebilir, listeleyebilir
ve gerektiğinde silebilir.

### Ürün Bilgileri

- Ürün adı
- Marka
- Kategori
- Orijinal INCI listesi
- Normalize edilmiş INCI listesi
- Kayıt tarihi
- Güncelleme tarihi

### Ürün Kategorileri

- Temizleyici
- Tonik
- Serum
- Nemlendirici
- Güneş kremi
- Maske
- Peeling
- Diğer

### İçerik Ekleme Yöntemleri

1. Manuel metin girişi
2. Metin yapıştırma
3. Kamera ile OCR
4. Galeriden OCR
5. Örnek bileşen listesinden seçim

### Ürün Listeleme

- Kullanıcı ürünleri
- Başlangıç ürünleri
- Ürün arama
- Kategori filtreleme
- Ürün detay ekranı

Başlangıç ürünleri assets/products.json
dosyasından yüklenebilir.

## 2.3. Kullanıcı Deneyimleri

Kullanıcı denediği ürünler hakkında
kişisel değerlendirme oluşturabilir.

### Puanlama

1 ile 5 arasında ürün puanı verilir.

### Olumlu Etkiler

- Nemlendirdi
- Yatıştırdı
- Matlaştırdı
- Aydınlattı
- Cildimi yumuşattı

### Olumsuz Etkiler

- Sivilce yaptı
- Tahriş etti
- Kızarıklık yaptı
- Kuruluk yaptı
- Kaşıntı yaptı
- Komedon yaptı

### Ek Bilgiler

- Serbest kullanıcı notu
- Kullanım süresi
- Deneyim tarihi

Kullanıcı geçmiş değerlendirmelerini
görüntüleyebilmeli, düzenleyebilmeli
ve silebilmelidir.

Ürün puanı ile reaksiyon etiketleri
birlikte değerlendirilmelidir.

---

# 3. VERİ MODELLERİ VE DEPOLAMA

## 3.1. Temel Modeller

### SkinProfile

- id
- skinType
- skinConcerns
- knownAllergens
- avoidedIngredients
- createdAt
- updatedAt

### Product

- id
- name
- brand
- category
- rawIngredients
- normalizedIngredients
- createdAt
- updatedAt

### ProductReview

- id
- productId
- rating
- positiveReactions
- negativeReactions
- notes
- usageDuration
- createdAt
- updatedAt

### AnalysisResult

- id
- productId
- score
- matchedAvoidedIngredients
- matchedSuspectedIngredients
- evidenceSummary
- warnings
- analyzedAt
- algorithmVersion

### AppSettings

- themeMode
- languageCode

Model alanları geliştirme ihtiyaçlarına
göre genişletilebilir.

Temel model kuralları:

- Null safety kullanılmalıdır.
- Kayıtlar benzersiz kimliğe sahip olmalıdır.
- Tarihler DateTime olarak işlenmelidir.
- Mümkün olduğunca immutable modeller kullanılmalıdır.
- Geçersiz veri girişleri doğrulanmalıdır.
- Model değişikliklerinde veri uyumluluğu korunmalıdır.

## 3.2. Hive CE Box Yapısı

| Box | İçerik |
|---|---|
| skin_profile_box | Kullanıcı cilt profili |
| products_box | Ürün kayıtları |
| reviews_box | Kullanıcı değerlendirmeleri |
| analysis_history_box | Analiz geçmişi |
| settings_box | Tema ve dil tercihleri |

Hive uygulama başlangıcında
initialize edilmelidir.

Veritabanı işlemleri yalnızca
data katmanı üzerinden gerçekleştirilmelidir.

## 3.3. Başlangıç Verileri

assets/products.json ilk kurulumda
örnek ürün verisi sağlayabilir.

Yükleme kuralları:

1. JSON yapısını doğrula.
2. Tekrarlanan kayıtları engelle.
3. Kullanıcı verilerini değiştirme.
4. Seed veri sürümünü takip et.
5. Hatalı veya eksik dosyaları yönet.

Gerçek ürünlerin INCI listeleri
doğrulanmadan üretilmemelidir.

## 3.4. Veri Bütünlüğü

- Kullanıcı verileri güncelleme sırasında korunmalıdır.
- Hive model değişikliklerinde geçiş planı uygulanmalıdır.
- Adapter kimlikleri ve alan indeksleri korunmalıdır.
- Silme işlemlerinde ilişkili kayıtlar dikkate alınmalıdır.
- Beklenmeyen depolama hataları yönetilmelidir.
- Gerekli durumlarda güvenli veri yedekleme
  veya dışa aktarma altyapısı tasarlanabilir.

---

# 4. INCI İŞLEME VE OCR

## 4.1. INCI Ayrıştırma

Kullanıcının girdiği standart virgülle
ayrılmış INCI listesi bileşenlere dönüştürülür.

Temel Dart işlemi:

```dart
final ingredients = rawText
    .split(',')
    .map((item) => item.trim())
    .where((item) => item.isNotEmpty)
    .toList();
```

Bu işlem standart metin girişleri içindir.

OCR çıktıları önce temizlenmeli,
ardından ayrıştırılmalıdır.

## 4.2. Normalizasyon

INCI normalizasyonunda:

1. Gereksiz boşluklar kaldırılır.
2. Harf büyüklüğü eşitleştirilir.
3. Bilinen yazım farklılıkları düzeltilir.
4. Doğrulanmış eş adlar eşleştirilir.
5. Yinelenen bileşenler tespit edilir.
6. Orijinal metin ayrıca korunur.

Örnek:

- Aqua
- Water

Doğrulanmış eş ad sözlüğüne göre
aynı bileşene karşılık gelebilir.

Ancak benzer ad taşıyan farklı
kimyasal maddeler birleştirilmemelidir.

## 4.3. OCR İş Akışı

1. Kamera veya galeri seçilir.
2. Platform desteği ve gerekli izinler kontrol edilir.
3. Görsel image_picker ile alınır.
4. ML Kit metin tanıma işlemi yapılır.
5. Olası INCI bölümü belirlenir.
6. Metin ve satır sonları temizlenir.
7. Sonuç düzenlenebilir alanda gösterilir.
8. Kullanıcı içeriği doğrular.
9. Bileşenler normalize edilir.
10. Onaylanan içerikler kaydedilir.

OCR metni kesin doğru kabul edilmemelidir.

Özellikle satır sonları doğrudan virgüle
dönüştürülmeden önce incelenmelidir.

## 4.4. Arayüz ve Hata Yönetimi

- İçerikler Wrap içinde Chip veya InputChip
  bileşenleriyle gösterilebilir.
- Kullanıcı bileşenleri düzenleyebilmelidir.
- Uzun listeler kaydırılabilir olmalıdır.
- Boş OCR çıktısı açıklanmalıdır.
- İzin hataları yönetilmelidir.
- OCR sırasında loading durumu gösterilmelidir.
- İşlem sonrası kullanılan kaynaklar kapatılmalıdır.

---

# 5. KİŞİSEL İÇERİK ANALİZİ

## 5.1. Analiz Yaklaşımı

ciltİzi analiz motoru kullanıcının geçmiş
ürün deneyimleriyle yeni ürünlerin
INCI listelerini karşılaştırır.

Algoritma şu veri kaynaklarını kullanır:

- Cilt profili
- Bilinen alerjenler
- Kaçınılan bileşenler
- Olumlu ürün deneyimleri
- Olumsuz ürün deneyimleri
- Ürün INCI listeleri

Amaç, kullanıcıya özgü olası
uyumlu ve şüpheli bileşen örüntülerini
belirlemektir.

## 5.2. Olumlu Deneyim Analizi

Olumlu değerlendirilen ürünlerin
bileşenleri bir araya getirilir.

Bu bilgilerden "Olumlu Deneyim
İçerikleri" listesi oluşturulur.

Liste, kullanıcının olumlu deneyim
yaşadığı ürünlerde görülen bileşenleri içerir.

Bir bileşenin bu listede bulunması
onun kesin güvenli olduğunu göstermez.

## 5.3. Olumsuz Deneyim Analizi

Olumsuz reaksiyon bildirilen ürünlerin
INCI listeleri karşılaştırılır.

Her bileşen için:

- Kaç farklı olumsuz üründe bulunduğu
- Kaç olumlu üründe bulunduğu
- Hangi reaksiyonlarla birlikte görüldüğü

hesaplanabilir.

Tekrarlanan değerlendirmeler
bağımsız ürün sayısını artırmamalıdır.

## 5.4. Şüpheli İçerik Belirleme

Başlangıç algoritmasında:

Bir bileşen en az iki farklı
olumsuz değerlendirilmiş üründe
bulunuyorsa şüpheli aday sayılır.

Örnek:

Olumsuz Ürün A:
- Aqua
- Niacinamide
- Glycerin

Olumsuz Ürün B:
- Aqua
- Niacinamide
- Panthenol

Bu iki üründe ortak bileşenler:

- Aqua
- Niacinamide

Ancak her ortak bileşen doğrudan
reaksiyon nedeni kabul edilmez.

Olumlu ürünlerdeki görülme sıklığı
ve diğer deneyimler de değerlendirilir.

## 5.5. Olumlu ve Olumsuz Veri Eşleştirmesi

Olumlu deneyim listesi, olumsuz
ürün analizinde karşılaştırma amacıyla kullanılır.

Olumlu ürünlerde bulunan bileşenler
otomatik olarak şüpheli listesinden çıkarılmaz.

Algoritma bir bileşenin hem olumlu
hem olumsuz ürünlerde görülmesini
kullanıcıya açıklayabilmelidir.

Bilinen alerjenler hiçbir koşulda
olumlu deneyim nedeniyle güvenli
olarak etiketlenmemelidir.

## 5.6. Kanıt Seviyesi

Analiz sonuçlarında veri miktarı
ve tutarlılığı dikkate alınmalıdır.

Önerilen seviyeler:

- Yetersiz veri
- Düşük güven
- Orta güven
- Daha güçlü kişisel örüntü

Bu seviyeler tıbbi kesinlik belirtmez.

Şüpheli içerik listesi ve değerlendirme
sonuçları yeni kullanıcı deneyimleriyle
yeniden hesaplanabilmelidir.

---

# 6. UYGUNLUK SKORU VE ANALİZ SONUCU

## 6.1. Yeni Ürün Sorgulama

Kullanıcı yeni bir ürünün INCI listesini
manuel olarak veya OCR ile girer.

Sistem:

1. İçerikleri ayrıştırır.
2. Bileşenleri normalize eder.
3. Kullanıcının kaçındığı maddeleri eşleştirir.
4. Şüpheli bileşen adaylarını belirler.
5. Geçmiş olumlu deneyimlerle karşılaştırır.
6. Kanıt seviyesini değerlendirir.
7. Uygunluk skorunu hesaplar.
8. Sonucu gerekçeleriyle sunar.

## 6.2. Başlangıç Skor Formülü

Başlangıç değeri: 100

Ceza ağırlıkları:

- Eşleşen kaçınılan bileşen: 25 puan
- Şüpheli bileşen: 20 puan

Formül:

```text
score = max(
  0,
  100
  - (avoidedIngredientCount * 25)
  - (suspectedIngredientCount * 20)
)
```

Skor 0-100 aralığında tutulmalıdır.

Aynı bileşen aynı kategoride
birden fazla kez sayılmamalıdır.

Bir bileşen birden fazla kategoriye
giriyorsa çift ceza yerine belirlenmiş
öncelik kuralı uygulanmalıdır.

Bu formül deneysel başlangıç modelidir;
klinik olarak doğrulanmış bir güvenlik
olasılığı olarak sunulmamalıdır.

## 6.3. Alerjen Uyarıları

Kullanıcının bildirdiği alerjenler
skordan bağımsız değerlendirilmelidir.

Eşleşen alerjen varsa:

- Açık uyarı gösterilir.
- Bileşen adı belirtilir.
- Kullanıcının bildirimi esas alınır.

Yüksek skor, alerjen uyarısını
geçersiz kılamaz.

## 6.4. Analiz Ekranı

Analiz sonucu şu bilgileri göstermelidir:

- Ürün adı
- Kişisel uygunluk skoru
- Eşleşen kaçınılan bileşenler
- Şüpheli bileşenler
- Olumlu deneyimlerde görülen bileşenler
- Analiz gerekçeleri
- Veri güvenilirliği
- Gerekli uyarılar

Örnek açıklama:

"Bu üründe, daha önce olumsuz deneyim
yaşadığın iki farklı üründe de bulunan
bir bileşen tespit edildi."

"Bu eşleşme, bileşenin reaksiyona
neden olduğunu kesin olarak göstermez."

Yetersiz veri durumunda sistem
kesin uygunluk iddiasında bulunmamalıdır.

## 6.5. Analiz Motoru Kuralları

- İş mantığı arayüzden bağımsız olmalıdır.
- Aynı girdiler aynı sonucu üretmelidir.
- Hesaplamalar otomatik testlerle doğrulanmalıdır.
- Eksik veriler yönetilmelidir.
- Algoritma sürümü kayıt altına alınmalıdır.
- Sonuçlar açıklanabilir olmalıdır.
- Analiz geçmişi Hive üzerinde saklanmalıdır.

---

# 7. YAZILIM MİMARİSİ

## 7.1. Mimari İlkeler

Kod aşağıdaki prensiplere uygun olmalıdır:

- SOLID
- Clean Architecture
- Separation of Concerns
- DRY
- KISS
- Dependency Inversion
- Test edilebilirlik
- Modülerlik

Gereksiz soyutlamalar oluşturulmamalıdır.

## 7.2. Katman Sorumlulukları

### Presentation

İçerik:

- Screens
- Widgets
- Riverpod Providers
- Kullanıcı etkileşimleri
- Loading / Error / Empty durumları

Veritabanı ve analiz algoritması
doğrudan widget içinde bulunmamalıdır.

### Domain

İçerik:

- İş kuralları
- Domain modelleri
- Repository arayüzleri
- Analiz servisleri
- INCI normalizasyonu
- Uygunluk skoru hesaplama

Domain katmanı Flutter UI ve Hive
altyapısından bağımsız tutulmalıdır.

### Data

İçerik:

- Hive modelleri
- Data sources
- Repository implementasyonları
- Model dönüştürme
- Seed data işlemleri

## 7.3. Bağımlılık Yönü

```text
Presentation ──> Domain <── Data
```

Arayüz veritabanının nasıl çalıştığını
bilmek zorunda olmamalıdır.

## 7.4. Proje Klasör Yapısı

```text
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   ├── errors/
│   ├── localization/
│   └── widgets/
│
├── domain/
│   ├── models/
│   ├── repositories/
│   └── services/
│
├── data/
│   ├── models/
│   ├── datasources/
│   ├── repositories/
│   └── seed/
│
├── features/
│   ├── onboarding/
│   │   └── presentation/
│   ├── profile/
│   │   ├── presentation/
│   │   ├── providers/
│   │   └── widgets/
│   ├── products/
│   │   ├── presentation/
│   │   ├── providers/
│   │   └── widgets/
│   ├── reviews/
│   │   ├── presentation/
│   │   ├── providers/
│   │   └── widgets/
│   ├── analysis/
│   │   ├── presentation/
│   │   ├── providers/
│   │   └── widgets/
│   └── settings/
│       ├── presentation/
│       └── providers/
│
├── app.dart
└── main.dart

assets/
├── images/
└── products.json

test/
├── domain/
├── data/
└── features/
```

Klasörler sorumluluklarına göre kullanılmalıdır.

Yeni feature eklenirken mevcut yapıyla
tutarlılık korunmalıdır.

Ortak bileşenler core altında,
özelliğe özel bileşenler kendi
feature klasöründe tutulmalıdır.

---

# 8. STATE MANAGEMENT VE UI/UX

## 8.1. Riverpod Kullanımı

Aşağıdaki uygulama durumları Riverpod
üzerinden yönetilmelidir:

- Kullanıcı profili
- Ürün kütüphanesi
- Ürün detayları
- Deneyim kayıtları
- OCR işlemleri
- Analiz sonuçları
- Tema tercihi
- Dil tercihi

Provider yapıları tek sorumluluğa
odaklanmalıdır.

Asenkron işlemlerin loading, error
ve data durumları yönetilmelidir.

## 8.2. Arayüz Tasarımı

Material Design 3 kullanılmalıdır.

Tasarım özellikleri:

- Modern
- Minimal
- Tutarlı
- Erişilebilir
- Responsive
- Anlaşılır

Renkler, yazı stilleri ve ortak
bileşenler merkezi tema sistemi
üzerinden yönetilmelidir.

Uyarılar yalnızca renkle değil,
metin ve ikonlarla da belirtilmelidir.

## 8.3. Tema Yönetimi

Light ve Dark tema desteklenmelidir.

AppBar üzerinde IconButton ile
anlık ve animasyonlu tema geçişi
sağlanabilir.

Tema tercihi settings_box
içerisinde saklanmalıdır.

## 8.4. Dil Desteği

- Varsayılan dil Türkçedir.
- İngilizce desteği sağlanmalıdır.
- Arayüz metinleri merkezi
  yerelleştirme sistemiyle yönetilmelidir.
- Kullanıcı dil tercihi saklanmalıdır.

## 8.5. Kullanılabilirlik

- Formlar doğrulanmalıdır.
- İşlemler kullanıcıya geri bildirim vermelidir.
- Boş ekranlar açıklayıcı olmalıdır.
- Hatalar anlaşılır dille gösterilmelidir.
- Uzun işlemlerde yükleme göstergesi kullanılmalıdır.
- Kritik silme işlemleri kontrollü olmalıdır.
- Ekranlar farklı boyutlara uyum sağlamalıdır.

---

# 9. GÜVENLİK VE GİZLİLİK

## 9.1. Kişisel Veriler

Cilt profili, alerjen bildirimleri
ve kullanıcı deneyimleri kişisel
veri olarak ele alınmalıdır.

Kurallar:

1. Gereksiz veri toplama.
2. Verileri izinsiz paylaşma.
3. Hassas bilgileri loglama.
4. Gizli anahtarları kaynak koda yazma.
5. Gerektiğinde verileri şifrele.
6. Şifreleme anahtarlarını güvenli sakla.
7. Kullanıcıya veri silme imkânı sağla.
8. Veritabanı erişimlerini kontrol et.

## 9.2. Tıbbi Sınırlar

ciltİzi tıbbi teşhis uygulaması değildir.

Uygulama:

- Alerji teşhisi koymamalıdır.
- Tedavi önermemelidir.
- İçerikleri kesin güvenli ilan etmemelidir.
- Kanıtlanmamış bilimsel iddialar üretmemelidir.

Kullanıcı deneyimlerinden çıkarılan
örüntüler tıbbi nedensellik kanıtı
olarak gösterilmemelidir.

---

# 10. TEST VE KALİTE KONTROLÜ

## 10.1. Unit Test

Test edilmesi gereken alanlar:

- INCI ayrıştırma
- Metin normalizasyonu
- Eş ad eşleştirme
- Olumlu ve olumsuz içerik karşılaştırması
- Şüpheli bileşen belirleme
- Uygunluk skoru
- Çift ceza engelleme
- Eksik veri ve sınır durumları
- Veri doğrulama

## 10.2. Widget Test

- Profil formu
- Ürün ekleme
- Ürün listesi
- Deneyim kaydı
- Analiz ekranı
- Tema değişimi
- Loading / Error / Empty durumları

## 10.3. Integration Test

Temel kullanıcı akışı:

1. Profil oluşturma
2. Ürün ekleme
3. İçerik listesi kaydetme
4. Deneyim oluşturma
5. Yeni ürün analiz etme
6. Analiz geçmişini görüntüleme
7. Veriyi güncelleme ve silme

OCR gerçek cihazda ve desteklenen
platformlarda ayrıca test edilmelidir.

## 10.4. Kalite Kriterleri

- Kritik algoritmalar test edilmiş olmalıdır.
- Yeni kod mevcut testleri bozmamalıdır.
- Testler birbirinden bağımsız olmalıdır.
- Gerçek kullanıcı verileri testlerde kullanılmamalıdır.
- Hatalar gizlenmemelidir.
- Çalıştırılmayan testler başarılı gösterilmemelidir.

---

# 11. AGENT GELİŞTİRME İŞ AKIŞI

Antigravity Agent her geliştirme
görevinde aşağıdaki sırayı izlemelidir.

## 11.1. Analyze

1. Kullanıcı isteğini incele.
2. İlgili dosyaları oku.
3. Mevcut mimariyi değerlendir.
4. Bağımlılıkları kontrol et.
5. Etkilenecek özellikleri belirle.

## 11.2. Plan

1. Yapılacak değişiklikleri belirle.
2. Gerekli dosyaları listele.
3. Mevcut bileşenlerin yeniden
   kullanılabilirliğini kontrol et.
4. Veri kaybı ve uyumluluk risklerini değerlendir.

## 11.3. Implement

1. Mimariye uygun kod yaz.
2. Var olan kod standartlarını koru.
3. Hata durumlarını yönet.
4. Gereksiz tekrar ve bağımlılıklardan kaçın.
5. Yalnızca ilgili dosyaları değiştir.

## 11.4. Verify

1. Kod biçimlendirmesini kontrol et.
2. Statik analiz çalıştır.
3. İlgili testleri çalıştır.
4. Mevcut işlevlerin korunduğunu kontrol et.
5. Tespit edilen sorunları değerlendir.

## 11.5. Report

Görev sonunda şu bilgiler raporlanmalıdır:

- Yapılan değişiklikler
- Eklenen dosyalar
- Düzenlenen dosyalar
- Çalıştırılan testler
- Test sonuçları
- Kalan sorunlar

## 11.6. Değişiklik Sınırları

Agent aşağıdaki kurallara uymalıdır:

- Kullanıcı istemedikçe çalışan özellik silme.
- İlgisiz kodu yeniden yazma.
- Mimariyi gerekçesiz değiştirme.
- Gereksiz sınıf veya klasör oluşturma.
- Mevcut kullanıcı verilerini bozma.
- Doğrulanmamış sonucu kesin gösterme.
- Yapılmayan işlemi yapılmış gibi raporlama.
- Açıkça istenmedikçe commit, push,
  merge veya release gerçekleştirme.

---

# 12. GIT, SÜRÜM VE GELİŞTİRME KOMUTLARI

## 12.1. Git Standartları

Conventional Commits kullanılabilir.

Örnekler:

```text
feat: add skin profile screen
feat: implement ingredient analysis
fix: correct ingredient normalization
refactor: extract analysis service
test: add score calculation tests
docs: update development guidelines
```

Kurallar:

- Hassas bilgiler repoya eklenmemelidir.
- .gitignore kurallarına uyulmalıdır.
- Commit mesajları anlamlı olmalıdır.
- İlgisiz değişiklikler aynı commit'e alınmamalıdır.

## 12.2. Sürüm Yönetimi

Sürüm pubspec.yaml üzerinden yönetilir.

Örnek:

```yaml
version: 0.1.0+1
```

Sürüm artırma ve yayınlama
kullanıcı talimatına bağlıdır.

## 12.3. Geliştirme Komutları

Flutter kontrolü:

```bash
flutter --version
```

Paket yükleme:

```bash
flutter pub get
```

Kod biçimlendirme:

```bash
dart format lib test
```

Statik analiz:

```bash
flutter analyze
```

Test:

```bash
flutter test
```

Uygulama çalıştırma:

```bash
flutter run
```

Hive kod üretimi gerekiyorsa ve
generator bağımlılıkları kuruluysa:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

# GELİŞTİRME ÖNCELİKLERİ

Karar verirken aşağıdaki öncelik sırası
dikkate alınmalıdır:

1. Kullanıcı verilerinin korunması
2. Analiz algoritmasının doğruluğu
3. Analiz sonuçlarının açıklanabilirliği
4. Mevcut işlevlerin korunması
5. Kodun sürdürülebilirliği
6. Test edilebilirlik
7. Kullanıcı deneyimi
8. Performans
9. Görsel tutarlılık

# TAMAMLANMA TANIMI

Bir geliştirme görevi, aşağıdaki
kontroller yapılmadan tamamlanmış
olarak raporlanmamalıdır:

- İstenen özellik uygulanmış mı?
- Mevcut mimari korunmuş mu?
- Veri bütünlüğü sağlanmış mı?
- Hata senaryoları ele alınmış mı?
- İlgili testler çalıştırılmış mı?
- Statik analiz değerlendirilmiş mi?
- Yapılan değişiklikler açıklanmış mı?

Herhangi bir doğrulama yapılamadıysa
bu durum açıkça belirtilmelidir.

# SON İLKE

ciltİzi'nin temel amacı yalnızca
kozmetik ürünlere puan vermek değildir.

Uygulama, kullanıcıların kişisel
ürün deneyimlerinden hareketle
INCI bileşenlerini daha bilinçli
değerlendirmelerine yardımcı olmalıdır.

Bütün geliştirmeler bu amaçla,
veri güvenliğiyle ve açıklanabilir
analiz yaklaşımıyla uyumlu olmalıdır.

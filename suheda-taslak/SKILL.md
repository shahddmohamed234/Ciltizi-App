---
name: ciltizi-development
description: >-
  ciltİzi kişiselleştirilmiş kozmetik içerik analizi Flutter uygulamasının
  geliştirme kılavuzu. Clean Architecture, SOLID, Riverpod, Hive CE, OCR, INCI
  normalizasyonu, cilt profili, ürün kütüphanesi, kullanıcı deneyimleri,
  kişiselleştirilmiş içerik eşleştirme, uygunluk skoru, Material 3, güvenlik,
  test ve sürüm yönetimini kapsar. ciltİzi projesinde özellik geliştirirken,
  kod yazarken, ekran tasarlarken, algoritma oluştururken, veritabanı
  işlemlerinde, hata düzeltirken veya refactoring yaparken kullan.
---

# ciltİzi - Geliştirici Kılavuzu

Bu doküman, ciltİzi Flutter projesinde çalışan Antigravity AI Agent ve geliştiriciler için bağlayıcı geliştirme standartlarını tanımlar.

**Temel Amaç:** Kullanıcıların kozmetik ürünlerle yaşadıkları deneyimleri INCI içerik listeleriyle karşılaştırarak kişiselleştirilmiş, açıklanabilir içerik analizi yapabilen, mevcut mimariyi ve kullanıcı verilerini koruyan, güvenilir ve sürdürülebilir bir mobil uygulama geliştirmek.

## 1. Proje Tanımı ve Teknolojiler

### 1.1. Proje Bilgileri

| Özellik | Değer |
| :--- | :--- |
| **Uygulama / Paket Adı** | ciltİzi / `ciltizi` |
| **Proje Türü & SDK** | Flutter (3.47.7) / Dart (3.13.5) |
| **Mimari & Tasarım** | Local-First, Clean Architecture, SOLID / Material Design 3 (Light & Dark) |
| **Durum Yönetimi & DB** | Riverpod / Hive CE |
| **Diller** | Türkçe (varsayılan), İngilizce |
| **Platformlar** | Öncelikli: Android, iOS / Gelecek: Web, Masaüstü |

* **Çevrimdışı Çalışma:** Temel özellikler harici backend veya sürekli internet bağlantısı gerektirmemelidir.
* **Platform Stratejisi:** Google ML Kit OCR mobil platformlarda çalışmalı; Web/Masaüstü gibi desteklenmeyen platformlarda manuel içerik girişi alternatifi sunulmalı ve desteklenmeyen özellikler diğer işlevleri engellememelidir.

### 1.2. Teknolojik Altyapı

| Paket | Sorumluluk |
| :--- | :--- |
| `flutter_riverpod` | Reaktif durum yönetimi |
| `hive_ce` / `hive_ce_flutter` | Yerel veri saklama ve Flutter entegrasyonu |
| `google_mlkit_text_recognition` | OCR metin tanıma |
| `image_picker` | Kamera ve galeri erişimi |
| `path_provider` | Dosya dizinleri |
| `intl` / `flutter_localizations` | Yerelleştirme, dil desteği ve tarih biçimlendirme |
| `uuid` | Benzersiz kayıt kimlikleri |
| `cupertino_icons` | iOS uyumlu ikonlar |
| `flutter_test` / `flutter_lints` | Otomatik testler ve kod kalitesi |

* Paket ekleme/değiştirme öncesinde `pubspec.yaml` kontrol edilmeli; yeni bağımlılıklar yalnızca gerekli olduğunda ve SDK uyumluluğu doğrulandıktan sonra eklenmelidir.
* Hive model kod üretimi kullanılacaksa `hive_ce_generator` ve `build_runner` geliştirme bağımlılıklarına (`dev_dependencies`) eklenmelidir.

## 2. Uygulama Özellikleri

### 2.1. Cilt Profili (`skin_profile_box` - Tekil Kullanıcı Yapılandırması)

* **Cilt Tipleri:** Normal, Kuru, Yağlı, Karma.
* **Cilt Problemleri ve Özellikleri:** Hassasiyet, Akne eğilimi, Aktif akne, Kızarıklık, Rozasea, Kuruluk, diğer kullanıcı tanımlı problemler. *(Cilt tipi ile cilt problemleri farklı alanlarda saklanmalıdır.)*
* **Bileşen Tercihleri:** (1) Bildirdiği alerjenler, (2) Kaçınmak istediği bileşenler (Örn: Parfüm, belirli alkol türleri, parabenler, sülfatlar, uçucu yağlar, kullanıcı eklemeleri).
* **Kimyasal Ayrım:** Madde aileleri, farklı kimyasal bileşenleri yanlışlıkla aynı kabul edecek şekilde otomatik birleştirilmemelidir.

### 2.2. Ürün Kütüphanesi

* **Ürün Bilgileri:** Ürün adı, marka, kategori, orijinal INCI listesi, normalize edilmiş INCI listesi, kayıt tarihi, güncelleme tarihi.
* **Kategoriler:** Temizleyici, Tonik, Serum, Nemlendirici, Güneş kremi, Maske, Peeling, Diğer.
* **İçerik Ekleme Yöntemleri:** (1) Manuel metin girişi, (2) Metin yapıştırma, (3) Kamera ile OCR, (4) Galeriden OCR, (5) Örnek bileşen listesinden seçim.
* **Listeleme ve İşlemler:** Ürün ekleme, düzenleme, silme, detay ekranı, kullanıcı ürünleri, başlangıç ürünleri (`assets/products.json`), ürün arama ve kategori filtreleme.

### 2.3. Kullanıcı Deneyimleri

* **Puanlama:** 1 ile 5 arasında ürün puanı (reaksiyon etiketleriyle birlikte değerlendirilir).
* **Olumlu Etkiler:** Nemlendirdi, Yatıştırdı, Matlaştırdı, Aydınlattı, Cildimi yumuşattı.
* **Olumsuz Etkiler:** Sivilce yaptı, Tahriş etti, Kızarıklık yaptı, Kuruluk yaptı, Kaşıntı yaptı, Komedon yaptı.
* **Ek Bilgiler ve Yönetim:** Serbest kullanıcı notu, kullanım süresi, deneyim tarihi. Geçmiş değerlendirmeler görüntülenebilmeli, düzenlenebilmeli ve silinebilmelidir.

## 3. Veri Modelleri ve Depolama

### 3.1. Temel Modeller ve Kurallar

| Model | Alanlar |
| :--- | :--- |
| **SkinProfile** | `id`, `skinType`, `skinConcerns`, `knownAllergens`, `avoidedIngredients`, `createdAt`, `updatedAt` |
| **Product** | `id`, `name`, `brand`, `category`, `rawIngredients`, `normalizedIngredients`, `createdAt`, `updatedAt` |
| **ProductReview** | `id`, `productId`, `rating`, `positiveReactions`, `negativeReactions`, `notes`, `usageDuration`, `createdAt`, `updatedAt` |
| **AnalysisResult** | `id`, `productId`, `score`, `matchedAvoidedIngredients`, `matchedSuspectedIngredients`, `evidenceSummary`, `warnings`, `analyzedAt`, `algorithmVersion` |
| **AppSettings** | `themeMode`, `languageCode` |

* **Model Kuralları:** Null safety kullanılmalı, kayıtlar benzersiz kimliğe (`uuid`) sahip olmalı, tarihler `DateTime` olarak işlenmeli, mümkün olduğunca immutable modeller kullanılmalı, geçersiz veri girişleri doğrulanmalı ve model genişletmelerinde/değişikliklerinde veri uyumluluğu korunmalıdır.

### 3.2. Hive CE Box Yapısı ve Veri Bütünlüğü

| Box | İçerik |
| :--- | :--- |
| `skin_profile_box` | Kullanıcı cilt profili |
| `products_box` | Ürün kayıtları |
| `reviews_box` | Kullanıcı değerlendirmeleri |
| `analysis_history_box` | Analiz geçmişi |
| `settings_box` | Tema ve dil tercihleri |

* **Erişim:** Hive uygulama başlangıcında initialize edilmeli; veritabanı işlemleri yalnızca `data` katmanı üzerinden gerçekleştirilmelidir.
* **Başlangıç Verileri (`assets/products.json`):** (1) JSON yapısını doğrula, (2) Tekrarlanan kayıtları engelle, (3) Kullanıcı verilerini değiştirme, (4) Seed veri sürümünü takip et, (5) Hatalı/eksik dosyaları yönet. Gerçek ürünlerin INCI listeleri doğrulanmadan üretilmemelidir.
* **Veri Bütünlüğü:** Güncellemelerde kullanıcı verileri korunmalı, Hive model değişikliklerinde geçiş planı uygulanmalı, adapter kimlikleri ve alan indeksleri korunmalı, silme işlemlerinde ilişkili kayıtlar dikkate alınmalı, beklenmeyen depolama hataları yönetilmeli ve gerektiğinde güvenli yedekleme/dışa aktarma altyapısı tasarlanmalıdır.

## 4. INCI İşleme ve OCR

* **INCI Ayrıştırma:** Standart metin girişleri `rawText.split(',').map((item) => item.trim()).where((item) => item.isNotEmpty).toList();` ile ayrıştırılır. OCR çıktıları önce temizlenmeli, ardından ayrıştırılmalıdır.
* **Normalizasyon Adımları:** (1) Gereksiz boşlukları kaldır, (2) Harf büyüklüğünü eşitle, (3) Bilinen yazım farklılıklarını düzelt, (4) Doğrulanmış eş adları eşleştir (Örn: `Aqua` = `Water`; ancak benzer adlı farklı kimyasal maddeler birleştirilmemelidir), (5) Yinelenen bileşenleri tespit et, (6) Orijinal metni ayrıca koru.
* **OCR İş Akışı:** (1) Kamera/galeri seçimi, (2) Platform desteği ve izin kontrolü, (3) `image_picker` ile görsel alma, (4) ML Kit metin tanıma, (5) Olası INCI bölümünü belirleme, (6) Metin ve satır sonlarını temizleme (satır sonları doğrudan virgüle dönüştürülmeden önce incelenmelidir), (7) Düzenlenebilir alanda gösterim, (8) Kullanıcı doğrulaması (OCR kesin doğru kabul edilmez), (9) Normalizasyon, (10) Kayıt.
* **Arayüz ve Hata Yönetimi:** İçerikler `Wrap` içinde `Chip`/`InputChip` ile düzenlenebilir ve uzun listelerde kaydırılabilir gösterilmeli; boş OCR çıktısı açıklanmalı, izin hataları ve loading durumu yönetilmeli, işlem sonrası kaynaklar kapatılmalıdır.

## 5. Kişisel İçerik Analizi

* **Veri Kaynakları:** Cilt profili, bilinen alerjenler, kaçınılan bileşenler, olumlu/olumsuz ürün deneyimleri ve ürün INCI listeleri.
* **Olumlu Deneyim Analizi:** Olumlu ürünlerin bileşenlerinden "Olumlu Deneyim İçerikleri" listesi oluşturulur. Bu listede bulunmak kesin güvenlik anlamına gelmez.
* **Olumsuz Deneyim Analizi:** Her bileşen için kaç farklı olumsuz üründe, kaç olumlu üründe ve hangi reaksiyonlarla birlikte görüldüğü hesaplanır. Aynı ürüne ait tekrarlanan değerlendirmeler bağımsız ürün sayısını artırmamalıdır.
* **Şüpheli İçerik Belirleme:** Bir bileşen en az 2 farklı olumsuz değerlendirilmiş üründe bulunuyorsa şüpheli aday sayılır (Örn: İki olumsuz üründe ortak olan `Aqua` ve `Niacinamide`). Ancak her ortak bileşen doğrudan reaksiyon nedeni kabul edilmez; olumlu ürünlerdeki görülme sıklığı ve diğer deneyimler birlikte değerlendirilir.
* **Veri Eşleştirmesi:** Olumlu ürünlerde bulunan bileşenler otomatik olarak şüpheli listesinden çıkarılmaz; hem olumlu hem olumsuz ürünlerde görülme durumu kullanıcıya açıklanmalıdır. Bilinen alerjenler hiçbir koşulda olumlu deneyim nedeniyle güvenli etiketlenmemelidir.
* **Kanıt Seviyesi:** Veri miktarı ve tutarlılığına göre `Yetersiz veri`, `Düşük güven`, `Orta güven` veya `Daha güçlü kişisel örüntü` olarak belirlenir (tıbbi kesinlik belirtmez). Yeni deneyimlerle yeniden hesaplanabilmelidir.

## 6. Uygunluk Skoru ve Analiz Sonucu

* **Sorgulama Akışı:** (1) Ayrıştırma, (2) Normalizasyon, (3) Kaçınılan madde eşleştirme, (4) Şüpheli aday belirleme, (5) Olumlu deneyim karşılaştırması, (6) Kanıt seviyesi değerlendirmesi, (7) Skor hesaplama, (8) Gerekçeli sunum.
* **Başlangıç Skor Formülü (Deneysel Model):**
  `score = max(0, 100 - (avoidedIngredientCount * 25) - (suspectedIngredientCount * 20))`
  * Skor 0–100 aralığında tutulur; klinik güvenlik olasılığı olarak sunulmaz.
  * Aynı bileşen aynı kategoride birden fazla kez sayılmaz; birden fazla kategoriye giriyorsa çift ceza yerine belirlenmiş öncelik kuralı uygulanır.
* **Alerjen Uyarıları:** Skordan bağımsızdır. Eşleşen alerjen varsa bileşen adıyla açık uyarı gösterilir; yüksek skor alerjen uyarısını geçersiz kılamaz.
* **Analiz Ekranı Çıktıları:** Ürün adı, kişisel uygunluk skoru, eşleşen kaçınılan bileşenler, şüpheli bileşenler, olumlu deneyimlerde görülen bileşenler, analiz gerekçeleri, veri güvenilirliği ve gerekli uyarılar. Yetersiz veride kesin uygunluk iddiasında bulunulmaz (Örn: *"Bu üründe, daha önce olumsuz deneyim yaşadığın iki farklı üründe de bulunan bir bileşen tespit edildi. Bu eşleşme, bileşenin reaksiyona neden olduğunu kesin olarak göstermez."*).
* **Analiz Motoru Kuralları:** Arayüzden bağımsız olmalı, aynı girdilerle aynı çıktıyı üretmeli (deterministik), otomatik testlerle doğrulanmalı, eksik verileri yönetmeli, algoritma sürümünü (`algorithmVersion`) kaydetmeli, açıklanabilir olmalı ve geçmişi Hive üzerinde saklamalıdır.

## 7. Yazılım Mimarisi

* **İlkeler:** SOLID, Clean Architecture, Separation of Concerns, DRY, KISS, Dependency Inversion, Test edilebilirlik, Modülerlik. Gereksiz soyutlamalar oluşturulmamalıdır.
* **Bağımlılık Yönü:** `Presentation ──> Domain <── Data` (Arayüz veritabanının nasıl çalıştığını bilmemelidir).
* **Katman Sorumlulukları:**
  * **Presentation:** Screens, Widgets, Riverpod Providers, kullanıcı etkileşimleri, Loading/Error/Empty durumları. *(Veritabanı ve analiz algoritması widget içinde bulunmamalıdır.)*
  * **Domain:** İş kuralları, domain modelleri, repository arayüzleri, analiz servisleri, INCI normalizasyonu, uygunluk skoru hesaplama. *(Flutter UI ve Hive'dan bağımsızdır.)*
  * **Data:** Hive modelleri, data sources, repository implementasyonları, model dönüştürme, seed data işlemleri.

```text
lib/
├── core/ (constants, theme, utils, errors, localization, widgets)
├── domain/ (models, repositories, services)
├── data/ (models, datasources, repositories, seed)
├── features/
│   ├── onboarding/ (presentation)
│   ├── profile/ (presentation, providers, widgets)
│   ├── products/ (presentation, providers, widgets)
│   ├── reviews/ (presentation, providers, widgets)
│   ├── analysis/ (presentation, providers, widgets)
│   └── settings/ (presentation, providers)
├── app.dart
└── main.dart
assets/ (images/, products.json)
test/ (domain/, data/, features/)
```

## 8. State Management ve UI/UX

* **Riverpod:** Kullanıcı profili, ürün kütüphanesi/detayları, deneyim kayıtları, OCR işlemleri, analiz sonuçları, tema ve dil tercihleri tek sorumluluklu provider'lar ile yönetilmeli; asenkron `loading`, `error` ve `data` durumları ele alınmalıdır.
* **Material Design 3 & Tema:** Modern, minimal, tutarlı, erişilebilir ve responsive tasarım. Renkler ve yazı stilleri merkezi temadan yönetilmeli; AppBar üzerinden anlık/animasyonlu Light/Dark geçişi sağlanmalı ve `settings_box`'ta saklanmalıdır. Uyarılar yalnızca renkle değil, metin ve ikonlarla da belirtilmelidir.
* **Dil ve Kullanılabilirlik:** Merkezi yerelleştirme (varsayılan Türkçe, ek İngilizce) `settings_box`'ta saklanmalıdır. Form doğrulama, işlem geri bildirimleri, açıklayıcı boş ekranlar, anlaşılır hata mesajları, uzun işlemlerde yükleme göstergesi ve kontrollü silme onayları uygulanmalıdır.

## 9. Güvenlik, Gizlilik ve Tıbbi Sınırlar

* **Kişisel Veriler:** Cilt profili, alerjenler ve deneyimler kişisel veridir. (1) Gereksiz veri toplama, (2) İzinsiz paylaşma, (3) Hassas bilgi loglama, (4) Kaynak koda gizli anahtar yazma, (5) Gerektiğinde şifrele, (6) Anahtarları güvenli sakla, (7) Veri silme imkânı sağla, (8) Veritabanı erişimlerini kontrol et.
* **Tıbbi Sınırlar:** ciltİzi tıbbi teşhis uygulaması değildir. Alerji teşhisi koymamalı, tedavi önermemeli, içerikleri kesin güvenli ilan etmemeli, kanıtlanmamış bilimsel iddialar üretmemeli ve kişisel örüntüleri tıbbi nedensellik kanıtı olarak göstermemelidir.

## 10. Test ve Kalite Kontrolü

* **Unit Test:** INCI ayrıştırma, normalizasyon, eş ad eşleştirme, olumlu/olumsuz içerik karşılaştırması, şüpheli bileşen belirleme, uygunluk skoru, çift ceza engelleme, eksik veri/sınır durumları ve veri doğrulama.
* **Widget Test:** Profil formu, ürün ekleme/listesi, deneyim kaydı, analiz ekranı, tema değişimi, Loading/Error/Empty durumları.
* **Integration Test:** Profil oluşturma -> Ürün ekleme -> İçerik kaydetme -> Deneyim oluşturma -> Yeni ürün analiz etme -> Analiz geçmişini görüntüleme -> Veri güncelleme ve silme. (OCR gerçek cihazda ve desteklenen platformlarda ayrıca test edilmelidir.)
* **Kalite Kriterleri:** Kritik algoritmalar test edilmeli, yeni kod mevcut testleri bozmamalı, testler bağımsız olmalı, gerçek kullanıcı verisi kullanılmamalı, hatalar gizlenmemeli ve çalıştırılmayan testler başarılı gösterilmemelidir.

## 11. Agent Geliştirme İş Akışı, Komutlar ve Öncelikler

### 11.1. Agent İş Akışı ve Sınırları

1. **Analyze:** Kullanıcı isteğini, ilgili dosyaları, mevcut mimariyi, bağımlılıkları ve etkilenecek özellikleri incele.
2. **Plan:** Değişiklikleri, dosyaları, yeniden kullanılabilir bileşenleri ve veri kaybı/uyumluluk risklerini belirle.
3. **Implement:** Mimariye ve kod standartlarına uygun, hata yönetimi içeren, tekrarsız kod yaz; yalnızca ilgili dosyaları değiştir.
4. **Verify:** Biçimlendirme (`dart format lib test`), statik analiz (`flutter analyze`), testler (`flutter test`) ve mevcut işlevleri kontrol et.
5. **Report:** Yapılan değişiklikleri, eklenen/düzenlenen dosyaları, çalıştırılan testleri/sonuçlarını ve kalan sorunları raporla.

* **Değişiklik Sınırları:** Kullanıcı istemedikçe çalışan özelliği silme, ilgisiz kodu yeniden yazma, mimariyi gerekçesiz değiştirme, gereksiz sınıf/klasör oluşturma, kullanıcı verisini bozma, doğrulanmamış sonucu kesin gösterme, yapılmayan işlemi yapılmış gibi raporlama ve açıkça istenmedikçe `commit`, `push`, `merge` veya `release` yapma.

### 11.2. Git, Sürüm ve Komutlar

* **Git & Sürüm:** Conventional Commits (`feat:`, `fix:`, `refactor:`, `test:`, `docs:`) kullanılır. Hassas bilgiler repoya eklenmez, `.gitignore`'a uyulur, ilgisiz değişiklikler aynı commit'e alınmaz. Sürüm `pubspec.yaml` (`version: 0.1.0+1`) üzerinden kullanıcı talimatıyla yönetilir.
* **Komutlar:** `flutter --version`, `flutter pub get`, `dart format lib test`, `flutter analyze`, `flutter test`, `flutter run`, `dart run build_runner build --delete-conflicting-outputs`.

### 11.3. Geliştirme Öncelikleri ve Tamamlanma Tanımı

* **Öncelik Sırası:** (1) Kullanıcı verilerinin korunması, (2) Analiz algoritmasının doğruluğu, (3) Sonuçların açıklanabilirliği, (4) Mevcut işlevlerin korunması, (5) Kodun sürdürülebilirliği, (6) Test edilebilirlik, (7) Kullanıcı deneyimi, (8) Performans, (9) Görsel tutarlılık.
* **Tamamlanma Tanımı:** Özellik uygulanmış, mimari ve veri bütünlüğü korunmuş, hata senaryoları ele alınmış, testler ve statik analiz çalıştırılmış, değişiklikler ve (varsa) yapılamayan doğrulamalar açıkça raporlanmış olmalıdır.

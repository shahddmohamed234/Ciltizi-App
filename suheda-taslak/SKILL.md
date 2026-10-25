---
name: ciltizi-development
description: >-
  ciltİzi kişiselleştirilmiş kozmetik içerik analizi Flutter uygulamasının
  geliştirme kılavuzu. Clean Architecture, SOLID, flutter_bloc (Bloc/Cubit),
  Hive CE, OCR, INCI normalizasyonu, cilt profili, ürün kütüphanesi, kullanıcı
  deneyimleri, içerik eşleştirme, uygunluk skoru, Bordo/Pembe Material 3 teması,
  güvenlik ve test kurallarını kapsar. ciltİzi projesinde özellik geliştirirken,
  kod yazarken, ekran tasarlarken, algoritma oluştururken, veritabanı
  işlemlerinde, hata düzeltirken veya refactoring yaparken kullan.
---

# ciltİzi — AI ve Geliştirici Kılavuzu (BLoC & Hive CE)

Kullanıcıların kozmetik ürün deneyimlerini INCI içerik listeleriyle karşılaştırarak kişiselleştirilmiş, açıklanabilir ve çevrimdışı (local-first) içerik analizi yapan **ciltİzi** (`ciltizi`) Flutter projesinin bağlayıcı kurallarıdır.

## 1. Teknoloji Yığını ve Paketler

| Alan | Teknoloji / Paket | Kurallar ve Sorumluluk |
| :--- | :--- | :--- |
| **SDK & Platform** | Flutter (3.47.7) / Dart (3.13.5) | Öncelikli: Android, iOS. Gelecek: Web, Masaüstü (OCR desteklenmeyen platformlarda manuel giriş sunulur). |
| **Durum Yönetimi** | `flutter_bloc` (`Bloc` & `Cubit`) | Basit durumlar için `Cubit`, karmaşık ve birbirini tetikleyen olaylar (ör. OCR okuma sonrası analize geçiş) için `Bloc` kullanılır. |
| **Veritabanı** | `hive_ce`, `hive_ce_flutter` | Tüm modeller `TypeAdapter` (`hive_ce_generator` + `build_runner`) ile üretilir. İşlemler `Future` olarak asenkron yönetilir. |
| **OCR & Medya** | `google_mlkit_text_recognition`, `image_picker` | Kamera/galeriden metin tanıma ve `path_provider` ile yerel dizin erişimi. |
| **Yardımcı Paketler** | `intl`, `flutter_localizations`, `uuid`, `cupertino_icons` | Türkçe (varsayılan) ve İngilizce dil desteği, benzersiz kayıt kimlikleri. |
| **Kalite & Test** | `flutter_test`, `flutter_lints` | Paket eklemeden önce `pubspec.yaml` ve SDK uyumluluğu doğrulanmalıdır. |

## 2. Kesin Kodlama, Mimari ve UI/Tema Kuralları

* **Katman Sınırları (Clean Architecture):** Bağımlılık yönü `Presentation ──> Domain <── Data` şeklindedir. UI katmanında iş mantığı, veritabanı erişimi veya analiz algoritması barındırmak **kesinlikle yasaktır**.
* **Koşullu İfadeler (`if / else` Zorunluluğu):** Özellikle karmaşık UI dönüşlerinde ve widget render işlemlerinde kısa ternary operatörleri (`? :`) kullanmak **yasaktır**; okunabilirlik için açık `if / else if / else` blokları kullanılmalıdır.
* **İsimlendirme ve Prensipler:** Anlamlı, İngilizce, `camelCase` isimlendirme; SOLID, DRY, KISS ve Separation of Concerns ilkelerine tam uyum zorunludur.
* **Renk Paleti (Bordo ve Pembe Zorunluluğu):** Uygulamanın ana teması **Bordo ve Pembe** tonlarıdır (Material 3 Light & Dark destekli). **Yeşil veya standart mavi temalar kesinlikle kullanılmamalıdır.**
* **Inline Style Yasağı:** Widget'lara doğrudan sabit renk veya stil (`Colors.red` vb.) vermek yasaktır. Tüm stiller `lib/core/constants/app_theme.dart` içinde `ThemeData` ile tanımlanmalı ve `Theme.of(context)` üzerinden çekilmelidir. Uyarılar yalnızca renkle değil, ikon ve metinle de desteklenmelidir.
* **Reaktif Durum Kontrolü:** Veritabanı ve analiz işlemleri `Bloc`/`Cubit` içinde asenkron yürütülmeli; UI tarafında `BlocBuilder` ile `loading`, `loaded`, `empty` ve `error` durumları eksiksiz ele alınmalıdır.

```text
lib/
├── core/ (constants/app_theme.dart, utils, errors, localization, widgets)
├── domain/ (models, repositories, services)          # Flutter UI ve Hive'dan bağımsız
├── data/ (models, datasources, repositories, seed)   # Yalnızca veri erişimi ve dönüşüm
├── features/
│   ├── onboarding/ (presentation)
│   ├── profile/ (presentation, blocs, widgets)
│   ├── products/ (presentation, blocs, widgets)
│   ├── reviews/ (presentation, blocs, widgets)
│   ├── analysis/ (presentation, blocs, widgets)
│   └── settings/ (presentation, blocs)
├── app.dart
└── main.dart
assets/ (images/, products.json)
test/ (domain/, data/, features/)
```

## 3. Veri Modelleri ve Hive CE Kutuları (Boxes)

Tüm modeller null-safe, mümkün olduğunca immutable, `uuid` kimlikli ve `DateTime` tarihli olmalıdır. Şema güncellemelerinde `TypeAdapter` indeksleri ve mevcut kullanıcı verileri korunmalıdır.

| Model | Hive Box | Alanlar (`Fields`) |
| :--- | :--- | :--- |
| `SkinProfile` | `skin_profile_box` | `id`, `skinType`, `skinConcerns`, `knownAllergens`, `avoidedIngredients`, `createdAt`, `updatedAt` |
| `Product` | `products_box` | `id`, `name`, `brand`, `category`, `rawIngredients`, `normalizedIngredients`, `createdAt`, `updatedAt` |
| `ProductReview` | `reviews_box` | `id`, `productId`, `rating`, `positiveReactions`, `negativeReactions`, `notes`, `usageDuration`, `createdAt`, `updatedAt` |
| `AnalysisResult` | `analysis_history_box` | `id`, `productId`, `score`, `matchedAvoidedIngredients`, `matchedSuspectedIngredients`, `evidenceSummary`, `warnings`, `analyzedAt`, `algorithmVersion` |
| `AppSettings` | `settings_box` | `themeMode`, `languageCode` |

* **Başlangıç Verileri (`assets/products.json`):** İlk açılışta JSON doğrulanarak `products_box` içine yazılır; mükerrer kayıt engellenir, kullanıcı verisi ezilmez ve seed sürümü takip edilir. Doğrulanmamış sahte INCI listesi üretilmez.

## 4. Özellik Kapsamı ve İş Kuralları

* **Cilt Profili:**
  * *Cilt Tipleri:* Normal, Kuru, Yağlı, Karma (`skinType` ile `skinConcerns` ayrı alanlarda tutulur).
  * *Cilt Problemleri:* Hassasiyet, Akne eğilimi, Aktif akne, Kızarıklık, Rozasea, Kuruluk ve kullanıcı tanımlı problemler.
  * *Bileşen Tercihleri:* Bilinen alerjenler (`knownAllergens`) ve kaçınılan bileşenler (`avoidedIngredients`: parfüm, belirli alkoller, parabenler, sülfatlar, uçucu yağlar vb.). Farklı kimyasal bileşenler otomatik birleştirilmez.
* **Ürün Kütüphanesi:**
  * *Kategoriler:* Temizleyici, Tonik, Serum, Nemlendirici, Güneş kremi, Maske, Peeling, Diğer.
  * *Ekleme Yöntemleri:* Manuel giriş, metin yapıştırma, Kamera OCR, Galeri OCR, örnek listeden seçim. Arama, kategori filtreleme ve CRUD işlemlerini destekler.
* **Kullanıcı Deneyimleri:**
  * *Puan:* 1–5 arası.
  * *Olumlu Etkiler:* Nemlendirdi, Yatıştırdı, Matlaştırdı, Aydınlattı, Cildimi yumuşattı.
  * *Olumsuz Etkiler:* Sivilce yaptı, Tahriş etti, Kızarıklık yaptı, Kuruluk yaptı, Kaşıntı yaptı, Komedon yaptı.

## 5. OCR ve INCI Normalizasyon İş Akışı

1. **Ayrıştırma:** Standart girişler `rawText.split(',').map((item) => item.trim()).where((item) => item.isNotEmpty).toList();` ile ayrıştırılır.
2. **OCR Adımları:** Kaynak seçimi (Kamera/Galeri) → Platform/izin kontrolü → `image_picker` → ML Kit metin tanıma → Olası INCI bölümünü ayıklama ve satır sonlarını temizleme → `Wrap` içinde kaydırılabilir `Chip`/`InputChip` olarak düzenlenebilir gösterim → **Kullanıcı doğrulaması** (OCR çıktısı doğrudan kesin kabul edilmez) → Normalizasyon → Kayıt ve kaynakların kapatılması.
3. **Normalizasyon:** Boşlukları temizle, harf büyüklüğünü eşitle, bilinen yazım hatalarını düzelt, yalnızca doğrulanmış eş adları eşleştir (ör. `Aqua` = `Water`), yinelenenleri kaldır ve `rawIngredients` metnini ayrıca koru.

## 6. Analiz Algoritması, Alerjen Önceliği ve Uygunluk Skoru

Analiz motoru deterministik, UI'dan bağımsız, açıklanabilir ve `algorithmVersion` kayıtlı olmalıdır:

1. **Alerjen Önceliği (Kritik Kural):** İçerik eşleştirmede kullanıcının `knownAllergens` listesi **her şeyden önce** değerlendirilir. Eşleşme varsa uygunluk skoru hesaplanmadan önce doğrudan bileşen adıyla **"KRİTİK UYARI"** üretilir; hiçbir yüksek skor veya geçmiş olumlu deneyim alerjen uyarısını geçersiz kılamaz.
2. **Deneyim ve Şüpheli Bileşen Analizi:**
   * En az **2 farklı olumsuz değerlendirilmiş üründe** ortak bulunan bileşenler şüpheli aday (`matchedSuspectedIngredients`) sayılır (aynı ürüne ait birden fazla yorum tek ürün sayılır).
   * Bir bileşenin hem olumlu hem olumsuz ürünlerde görülme sıklığı birlikte raporlanır; olumlu üründe bulunması onu şüpheli listesinden otomatik çıkarmaz veya kesin güvenli yapmaz.
3. **Kanıt Seviyesi:** Veri miktarına göre `Yetersiz veri`, `Düşük güven`, `Orta güven` veya `Daha güçlü kişisel örüntü` olarak etiketlenir.
4. **Uygunluk Skoru Formülü (0–100):**
   `score = max(0, 100 - (avoidedIngredientCount * 25) - (suspectedIngredientCount * 20))`
   * Aynı bileşen tek kategoride bir kez sayılır; birden fazla kategoriye giriyorsa çift ceza yerine üst öncelikli ceza uygulanır.

## 7. Güvenlik, Gizlilik ve Tıbbi Sınırlar

* **Tıbbi Sınır:** Uygulama tıbbi teşhis veya tedavi aracı değildir. Alerji teşhisi koymaz, içerikleri "kesin güvenli" ilan etmez ve kişisel örüntüleri klinik nedensellik kanıtı gibi sunmaz.
* **Veri Güvenliği:** Hassas kullanıcı verileri (profil, alerjen, deneyim) loglanmaz, izinsiz paylaşılmaz, kaynak koda gizli anahtar yazılmaz ve kullanıcıya veri silme/sıfırlama imkânı sunulur.

## 8. Test, Kalite ve Agent İş Akışı

* **Test Kapsamı:**
  * *Unit Test:* INCI ayrıştırma/normalizasyon, alerjen önceliği, şüpheli içerik tespiti, skor formülü, çift ceza engelleme ve sınır durumları.
  * *Widget Test:* BLoC durum geçişleri (`loading`/`loaded`/`error`), Bordo/Pembe tema uyumu ve formlar.
  * *Integration Test:* Profil → Ürün ekleme → Deneyim kaydı → Analiz → Geçmiş görüntüleme/silme akışı.
* **Agent İş Akışı (`Analyze → Plan → Implement → Verify → Report`):**
  1. İlgili dosyaları ve veri uyumluluğu risklerini analiz et; çalışan ilgisiz kodları veya mimariyi kullanıcı istemeden değiştirme.
  2. Değişiklik sonrası `dart run build_runner build --delete-conflicting-outputs` (gerekiyorsa), `dart format lib test`, `flutter analyze` ve `flutter test` komutlarını çalıştır.
  3. Açıkça istenmedikçe `git commit`, `push`, `merge` veya sürüm (`pubspec.yaml`) değişikliği yapma; Conventional Commits (`feat:`, `fix:`, `refactor:`, `test:`, `docs:`) standardına uy.

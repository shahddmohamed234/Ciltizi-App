# ciltİzi — Kişiselleştirilmiş Kozmetik İçerik ve Rutin Analizi
## Proje Mimari ve Geliştirme Dokümantasyonu

Bu doküman, **ciltİzi** mobil uygulamasının ürün vizyonunu, Clean Architecture mimari yapısını, geliştirilen tüm modülleri, oluşturulan uygulama ikonunu ve kodlama standartlarını detaylı bir şekilde açıklamaktadır.

---

### 1. Proje Özeti ve Amacı

**ciltİzi**, kullanıcıların cilt profillerini, kozmetik ürün içeriklerini (INCI) ve kullanım deneyimlerini tek bir yerde güvenle takip etmelerini sağlayan **Flutter tabanlı, yerel öncelikli (offline-first)** bir mobil uygulamadır.

* **Alerjen Önceliği:** Profilde kayıtlı bir alerjenle eşleşme olduğunda, bu durum uygunluk puanından ve önceki olumlu deneyimlerden önce **kritik uyarı** olarak gösterilir.
* **Kullanıcı Kontrolü:** Kamera veya galeriden OCR ile okunan içerik metinleri, kullanıcı tarafından incelenip onaylanmadan asla analize sokulmaz.
* **Açıklanabilirlik:** Analiz sadece bir sayısal puan üretmez; hangi bileşenin neden uyarı verdiğini gerekçeleriyle açıklar.
* **Veri Yeterliliği:** İçerik listesi eksikse veya deneyim sayısı azsa sistem bunu açıkça "Düşük / Eksik Veri" veya "Orta" etiketiyle belirtir.
* **Tıbbi Sınırlar:** Uygulama tıbbi bir teşhis aracı değildir; kullanıcı kayıtlarına dayalı bilinçli karar destek sistemidir.

---

### 2. Uygulama İkonu ve Telefon Uyumluluğu

Uygulamanın hem Android hem iOS telefonlarda ve Web platformunda gözükebilmesi için **Rose & Plum** (Gül & Mürdüm) kimliğine uygun, minimal kozmetik damlası ve zarif yüz silüeti barındıran profesyonel bir uygulama ikonu oluşturulmuştur.

* **Ana Kaynak Görseli:** `assets/icon/app_icon.png` (1024x1024 px)
* **Android İkonları (mipmap):**
  * `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
  * `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
  * `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
  * `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
  * `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)
* **iOS İkon Seti (`Assets.xcassets/AppIcon.appiconset`):**
  * 20x20, 29x29, 40x40, 60x60, 76x76, 83.5x83.5 ve 1024x1024 (App Store) boyutlarında tüm varyasyonlar oluşturuldu.
* **Web İkonları (`web/icons/` & `web/favicon.png`):**
  * `Icon-192.png`, `Icon-512.png`, maskable varyantlar ve favicon yerleştirildi.
* **Uygulama Adı:** Android (`AndroidManifest.xml`), iOS (`Info.plist`) ve Web (`index.html`, `manifest.json`) üzerinde uygulama adı `ciltİzi` olarak ayarlandı.

---

### 3. Yazılım Mimarisi (Clean Architecture)

Proje katmanları ve sorumlulukları birbirinden kesin olarak ayrılmıştır:

```
lib/
├── app/
│   ├── app.dart                    # Kök MaterialApp, MultiBlocProvider ve tema yönetimi
│   └── home_navigation_screen.dart # Material 3 NavigationBar (Ürünlerim, Profilim, Ayarlar)
├── core/
│   ├── constants/
│   │   └── app_colors.dart         # Rose & Plum renk paleti sabitleri
│   ├── errors/
│   │   └── failures.dart           # Hata ve istisna sınıfları
│   ├── services/
│   │   └── ocr_service.dart        # Kamera/galeri görsel seçimi ve OCR koordinatörü
│   ├── storage/
│   │   └── local_storage_service.dart # Çevrimdışı JSON depolama servisi
│   ├── theme/
│   │   └── app_theme.dart          # Light ve Dark ThemeData tanımları
│   ├── utils/
│   │   └── inci_parser.dart        # INCI içerik ayrıştırma, normalizasyon ve eşleme
│   └── widgets/
│       ├── app_empty_view.dart     # Veri bulunmayan durumlar için boş ekran bileşeni
│       ├── app_error_view.dart     # Hata ve tekrar dene bileşeni
│       └── app_loading_view.dart   # Yükleniyor durum bileşeni
├── features/
│   ├── products/                   # Ürünler Modülü
│   │   ├── domain/                 # Product Entity ve ProductRepository sözleşmesi
│   │   ├── data/                   # ProductModel ve ProductRepositoryImpl (idempotent seed)
│   │   └── presentation/           # ProductCubit, ProductListScreen, AddEditProductScreen,
│   │                               # ProductDetailScreen, OcrValidationScreen
│   ├── profile/                    # Profil Modülü
│   │   ├── domain/                 # SkinProfile Entity ve ProfileRepository sözleşmesi
│   │   ├── data/                   # SkinProfileModel ve ProfileRepositoryImpl
│   │   └── presentation/           # ProfileCubit ve ProfileScreen
│   ├── reviews/                    # Deneyimler / Yorumlar Modülü
│   │   ├── domain/                 # ProductReview Entity ve ReviewRepository sözleşmesi
│   │   ├── data/                   # ProductReviewModel ve ReviewRepositoryImpl
│   │   └── presentation/           # Deneyim ekleme ve listeleme arayüzleri
│   ├── analysis/                   # Analiz Motoru Modülü
│   │   ├── domain/                 # AnalysisResult Entity ve AnalyzeProductUseCase (Saf iş mantığı)
│   │   └── presentation/           # AnalysisResultScreen (Alerjen uyarısı, puan, gerekçeler)
│   └── settings/                   # Ayarlar Modülü
│       ├── domain/                 # AppSettings Entity ve SettingsRepository sözleşmesi
│       ├── data/                   # SettingsRepositoryImpl
│       └── presentation/           # SettingsCubit ve SettingsScreen (Tema seçimi)
└── main.dart                       # Uygulama başlangıç noktası (WidgetsFlutterBinding)
```

---

### 4. Geliştirilen Ekranlar

1. **Ürünlerim / Ana Ekran (`ProductListScreen`)**:
   * Kullanıcının eklediği ürünlerin kartları, arama filtresi, PAO/SKT uyarı rozetleri ve yeni ürün ekleme FAB butonu.
2. **Ürün Ekleme / Düzenleme Ekranı (`AddEditProductScreen`)**:
   * Ürün adı, marka, PAO süresi, açılma tarihi, son kullanma tarihi ve INCI listesi giriş formu.
   * Kamera ve Galeri ile OCR tarama tetikleyicisi.
3. **OCR İçerik Doğrulama Ekranı (`OcrValidationScreen`)**:
   * Görselden okunan ham metnin kullanıcı tarafından kontrol edildiği, düzeltildiği ve etiket önizlemesiyle onaylandığı zorunlu kontrol ekranı.
4. **Ürün Detay Ekranı (`ProductDetailScreen`)**:
   * Doğrulanmış INCI içerikleri etiketleri, PAO ve SKT durum kartları, kullanıcı deneyimleri listesi, deneyim ekleme diyaloğu ve analiz başlatma butonu.
5. **İçerik Analiz Rapor Ekranı (`AnalysisResultScreen`)**:
   * En üstte kritik alerjen uyarısı (varsa), veri yeterliliği göstergesi, profil uygunluk puanı, tek tek gerekçeli sinyaller ve tıbbi yasal uyarı.
6. **Cilt Profilim Ekranı (`ProfileScreen`)**:
   * Cilt tipi seçimi (Kuru, Yağlı, Karma, Hassas, Normal), bakım hedefleri çoklu seçimi, bilinen alerjen maddeler ve kaçınılacak içerikler yönetimi.
7. **Ayarlar Ekranı (`SettingsScreen`)**:
   * Sistem Teması, Açık Tema ve Koyu Tema radyo butonları, gizlilik bilgilendirmesi ve sürüm bilgisi.

---

### 5. Yorum Satırı ve Kodlama Standartları

Kullanıcı talebi doğrultusunda, projedeki her bir kod bloğunun ve dosyanın başına ve içine:
* Hangi işlevi yerine getirdiği,
* Hangi Clean Architecture katmanına ait olduğu,
* Parametrelerin ve değişkenlerin ne anlama geldiği
Türkçe açıklayıcı yorum satırları (`///` ve `//`) ile eksiksiz olarak eklenmiştir.

---

### 6. Testler

Proje için unit ve widget testleri yazılmıştır:
* `test/unit/inci_parser_test.dart`: INCI metinlerini ayrıştırma, normalizasyon ve alerjen eşleştirme testleri.
* `test/unit/analysis_usecase_test.dart`: Alerjen önceliği kuralı, çifte ceza uygulanmama kuralı, boş veri kontrolü ve olumsuz deneyim şüpheli içerik sinyali testleri.
* `test/widget_test.dart`: Uygulamanın başlatılması ve gezinme sekmelerinin render edilmesi duman testi.

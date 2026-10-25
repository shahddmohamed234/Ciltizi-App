import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/settings/presentation/bloc/settings_cubit.dart';

/// [AppStrings] sınıfı, uygulamanın Türkçe ve İngilizce dillerindeki tüm metinlerini
/// dinamik ve reaktif olarak yönetir. `AppStrings.of(context)` ile çağrıldığında
/// kullanıcının seçtiği dile göre anında ilgili dildeki metni döner.
class AppStrings {
  final String languageCode;

  const AppStrings(this.languageCode);

  /// BuildContext üzerinden mevcut dil nesnesini çeker
  static AppStrings of(BuildContext context) {
    try {
      final lang = context.watch<SettingsCubit>().state.languageCode;
      return AppStrings(lang);
    } catch (_) {
      return const AppStrings('tr');
    }
  }

  /// Dilin Türkçe olup olmadığını belirtir
  bool get isTr => languageCode == 'tr';

  // --- Genel / Ortak İfadeler ---
  String get appTitle => 'ciltİzi';
  String get loading => isTr ? 'Kozmetik koleksiyonunuz yükleniyor...' : 'Loading your skincare collection...';
  String get error => isTr ? 'Hata' : 'Error';
  String get retry => isTr ? 'Tekrar Dene' : 'Retry';
  String get cancel => isTr ? 'İptal' : 'Cancel';
  String get save => isTr ? 'Kaydet' : 'Save';
  String get delete => isTr ? 'Sil' : 'Delete';
  String get giveUp => isTr ? 'Vazgeç' : 'Cancel';
  String get addBtn => isTr ? 'Ekle' : 'Add';
  String get cosmeticFallback => isTr ? 'KOZMETİK' : 'COSMETIC';
  String get notSpecified => isTr ? 'Belirtilmedi' : 'Not specified';
  String get notSelected => isTr ? 'Seçilmedi' : 'Not selected';
  String get months => isTr ? 'Ay' : 'Months';
  String get expiredSuffix => isTr ? '(Süresi Doldu)' : '(Expired)';
  String get verifiedTag => isTr ? 'Onaylandı' : 'Verified';
  String get verifiedIngredient => isTr ? 'Onaylı İçerik' : 'Verified Ingredients';

  // --- Alt Gezinme Çubuğu (Bottom Navigation) ---
  String get navProducts => isTr ? 'Ürünlerim' : 'My Products';
  String get navProfile => isTr ? 'Profilim' : 'My Profile';
  String get navSettings => isTr ? 'Ayarlar' : 'Settings';

  // --- Ürün Listesi (Product List) ---
  String get searchHint => isTr ? 'Ürün adı veya marka ara...' : 'Search product or brand...';
  String get addProduct => isTr ? 'Ürün Ekle' : 'Add Product';
  String get emptyCollectionTitle => isTr ? 'Koleksiyonunuz Henüz Boş' : 'Your Collection is Empty';
  String get emptyCollectionMessage => isTr
      ? 'Kullandığınız cilt bakım ürünlerini ekleyerek içerik eşleşmelerini ve alerjen analizlerini başlatın.'
      : 'Add your skincare products to start ingredient matching and allergen analyses.';
  String get firstProduct => isTr ? 'İlk Ürünü Ekle' : 'Add First Product';
  String get productNotFoundTitle => isTr ? 'Ürün Bulunamadı' : 'No Products Found';
  String productNotFoundMsg(String q) => isTr
      ? '"$q" aramasıyla eşleşen bir ürününüz bulunamadı.'
      : 'No product matched your search for "$q".';
  String get verified => isTr ? 'Onaylandı' : 'Verified';
  String get ingredientsCount => isTr ? 'Bileşen' : 'Ingredients';
  String get paoTag => isTr ? 'M PAO' : 'M PAO';
  String get expiredTag => isTr ? 'Tarihi Geçti' : 'Expired';
  String get collectionHeroTitle => isTr ? 'Kişisel Bakım Koleksiyonu' : 'Personal Skincare Collection';
  String get collectionHeroSubtitle => isTr ? 'Cildinizin Güvenli İçerik Haritası' : "Your Skin's Safe Ingredient Map";
  String get offlineSecure => isTr ? 'Çevrimdışı Güvenli' : 'Offline Secure';
  String get statSavedProducts => isTr ? 'Kayıtlı Ürün' : 'Saved Products';
  String get statKnownAllergens => isTr ? 'Kayıtlı Alerjen' : 'Known Allergens';

  // --- Ürün Detay Ekranı (Product Detail) ---
  String get productDetail => isTr ? 'Ürün Detayı' : 'Product Detail';
  String get productNotFound => isTr ? 'Ürün bulunamadı.' : 'Product not found.';
  String get editProduct => isTr ? 'Ürünü Düzenle' : 'Edit Product';
  String get deleteProduct => isTr ? 'Ürünü Sil' : 'Delete Product';
  String get ctaAnalysisTitle => isTr ? 'Kişiselleştirilmiş Cilt Analizi' : 'Personalized Skin Analysis';
  String get ctaAnalysisDesc => isTr
      ? 'Bu ürünün tüm bileşenlerini kayıtlı alerjenleriniz, kaçındığınız içerikler ve önceki deneyimlerinizle anında karşılaştırın.'
      : 'Instantly compare all ingredients with your known allergens, avoided ingredients, and past experiences.';
  String get ctaAnalyzeNow => isTr ? 'Ürünü Hemen Analiz Et' : 'Analyze Product Now';
  String get usageTracking => isTr ? 'Kullanım ve Raf Ömrü Takibi' : 'Usage & Shelf Life Tracking';
  String get paoFullTitle => isTr ? 'PAO (Açıldıktan Sonra Kullanım Süresi)' : 'PAO (Period After Opening)';
  String get openedDate => isTr ? 'Kutunun Açıldığı Tarih' : 'Product Opened Date';
  String get expiryDate => isTr ? 'Son Kullanma Tarihi (SKT)' : 'Expiration Date (EXP)';
  String get inciListTitle => isTr ? 'İçerik Listesi (INCI)' : 'Ingredient List (INCI)';
  String get items => isTr ? 'Madde' : 'Items';
  String get noIngredientsYet => isTr ? 'Henüz içerik eklenmemiş.' : 'No ingredients added yet.';
  String get myReviewsTitle => isTr ? 'Cilt Deneyimlerim' : 'My Skin Experiences';
  String get addReview => isTr ? 'Deneyim Ekle' : 'Add Experience';
  String get noReviewsTitle => isTr ? 'Henüz Deneyim Kaydedilmedi' : 'No Experience Added Yet';
  String get noReviewsDesc => isTr
      ? 'Bu ürün cildinizde nasıl bir his bıraktı? Deneyiminizi ekleyerek gelecekteki analizlerinizi kişiselleştirin.'
      : 'How did this product feel on your skin? Add your review to personalize future analyses.';
  String get positiveEffect => isTr ? 'Olumlu Etki' : 'Positive Effect';
  String get neutralEffect => isTr ? 'Nötr Etki' : 'Neutral Effect';
  String get negativeEffect => isTr ? 'Olumsuz / Reaksiyon' : 'Negative / Reaction';
  String get positive => isTr ? 'Olumlu' : 'Positive';
  String get neutral => isTr ? 'Nötr' : 'Neutral';
  String get negative => isTr ? 'Olumsuz' : 'Negative';
  String get addReviewTitle => isTr ? 'Ürün Deneyimi Ekle' : 'Add Product Experience';
  String get reviewNoteLabel => isTr ? 'Deneyim Notunuz' : 'Your Experience Note';
  String get reviewNoteHint => isTr
      ? 'Cildinizdeki nemlendirme, parlaklık veya kızarıklık etkisini belirtin...'
      : 'Describe hydration, glowing feel, or redness reaction...';
  String get deleteConfirmTitle => isTr ? 'Deneyimi Sil' : 'Delete Experience';
  String get deleteReviewConfirmMsg => isTr
      ? 'Bu ürün deneyim kaydınızı kalıcı olarak silmek istediğinize emin misiniz?'
      : 'Are you sure you want to permanently delete this experience record?';
  String get deleteProductConfirmTitle => isTr ? 'Ürünü Sil' : 'Delete Product';
  String deleteProductConfirmMsg(String name) => isTr
      ? '"$name" ürününü koleksiyonunuzdan silmek istediğinize emin misiniz?'
      : 'Are you sure you want to delete "$name" from your collection?';

  // --- Cilt Profil Ekranı (Profile Screen) ---
  String get profileTitle => isTr ? 'Cilt Profilim' : 'My Skin Profile';
  String get profileHeaderTitle => isTr ? 'Kişisel Cilt Analiziniz' : 'Your Personal Skin Profile';
  String get profileHeaderSubtitle => isTr
      ? 'Alerjen ve kaçındığınız maddeler içerik analizlerinizde otomatik kontrol edilir.'
      : 'Allergens and avoided ingredients are automatically checked in analyses.';
  String get skinTypeTitle => isTr ? 'Cilt Tipiniz' : 'Your Skin Type';
  String get skinGoalsTitle => isTr ? 'Cilt Bakım Hedefleriniz' : 'Your Skincare Goals';
  String get allergensTitle => isTr ? 'Bilinen Alerjenleriniz' : 'Your Known Allergens';
  String get allergensDesc => isTr
      ? 'Bu maddeler analizlerde en yüksek öncelikle ve kritik uyarı olarak denetlenir.'
      : 'These substances are checked with highest priority and critical alerts.';
  String get quickAllergenSuggestions => isTr
      ? 'Sık Karşılaşılan Alerjenler (Listeden Seçin):'
      : 'Common Allergens (Tap to pick):';
  String get customAllergenHint => isTr ? 'Farklı bir alerjen yazın...' : 'Type another allergen...';
  String get savedAllergensHeader => isTr ? 'Kayıtlı Alerjenleriniz' : 'Your Saved Allergens';
  String get noAllergensYet => isTr ? 'Henüz kayıtlı alerjen bulunmuyor.' : 'No saved allergens yet.';
  String get avoidedTitle => isTr ? 'Kaçınmak İstediğiniz İçerikler' : 'Avoided Ingredients';
  String get avoidedDesc => isTr
      ? 'Kişisel tercihinizle cildinize temas etmesini istemediğiniz maddeler.'
      : 'Substances you personally prefer not to apply to your skin.';
  String get quickAvoidedSuggestions => isTr
      ? 'Yaygın Kaçınılan Maddeler (Listeden Seçin):'
      : 'Common Avoided Substances (Tap to pick):';
  String get customAvoidedHint => isTr ? 'Farklı bir madde yazın...' : 'Type another substance...';
  String get savedAvoidedHeader => isTr ? 'Kaçındığınız Maddeler' : 'Avoided Substances';
  String get noAvoidedYet => isTr ? 'Henüz kaçınılan madde eklenmedi.' : 'No avoided substances yet.';
  String get updateProfileBtn => isTr ? 'Profilimi Güncelle' : 'Update My Profile';
  String get profileSavedSuccess => isTr
      ? 'Cilt profiliniz başarıyla kaydedildi.'
      : 'Your skin profile has been saved successfully.';
  String get loadingProfile => isTr ? 'Cilt profiliniz yükleniyor...' : 'Loading your skin profile...';
  String get somethingWentWrong => isTr ? 'Bir Şeyler Ters Gitti' : 'Something Went Wrong';

  // --- Ürün Adı Dinamik Çeviri ---
  /// Tohum veya standart ürün isimlerini seçili dile göre çevirir
  String translateProductName(String name) {
    if (isTr) return name;
    switch (name) {
      case 'CeraVe Nemlendirici Krem':
        return 'CeraVe Moisturizing Cream';
      case 'Anthelios UVMune 400 Güneş Kremi':
        return 'Anthelios UVMune 400 Invisible Fluid Sunscreen';
      case 'Nemlendirici Krem':
        return 'Moisturizing Cream';
      case 'Güneş Kremi':
        return 'Sunscreen';
      case 'İsimsiz Ürün':
        return 'Unnamed Product';
      default:
        return name;
    }
  }

  // --- Cilt Tipleri ve Hedefleri Dinamik Çeviri ---
  String translateSkinType(String type) {
    if (isTr) return type;
    switch (type) {
      case 'Kuru': return 'Dry';
      case 'Yağlı': return 'Oily';
      case 'Karma': return 'Combination';
      case 'Hassas': return 'Sensitive';
      case 'Normal': return 'Normal';
      default: return type;
    }
  }

  String translateGoal(String goal) {
    if (isTr) return goal;
    switch (goal) {
      case 'Nemlendirme': return 'Hydration';
      case 'Bariyer Onarımı': return 'Barrier Repair';
      case 'Akne Karşıtı': return 'Anti-Acne';
      case 'Yaşlanma Karşıtı': return 'Anti-Aging';
      case 'Aydınlatma': return 'Brightening';
      case 'Gözenek Sıkılaştırma': return 'Pore Tightening';
      case 'Kızarıklık Yatıştırma': return 'Redness Soothing';
      default: return goal;
    }
  }

  String translateSuggestedAllergen(String item) {
    if (isTr) return item;
    switch (item) {
      case 'Parfüm':
      case 'Parfüm / Fragrance':
        return 'Fragrance / Parfum';
      case 'Linalool':
        return 'Linalool';
      case 'Limonene':
        return 'Limonene';
      case 'Citronellol':
        return 'Citronellol';
      case 'Geraniol':
        return 'Geraniol';
      case 'Benzil Alkol':
        return 'Benzyl Alcohol';
      case 'Nikel':
        return 'Nickel';
      case 'Esansiyel Yağlar':
        return 'Essential Oils';
      case 'Formaldehit':
        return 'Formaldehyde';
      default:
        return item;
    }
  }

  String translateSuggestedAvoided(String item) {
    if (isTr) return item;
    switch (item) {
      case 'Sülfat (SLS/SLES)': return 'Sulfate (SLS/SLES)';
      case 'Paraben': return 'Paraben';
      case 'Kurutucu Alkol': return 'Drying Alcohol';
      case 'Silikon': return 'Silicone';
      case 'Mineral Yağ': return 'Mineral Oil';
      case 'Yapay Renklendirici': return 'Synthetic Dyes';
      case 'Ftalat': return 'Phthalate';
      default: return item;
    }
  }

  // --- İçerik Analiz Raporu (Analysis Result) ---
  String get analysisReportTitle => isTr ? 'İçerik Analiz Raporu' : 'Ingredient Analysis Report';
  String get analysisFailed => isTr ? 'Analiz gerçekleştirilemedi.' : 'Analysis could not be performed.';
  String get criticalAllergenDetected => isTr
      ? 'DİKKAT: Alerjen Eşleşmesi Tespit Edildi!'
      : 'ATTENTION: Known Allergen Detected!';
  String get criticalAllergenNotice => isTr
      ? 'Bu ürün, profilinizde tanımlı bilinen alerjen maddeleri içermektedir.'
      : 'This product contains known allergens defined in your skin profile.';
  String get profileScoreTitle => isTr ? 'Profil Uygunluk Puanı' : 'Profile Match Score';
  String get dataSufficiencyTitle => isTr ? 'Veri Yeterliliği' : 'Data Sufficiency';
  String get dataSufficiencyHigh => isTr ? 'Yüksek' : 'High';
  String get dataSufficiencyMedium => isTr ? 'Orta' : 'Medium';
  String get dataSufficiencyLow => isTr ? 'Düşük' : 'Low';
  String get dataSufficiencyFullMsg => isTr
      ? 'Ürünün onaylanmış içerik listesi eksiksiz analiz edildi.'
      : 'The verified ingredient list was completely analyzed.';
  String get dataSufficiencyShortMsg => isTr
      ? 'İçerik listesi kısa olduğu için bazı bileşen etkileşimleri sınırlı değerlendirilmiş olabilir.'
      : 'Due to short ingredient count, some interactions may be evaluated with limited context.';
  String get dataSufficiencyEmptyMsg => isTr
      ? 'Ürüne ait onaylanmış INCI içerik listesi bulunmuyor.'
      : 'No verified INCI ingredient list is available for this product.';
  String get reasonedFindingsTitle => isTr ? 'Gerekçeli Bulgular' : 'Reasoned Findings';
  String get noFindingsMsg => isTr
      ? 'Bu ürün için herhangi bir risk veya uyumsuzluk sinyali tespit edilmedi.'
      : 'No risk or incompatibility signals detected for this product.';
  String get legalDisclaimer => isTr
      ? 'ciltİzi uygulaması kayıtlı kullanıcı verilerine dayalı bir gösterge analizidir. Tıbbi bir teşhis, tedavi veya klinik garanti sunmaz. Ciddi reaksiyonlarda mutlaka bir dermatoloğa başvurunuz.'
      : 'ciltİzi provides indicative analysis based on user data. It does not provide medical diagnosis or treatment. Consult a dermatologist for serious skin issues.';

  String translateSignalTitle(String originalTitle, String severity) {
    if (isTr) return originalTitle;
    if (severity == 'critical') return 'Critical Allergen Match';
    if (originalTitle.contains('Kaçınılacak')) return 'Avoided Substance Detected';
    if (originalTitle.contains('Hassasiyet')) return 'Potential Sensitivity Signal';
    return originalTitle;
  }

  String translateSignalDesc(String desc, String ingredient, String severity) {
    if (isTr) return desc;
    if (severity == 'critical') {
      return 'Known allergen "$ingredient" from your profile was found in this formula.';
    }
    if (desc.contains('kaçınmak')) {
      return 'Avoided substance "$ingredient" is present in this product.';
    }
    if (desc.contains('olumsuz deneyim')) {
      return '"$ingredient" is present in at least 2 products that previously caused negative experiences.';
    }
    return desc;
  }

  // --- Ayarlar Ekranı (Settings Screen) ---
  String get settingsTitle => isTr ? 'Ayarlar' : 'Settings';
  String get appearanceHeader => isTr ? 'Görünüm ve Tema Tercihi' : 'Appearance & Theme Preference';
  String get systemThemeTitle => isTr ? 'Sistem Teması (Varsayılan)' : 'System Theme (Default)';
  String get systemThemeDesc => isTr
      ? 'Cihazınızın sistem temasını otomatik takip eder.'
      : 'Automatically follows your device system theme.';
  String get lightThemeTitle => isTr ? 'Açık Tema (Light Mode)' : 'Light Theme (Light Mode)';
  String get lightThemeDesc => isTr
      ? 'İpeksi gül ve mürdüm tonlarında aydınlık arayüz.'
      : 'Bright interface in silky rose & plum tones.';
  String get darkThemeTitle => isTr ? 'Koyu Tema (Dark Mode)' : 'Dark Theme (Dark Mode)';
  String get darkThemeDesc => isTr
      ? 'Yüksek kontrastlı, göz yormayan derin gece mürdümü.'
      : 'High contrast, eye-friendly deep night plum.';
  String get languageHeader => isTr ? 'Uygulama Dili (Language)' : 'App Language';
  String get turkishTitle => isTr ? 'Türkçe' : 'Turkish';
  String get turkishDesc => isTr
      ? 'Uygulama arayüzü ve içerik analizleri Türkçe gösterilir.'
      : 'Application interface and analysis in Turkish.';
  String get englishTitle => isTr ? 'English' : 'English';
  String get englishDesc => isTr
      ? 'Uygulama arayüzü ve içerik analizleri İngilizce gösterilir.'
      : 'Application interface and analysis in English.';
  String get privacyHeader => isTr ? 'Gizlilik ve Yerel Güvenlik' : 'Privacy & Local Security';
  String get privacyDesc => isTr
      ? 'ciltİzi uygulaması çevrimdışı öncelikli (offline-first) olarak çalışır. Tüm ürün kayıtlarınız, INCI analizleriniz ve deneyim notlarınız yalnızca bu cihazda şifreli/yerel olarak saklanır. Hiçbir kişisel veri izniniz olmadan üçüncü taraf sunuculara gönderilmez.'
      : 'ciltİzi operates offline-first. All your product records, INCI analyses, and experience notes are kept locally on this device. No personal data is sent to external servers without permission.';
  String get aboutHeader => isTr ? 'ciltİzi Hakkında' : 'About ciltİzi';
  String get aboutDesc => isTr
      ? 'Sürüm: 1.0.0 (MVP)\nKişiselleştirilmiş Kozmetik İçerik ve Rutin Analizi Platformu'
      : 'Version: 1.0.0 (MVP)\nPersonalized Skincare Ingredient & Routine Analysis Platform';

  // --- Ürün Ekle / Düzenle (Add / Edit Product) ---
  String get addProductScreenTitle => isTr ? 'Yeni Ürün Ekle' : 'Add New Product';
  String get editProductScreenTitle => isTr ? 'Ürünü Düzenle' : 'Edit Product';
  String get productNameField => isTr ? 'Ürün Adı *' : 'Product Name *';
  String get productNameHint => isTr ? 'Örn: Nemlendirici Hyaluronik Serum' : 'E.g., Hydrating Hyaluronic Serum';
  String get productNameError => isTr ? 'Lütfen ürün adını giriniz.' : 'Please enter product name.';
  String get brandField => isTr ? 'Marka' : 'Brand';
  String get brandHint => isTr ? 'Örn: The Ordinary, CeraVe' : 'E.g., The Ordinary, CeraVe';
  String get ocrCardHeader => isTr ? 'Ambalajdan İçerik Tara (OCR)' : 'Scan Packaging Ingredients (OCR)';
  String get ocrCardDesc => isTr
      ? 'Ürün arkasındaki içerik listesinin fotoğrafını çekerek veya galeriden seçerek otomatik metin önerisi alabilirsiniz.'
      : 'Take a photo of the ingredient list on packaging or choose from gallery for automatic suggestions.';
  String get cameraBtn => isTr ? 'Kamera' : 'Camera';
  String get galleryBtn => isTr ? 'Galeri' : 'Gallery';
  String get inciFieldLabel => isTr ? 'İçerik Listesi (INCI) *' : 'Ingredient List (INCI) *';
  String get inciFieldHint => isTr ? 'Water, Glycerin, Niacinamide...' : 'Water, Glycerin, Niacinamide...';
  String get inciFieldError => isTr ? 'Lütfen en az bir içerik maddesi giriniz.' : 'Please enter at least one ingredient.';
  String get inciHelperText => isTr ? 'Bileşenleri virgülle ayırarak yazın.' : 'Separate ingredients with commas.';
  String get paoFieldLabel => isTr ? 'PAO Süresi (Ay)' : 'PAO Period (Months)';
  String get paoFieldHint => isTr ? 'Örn: 12' : 'E.g., 12';
  String get datesHeader => isTr ? 'Tarih ve Raf Ömrü Takibi' : 'Dates & Shelf Life Tracking';
  String get openedDateTile => isTr ? 'Ürün Açılış Tarihi' : 'Product Opened Date';
  String get expiryDateTile => isTr ? 'Son Kullanma Tarihi (SKT)' : 'Expiration Date (EXP)';
  String get pickDateBtn => isTr ? 'Tarih Seç' : 'Pick Date';
  String get saveProductBtn => isTr ? 'Ürünü Kaydet' : 'Save Product';
  String get saveChangesBtn => isTr ? 'Değişiklikleri Kaydet' : 'Save Changes';

  // --- OCR Doğrulama Ekranı (OCR Validation) ---
  String get ocrValidationTitle => isTr ? 'OCR İçerik Doğrulama' : 'OCR Ingredient Verification';
  String get ocrDisclaimer => isTr
      ? 'OCR çıktısı optik okuma hataları içerebilir. Lütfen ambalajdaki içeriklerle karşılaştırıp gerekiyorsa düzeltiniz ve onaylayınız.'
      : 'OCR text may contain optical recognition errors. Please verify against packaging ingredients before confirming.';
  String get editScannedText => isTr ? 'Taranan Metni Düzenle' : 'Edit Scanned Text';
  String get ocrInputHint => isTr ? 'İçerikleri virgül ile ayırarak kontrol ediniz...' : 'Check ingredients separated by commas...';
  String get parsedIngredientsTitle => isTr ? 'Ayrıştırılan Bileşenler' : 'Parsed Ingredients';
  String get preview => isTr ? 'Önizleme' : 'Preview';
  String get noParsedIngredients => isTr
      ? 'Henüz ayrıştırılmış içerik bulunamadı. Lütfen yukarıdaki metne virgül ile ayrılmış bileşenler giriniz.'
      : 'No ingredients parsed yet. Please enter comma-separated ingredients above.';
  String get confirmAndApplyBtn => isTr ? 'İçerikleri Onayla ve Ürüne Aktar' : 'Confirm & Transfer to Product';
}

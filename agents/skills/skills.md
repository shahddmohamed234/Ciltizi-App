---
name: ciltizi-development
description: ciltİzi Flutter uygulamasında mimari, kodlama, veri saklama, OCR, analiz, test ve AI destekli geliştirme kurallarını tanımlar.
---

# ciltİzi — Geliştirme ve Kodlama Kuralları

Bu belge, project.md içinde tanımlanan ürün kapsamının teknik olarak nasıl uygulanacağını açıklar. Ürün kapsamı için project.md, mimari ve kodlama kuralları için bu dosya referans alınır.

## 1. Teknik Standartlar

- Flutter ve Dart kullanılır.
- Durum yönetimi için flutter_bloc kullanılır. Basit ve yerel durumlarda Cubit, birden fazla aşama veya olayın birbirini tetiklediği akışlarda Bloc tercih edilir.
- Mimari yaklaşım Clean Architecture ilkelerine dayanır.
- Yerel veri saklama için Hive ailesinden tek bir uyumlu çözüm seçilir. Bu taslakta önerilen standart hive_ce, hive_ce_flutter, hive_ce_generator ve build_runner paketleridir. Uygulamadaki pubspec.yaml farklı bir Hive çözümünü zaten kullanıyorsa kod üretmeden önce ekip kararıyla tek standart belirlenmeli; Hive ve Hive CE API'leri gelişigüzel karıştırılmamalıdır.
- OCR için google_mlkit_text_recognition gibi seçilen OCR paketi; görsel seçimi için image_picker; dosya yolu işlemleri için path_provider kullanılabilir.
- Tarih biçimlendirme ve yerelleştirme için intl ve Flutter localization altyapısı değerlendirilebilir.
- Benzersiz kimlik gerektiren kayıtlar için uuid kullanılabilir.
- Gerçekte projeye eklenmemiş bir paket kullanılıyormuş gibi varsayım yapılmaz. Paket eklemeden önce gereklilik ve Flutter/Dart sürüm uyumluluğu kontrol edilir.

## 2. Mimari Sınırlar

Kod, sorumluluklarına göre ayrılır:

- Presentation: Ekranlar, widget'lar, Bloc/Cubit ve UI durumları.
- Domain: İş kuralları, entity'ler, repository sözleşmeleri ve use case'ler.
- Data: Repository uygulamaları, yerel veri kaynakları, DTO/model dönüşümleri ve seed verileri.
- Core: Tema, hata tipleri, yardımcı bileşenler ve ortak sabitler.

Kurallar:
- Widget'ların içinde iş mantığı veya doğrudan veritabanı işlemi yazılmaz.
- UI katmanı Hive kutularına doğrudan erişmez.
- Domain katmanı Flutter widget'larına, Hive'a veya UI framework ayrıntılarına bağımlı olmamalıdır.
- Veri kaynağı ayrıntıları repository uygulamalarında tutulur.
- Her sınıfın ve fonksiyonun tek, anlaşılır bir sorumluluğu olmalıdır.
- SOLID, DRY ve KISS ilkeleri uygulanır; gereksiz soyutlama da gereksiz tekrar da önlenir.

## 3. Önerilen Klasör Yapısı

Mevcut projenin yapısı korunarak aşağıdaki düzen izlenebilir:

lib/
  app/
    app.dart
    router/
  core/
    constants/
    errors/
    theme/
    utils/
    widgets/
  features/
    profile/
      data/
      domain/
      presentation/
    products/
      data/
      domain/
      presentation/
    reviews/
      data/
      domain/
      presentation/
    analysis/
      data/
      domain/
      presentation/
    routines/
      data/
      domain/
      presentation/
    settings/
      data/
      domain/
      presentation/
  main.dart

assets/
  products.json

test/
  unit/
  widget/
  integration_test/

Henüz uygulanmayan özellikler için boş klasörler veya gereksiz kod oluşturmak zorunlu değildir. Örneğin rutinler Aşama 2 özelliğidir.

## 4. Kodlama Stili

- Sınıf ve enum isimleri UpperCamelCase; değişken, parametre ve fonksiyon isimleri anlamlı İngilizce lowerCamelCase kullanır.
- Sabitler ve dosya isimleri projede tutarlı bir standarda göre adlandırılır.
- Kısa ternary ifadeleri yalnızca gerçekten okunaklı olduklarında kullanılabilir. Karmaşık UI koşullarında açık if / else if / else veya ayrı widget/fonksiyonlar tercih edilir.
- Sabit renk ve padding değerleri widget'ların içine gelişigüzel yazılmaz; tema ve ortak tasarım sabitleri kullanılır.
- Theme.of(context) ve tanımlı ThemeData tercih edilir.
- Fonksiyonlar küçük, anlaşılır ve test edilebilir tutulur.
- Hatalar sessizce yutulmaz. Kullanıcıya anlaşılır mesaj, geliştiriciye ise uygun hata bağlamı sağlanır.
- Kullanıcıya görünen metinler mümkün olduğunca merkezi ve yerelleştirmeye uygun tutulur.
- Her değişiklik mevcut kod stilini ve çalışan akışları korumalıdır.

## 5. Tema ve UI

- Rose & Plum paleti uygulamanın Light ve Dark temalarında ortak marka kimliğidir. Yeşil veya standart mavi ana tema olarak kullanılmaz.
- Renk, tipografi ve bileşen stilleri tek bir tema dosyasında (ör. lib/core/theme/app_theme.dart) yönetilir.
- lightTheme ve darkTheme ayrı ThemeData tanımları olarak oluşturulur; MaterialApp içinde theme, darkTheme ve themeMode doğru biçimde bağlanır.
- Varsayılan ThemeMode.system olmalıdır. Kullanıcı Settings ekranından System, Light veya Dark seçebilir.
- Kullanıcının seçimi yerel olarak saklanır ve uygulama yeniden açıldığında geri yüklenir. System seçiliyse cihazın işletim sistemi tema tercihi takip edilir.
- Dark Theme yalnızca renkleri tersine çevirmekten ibaret değildir: arka plan, yüzey, kart, metin, ayraç, giriş alanı, dialog ve uyarı renkleri ayrı ayrı okunabilir olacak şekilde tanımlanır.
- Her iki temada da metin kontrastı, durum renklerinin anlamı ve odak/etkileşim durumları kontrol edilir. Rose & Plum marka hissi korunurken metin okunabilirliği önceliklidir.
- Material 3 kullanılabilir; mevcut Flutter sürümü ve tasarımla uyumluluk kontrol edilir.
- Ekranlarda şu durumlar gerektiğinde açıkça ele alınır: loading, loaded/content, empty ve error.
- Form alanları doğrulanır; silme gibi veri kaybına yol açan işlemlerde uygun onay akışı sağlanır.
- Metin taşması, küçük ekranlar, klavye açılması, erişilebilir kontrast ve ekran okuyucu etiketleri göz önünde bulundurulur.

## 6. Yerel Veri Saklama ve Başlangıç Verileri

Hive CE kullanılacaksa modeller için uygun adapter'lar oluşturulur ve gerekli kod üretimi build_runner ile yapılır.

Önerilen veri grupları/kutu adları:
- skin_profile_box
- products_box
- reviews_box
- analysis_history_box
- settings_box

Bu adlar teknik öneridir; mevcut uygulamada kullanılan adlar varsa geçiş kararı alınmadan değiştirilmez.

Kurallar:
- Veritabanı açılışı ve okuma/yazma işlemleri asenkron akışlarda ele alınır.
- Veri erişimi repository katmanından yapılır.
- Model alanı veya adapter değişiklikleri mevcut yerel veriyi bozmayacak şekilde planlanır.
- assets/products.json gibi başlangıç verileri ilk kurulumda veya kontrollü bir seed sürümleme mekanizmasıyla eklenir.
- Seed işlemi tekrar çalıştığında aynı ürünü tekrar tekrar eklememeli, kullanıcının değiştirdiği veya eklediği kayıtları ezmemelidir.
- Başlangıç verisinde olmayan ürün içeriği veya INCI bilgisi uydurulmaz.
- Veritabanı açılış hataları ve bozuk kayıtlar kontrollü biçimde ele alınır.
- Kullanıcı bir kaydı silince ilişkili analiz geçmişi ve bağlantılı kayıtların davranışı belirlenmiş bir kurala göre uygulanır.

## 7. Veri Modelleri

İhtiyaca göre aşağıdaki temel modeller kullanılabilir:

### SkinProfile
- Kullanıcı profil kimliği
- Cilt tipi ve hedefleri
- Bilinen alerjenler
- Kaçınılacak içerikler
- Oluşturulma/güncellenme zamanları

### Product
- Ürün kimliği ve adı
- Marka (biliniyorsa)
- INCI içerik listesi
- Ham OCR metni (varsa)
- Kullanıcı tarafından doğrulanma durumu
- Eklenme ve güncellenme zamanları
- Açılma tarihi, PAO süresi ve son kullanma tarihi (biliniyorsa; birbirinden ayrı alanlar)

### ProductReview
- İnceleme kimliği
- Ürün kimliği
- Kullanıcının deneyim notu
- Deneyimin olumlu/olumsuz/nötr etiketi (kullanılıyorsa)
- Tarih ve kullanım bağlamı (kullanıcı sağladıysa)

### AnalysisResult
- Analiz kimliği ve ürün kimliği
- Eşleşen alerjenler/kaçınılan içerikler
- Diğer analiz sinyalleri ve açıklamaları
- Veri yeterliliği/güven etiketi
- Puan (kullanılıyorsa)
- Algoritma sürümü ve analiz tarihi

### AppSettings
- Tema tercihi: system, light veya dark
- Erişilebilirlik tercihleri
- Bildirim tercihleri (uygulandığında)
- Uygulamaya özgü kullanıcı ayarları

Yalnızca uygulamada gerçekten kullanılan alanlar eklenmelidir. Veri modeli, UI ihtiyaçlarına göre gereksiz alanlarla doldurulmamalıdır.

## 8. OCR ve INCI Doğrulama Akışı

1. Kullanıcı fotoğrafı kameradan veya galeriden seçer.
2. OCR metin önerisi çıkarır.
3. Ham OCR metni kaydedilebilir ve gerektiğinde hata ayıklama/yeniden düzenleme için korunur.
4. Kullanıcıya düzenlenebilir bir doğrulama ekranı gösterilir.
5. Kullanıcı onaylamadan OCR sonucu kesin INCI listesi olarak analize sokulmaz.
6. Onaylanan metin, içerik adlarını ayırmak ve normalize etmek için işlenir.
7. Normalizasyon, bilinen ve güvenilir eş anlamlılarla sınırlı tutulur; içerik adı belirsizse tahminle değiştirilmez.
8. Kullanıcının onayladığı içerik listesi ile ham OCR metni birbirinden ayrı tutulur.

OCR'ın metin çıkarması, içerik bilgisinin doğru olduğu anlamına gelmez. Belirsizlik kullanıcıya gösterilmelidir.

## 9. Kişiselleştirilmiş Analiz Kuralları

Analiz saf ve test edilebilir domain mantığı olarak uygulanır; UI içinde hesaplanmaz.

Önerilen işlem sırası:
1. Kullanıcının profil verileri ve doğrulanmış INCI listesi kontrol edilir.
2. Profildeki alerjen ve açıkça kaçınılan içerik eşleşmeleri önce belirlenir.
3. Eşleşme varsa kritik uyarı, puandan ve olumlu deneyimlerden önce gösterilir. Olumlu deneyimler bu uyarıyı iptal edemez.
4. Diğer sinyaller (ör. kullanıcının ürün deneyimleri) ayrı ve açıklanabilir şekilde değerlendirilir.
5. Veri eksikliği ve deneyim sayısı güven/veri yeterliliği etiketini etkiler.
6. Analiz sonucu, hangi girdilerin hangi gerekçeyle kullanıldığını saklayabilir; sonuçla birlikte algoritma sürümü kaydedilir.

İsteğe bağlı başlangıç puanı uygulanacaksa örnek formül:

score = max(0, 100 - (avoidedIngredientCount * 25) - (suspectedIngredientCount * 20))

Bu formül yalnızca ekip tarafından onaylanırsa kullanılmalıdır. Aynı içerik iki grupta da yer alıyorsa iki kez ceza uygulanmamalı; puan, alerjen uyarısını bastırmamalıdır. Katsayılar bilimsel/klinik bir ölçüm olarak tanıtılmamalıdır.

Olumsuz deneyimlerden şüpheli içerik çıkarımı yapılacaksa, tek bir kayda dayanarak kesin hüküm verilmez. Başlangıç kuralı olarak bir içerik, en az iki farklı olumsuz deneyim kaydına sahip ürünle ilişkili olduğunda “daha fazla inceleme gerektirebilir” sinyali olarak sunulabilir. Bu bir kanıt veya tıbbi sonuç değildir; ürünler ve kullanıcı deneyimleri arasındaki ilişki belirsizliğiyle birlikte açıklanır.

## 10. Rutin, PAO ve Tarih Kuralları

- İki ürünün içerik adlarına bakarak tek başına kesin zararlı kombinasyon iddiası oluşturulmaz.
- Rutin uyarısı verilecekse gerekçesi açıklanır ve belirsizlik uygun bir dille belirtilir.
- PAO süresi ve ürünün üzerindeki son kullanma tarihi farklı veri alanlarıdır.
- PAO değerlendirmesi için ürünün açılma tarihi ve PAO süresi gerekir.
- Son kullanma tarihi değerlendirmesi için gerçek tarih değeri gerekir.
- Gerekli veri eksikse tarih hesaplanmaz veya tahmin edilmez.
- İki bilgi de varsa her ikisi ayrı ayrı değerlendirilir; hangi uyarının hangi bilgiden kaynaklandığı açıklanır.
- Tarihin geçmiş olması, tek başına ürünün kesin olarak zararlı olduğunu göstermez. Uyarı tarih bilgisine dayalı dikkat bildirimi olarak ifade edilir.
- Tarih hesaplamalarında yerel tarih ve saat dilimi etkileri test edilir.

## 11. Gizlilik ve Güvenli Kullanım

- Profil ve deneyim verileri varsayılan olarak cihazda tutulur.
- Gereksiz kişisel veri toplanmaz; kayıtlar izinsiz olarak harici servislere gönderilmez.
- Görsel veya OCR metni harici bir servise gönderilecekse bu davranış açıkça tasarlanmalı ve kullanıcıya bildirilmelidir.
- Günlüklerde kişisel notlar veya gereksiz hassas içerikler tutulmaz.
- Uygulama tıbbi teşhis, tedavi önerisi veya kesin güvenlik garantisi vermez.
- Uyarı metinleri korkutucu, kesin veya bilimsel dayanağı olmayan iddialar içermemelidir.

## 12. Test Stratejisi

### Unit testleri
- Profil ve ürün doğrulama kuralları.
- İçerik normalizasyonu.
- Alerjen eşleşmesinin önceliği.
- Puan hesabı ve aynı içeriğin iki kez cezalandırılmaması.
- Veri yeterliliği etiketleri.
- PAO ve son kullanma tarihi mantığının ayrı çalışması.
- Eksik veri durumunda varsayımsal değer üretilmemesi.
- Rutin analizinin kesin zarar iddiası üretmemesi.

### Widget testleri
- Profil ve ürün formları.
- OCR metnini düzenleme ve onaylama akışı.
- Analiz açıklamaları ve kritik uyarı görünümü.
- Loading, empty, content ve error durumları.
- Light, Dark ve System tema seçimleri; uygulama yeniden başlatıldığında tercihin korunması.
- Form doğrulama ve silme onayı.

### Entegrasyon testleri
- Yerel verinin uygulama yeniden başlatıldığında korunması.
- Ürün ekleme/düzenleme/silme akışı.
- Seed verisinin tekrar çalıştırıldığında yinelenmemesi ve kullanıcı kayıtlarını ezmemesi.
- Temel işlevlerin çevrimdışı çalışması.

## 13. AI Asistanı / Geliştirici İş Akışı

Her görevde aşağıdaki sırayı izle:

1. Analyze: İlgili dosyaları, mimariyi, mevcut paketleri ve project.md kapsamını incele.
2. Plan: Değiştirilecek dosyaları ve olası etkileri kısa şekilde belirle.
3. Implement: İstenen kapsamla sınırlı değişiklik yap; ilgisiz dosyaları yeniden yazma.
4. Verify: Mümkünse dart format, flutter analyze ve ilgili flutter test komutlarını çalıştır. Kod üretimi gerekiyorsa mevcut adapter ve model durumunu kontrol et.
5. Report: Değişen dosyaları, test sonuçlarını ve kalan belirsizlikleri özetle.

Ek kurallar:
- Dosya veya paket mevcut değilse varmış gibi davranma.
- Doğrulanmamış testin başarılı olduğunu iddia etme.
- Geniş kapsamlı refactor yapmadan önce gerekliliği açıkla.
- Git commit, push, merge, sürüm yükseltme veya veri şeması kırıcı değişiklikleri açık istek olmadan yapma.
- Mimari ya da paket kararı iki dokümanda çelişiyorsa kod yazmadan önce kararı netleştir ve iki dokümanı tutarlı güncelle.
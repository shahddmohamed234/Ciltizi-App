# ciltİzi — Kişiselleştirilmiş İçerik Analizi

Bu doküman, ciltİzi Flutter projesinde çalışan Antigravity AI Agent ve yazılım geliştiricileri için bağlayıcı proje tanımıdır.

Geliştirmeler mevcut özellikleri, kullanıcı verilerini ve proje mimarisini korumalıdır. Ayrıntılı teknik kurallar `SKILL.md` dosyasında tanımlanmıştır.

---

## 1. Proje Özeti ve Teknolojiler

- **Uygulama Adı:** ciltİzi
- **Paket Adı:** `ciltizi`
- **Amaç:** Kozmetik ürünlerin INCI içeriklerini kullanıcıların kişisel deneyimleriyle karşılaştırarak olası uyumlu ve şüpheli bileşenleri belirlemek.
- **Platformlar:** Öncelikle Android ve iOS, sonrasında Web ve Masaüstü.
- **Flutter SDK:** 3.47.7
- **Dart SDK:** 3.13.5
- **Tasarım:** Material Design 3
- **Diller:** Türkçe (varsayılan), İngilizce
- **Tema:** Aydınlık ve Karanlık mod
- **Mimari:** Local-First, Clean Architecture ve SOLID
- **Durum Yönetimi:** Riverpod
- **Veritabanı:** Hive CE
- **OCR:** Google ML Kit
- **Backend:** Yok. Temel özellikler çevrimdışı çalışmalıdır.

## 2. Uygulama Özellikleri

### 2.1. Cilt Profili Oluşturma
- Cilt tipi seçimi: Normal, Yağlı, Kuru ve Karma.
- Cilt özellikleri ve problemleri: Hassasiyet, Rozasea, Akne, Sivilce Eğilimi, Kızarıklık vb.
- Bilinen alerjenlerin ve kaçınılmak istenen bileşenlerin ayrı ayrı belirlenmesi.
- Profil bilgilerinin düzenlenmesi ve yerel olarak saklanması.

### 2.2. Ürün Ekleme ve Kütüphane
- Ürün adı, marka ve kategori bilgileri.
- Kategoriler: Nemlendirici, Serum, Tonik, Güneş Kremi, Temizleyici, Maske, Peeling vb.
- INCI içeriklerinin manuel giriş, metin yapıştırma, örnek bileşen seçimi veya fotoğraf üzerinden OCR ile eklenmesi.
- İçeriklerin normalize edilmesi ve `Chip` bileşenleriyle görselleştirilmesi.
- Ürün arama, filtreleme, detay görüntüleme, düzenleme ve silme.
- Başlangıç ürünlerinin `assets/products.json` üzerinden yüklenebilmesi.

### 2.3. Kullanıcı Deneyimleri (Review / Reaction)
- Denenen ürünlere 1–5 arasında puan verilmesi.
- **Olumlu etkiler:** Nemlendirdi, Yatıştırdı, Matlaştırdı, Aydınlattı vb.
- **Olumsuz etkiler:** Sivilce Yaptı, Tahriş Etti, Kızarıklık Yaptı, Kuruluk Yaptı, Kaşıntı Yaptı, Komedon Yaptı vb.
- Kullanım süresi, deneyim tarihi ve kişisel not ekleme.
- Değerlendirmelerin düzenlenmesi, silinmesi ve geçmiş kayıtların görüntülenmesi.

### 2.4. Kişisel İçerik Eşleştirme Algoritması
- Olumlu değerlendirilen ürünlerin ortak içeriklerinden **Olumlu Deneyim İçerikleri** listesi oluşturulması.
- Olumsuz değerlendirilen ürünlerin bileşenlerinin karşılaştırılması.
- En az iki farklı olumsuz üründe ortak bulunan bileşenlerin **Şüpheli İçerikler** listesine aday olarak eklenmesi.
- Şüpheli bileşenler belirlenirken olumlu ürün deneyimlerinin de dikkate alınması.
- INCI eş adlarının normalize edilerek doğru eşleştirilmesi.
- Kişisel deneyim verilerinin miktarına ve tutarlılığına göre kanıt seviyesinin belirlenmesi.

**Önemli:** Olumlu deneyim yaşanan ürünlerin içerikleri kesin güvenli kabul edilmemeli; ortak bileşenler de kesin reaksiyon nedeni olarak gösterilmemelidir.

### 2.5. Yeni Ürün Analizi ve Uygunluk Skoru
- Yeni ürünün INCI listesinin mevcut kullanıcı verileriyle karşılaştırılması.
- Kaçınılan maddelerin, bilinen alerjenlerin ve şüpheli bileşenlerin belirlenmesi.
- 0–100 arasında kişiselleştirilmiş uygunluk skoru oluşturulması.

**Başlangıç skor formülü:**

`Skor = max(0, 100 - (Kaçınılan İçerik × 25) - (Şüpheli İçerik × 20))`

- Aynı bileşene gereksiz çift ceza uygulanmaması.
- Bilinen alerjenler için skordan bağımsız uyarı oluşturulması.
- Sonuçların gerekçeleri ve kanıt seviyesiyle açıklanması.
- Yetersiz veri durumunun kullanıcıya bildirilmesi.
- Analiz sonuçlarının sürüm bilgisiyle birlikte geçmişe kaydedilmesi.

Örnek çıktı:

"Bu ürün daha önce olumsuz deneyim yaşadığın ürünlerde bulunan 2 şüpheli bileşen içeriyor. Kişisel uygunluk skoru: %60."

Bu skor tıbbi güvenlik veya alerji olasılığı olarak sunulmamalıdır.

### 2.6. Arayüz ve Kişiselleştirme
- Material Design 3 ile modern, sade ve responsive tasarım.
- AppBar üzerinden reaktif Aydınlık/Karanlık tema geçişi.
- Türkçe ve İngilizce dil desteği.
- Tema ve dil tercihlerinin cihazda saklanması.
- Anlaşılır hata mesajları, yükleme göstergeleri ve boş durum ekranları.
- Kullanıcının OCR sonuçlarını kaydetmeden önce düzenleyebilmesi.

## 3. Veri Yönetimi ve Güvenlik

- Harici backend kullanılmayacaktır; kullanıcı verileri Hive CE üzerinde yerel olarak saklanacaktır.
- Cilt profili, ürünler, deneyimler, analiz geçmişi ve uygulama ayarları ayrı veri yapılarında yönetilecektir.
- Hassas veriler gerektiğinde şifrelenmeli, şifreleme anahtarları güvenli saklanmalıdır.
- Kullanıcı verileri izinsiz paylaşılmamalı veya gereksiz yere loglanmamalıdır.
- Kullanıcı kendi kayıtlarını silebilmelidir.
- Model güncellemelerinde mevcut verilerin bütünlüğü korunmalıdır.
- Uygulama tıbbi teşhis veya tedavi önerisi sunmamalıdır.

## 4. Geliştirme Kuralları

1. **Mimari:** SOLID ve Clean Architecture ilkelerine uyulmalı, gereksiz soyutlamalardan kaçınılmalıdır.
2. **Katmanlar:** Arayüz, iş mantığı ve veri erişimi birbirinden ayrılmalıdır.
3. **Kod:** Okunabilir, modüler, tekrar kullanılabilir ve test edilebilir olmalıdır.
4. **Bağımlılıklar:** Yeni paketler yalnızca ihtiyaç ve sürüm uyumluluğu kontrol edilerek eklenmelidir.
5. **Test:** INCI normalizasyonu, içerik eşleştirme, uygunluk skoru, veri işlemleri ve temel kullanıcı akışları test edilmelidir.
6. **Mevcut Sistem:** Kullanıcı talebi olmadan çalışan özellikler silinmemeli, ilgisiz dosyalar değiştirilmemelidir.
7. **Sürüm Yönetimi:** Git commit, push, merge ve release işlemleri açık kullanıcı talimatına bağlıdır.
8. **Doğrulama:** Geliştirme sonunda `flutter analyze` ve ilgili testler çalıştırılmalı; çalıştırılamayan kontroller açıkça belirtilmelidir.

## 5. Agent Çalışma Prensibi

Antigravity Agent her görevde:

1. **Analyze:** Mevcut kodu, mimariyi ve kullanıcı isteğini inceler.
2. **Plan:** Gerekli değişiklikleri ve etkilenecek dosyaları belirler.
3. **Implement:** İstenen özelliği mevcut yapıyla uyumlu geliştirir.
4. **Verify:** Kod kalitesini, testleri ve mevcut işlevleri kontrol eder.
5. **Report:** Yapılan değişiklikleri, test sonuçlarını ve varsa sorunları bildirir.

---

## Projenin Temel Hedefi

ciltİzi; kullanıcıların kişisel kozmetik deneyimlerini INCI içerikleriyle ilişkilendirerek daha bilinçli ürün değerlendirmeleri yapmalarına yardımcı olan, veri gizliliğini koruyan, açıklanabilir analizler sunan ve geliştirilebilir bir uygulama olmalıdır.

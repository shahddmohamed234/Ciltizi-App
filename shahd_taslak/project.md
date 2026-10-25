---
name: ciltizi-core-architecture
description: >-
  ciltİzi Flutter projesi için BLoC tabanlı durum yönetimi, Hive yerel veritabanı,
  Clean Architecture standartları ve rutin/ürün ömrü takibini tanımlayan proje planı.
---

# ciltİzi — Gelişmiş İçerik & Rutin Analizi (Alternatif Taslak)

Bu doküman, **ciltİzi** uygulamasının ürün kapsamını, kullanıcı akışlarını ve başarı kriterlerini tanımlar. Kod mimarisi, paket kullanımı, algoritmanın teknik ayrıntıları ve geliştirme kuralları için `agents/skills/skills.md` esas alınır. Belgeler arasında teknik bir çelişki olursa `skills.md` içindeki kurallar geçerlidir.

## 1. Proje Özeti ve Teknik Altyapı

- **Uygulama adı:** ciltİzi
- **Amaç:** Kullanıcının cilt profili ve kendi ürün deneyimlerinden yararlanarak kozmetik içeriklerini kişiselleştirilmiş ve açıklanabilir şekilde değerlendirmesine yardımcı olmak.
- **Mimari:** Clean Architecture (Domain, Data, Presentation).
- **Durum yönetimi:** `flutter_bloc` (basit durumlarda Cubit, daha karmaşık akışlarda Bloc).
- **Veri saklama:** Hive; uygulama öncelikle yerel çalışır ve temel kullanıcı verileri cihazda saklanır.
- **Tasarım:** Material 3, bordo ve pembe renk paleti; tema kuralları `skills.md` ile uyumlu olmalıdır.
- **Dil:** Türkçe varsayılan dil.
- **Ek modüller:** OCR ile içerik okuma, sabah/akşam rutinleri ve PAO takibi.

Uygulama tıbbi tanı koymaz, alerji olasılığı hesapladığını iddia etmez ve tedavi önermez. Analizler kullanıcının girdiği bilgiler ve kayıtlı deneyimleri temelinde kişisel bir değerlendirme olarak sunulur.

## 2. Temel Kullanıcı Akışı

1. Kullanıcı cilt profilini oluşturur; cilt tipini, endişelerini, bilinen alerjenlerini ve uzak durmak istediği içerikleri kaydeder.
2. Kullanıcı bir ürünü ürün kütüphanesine ekler. İçerik listesini elle girebilir, yapıştırabilir veya OCR ile okuyabilir.
3. OCR sonucu kullanıcıya gösterilir ve kaydetmeden önce doğrulaması/düzeltmesi istenir.
4. Kullanıcı ürüne dair puanını, olumlu/olumsuz etkilerini, kullanım süresini ve isteğe bağlı notlarını kaydeder.
5. Sistem içerik listesini kullanıcının profili ve geçmiş deneyimleriyle karşılaştırır; eşleşmeleri, uyarıları, veri yeterliliğini ve sonucun nedenini açıklar.
6. Kullanıcı ürünlerini, analiz geçmişini ve daha sonraki aşamalarda rutin/PAO bilgilerini yönetir.

## 3. Özellikler

### 3.1. Cilt Profili ve Yerel Veri

- Cilt tipi, cilt endişeleri, bilinen alerjenler ve kaçınılan içerikler ayrı alanlar olarak tutulur.
- Profil verileri Hive üzerinde kalıcı olarak saklanır.
- Başlangıç ürünleri `assets/products.json` dosyasından yüklenebilir. Başlangıç verileri tekrar yüklenirken kullanıcı tarafından eklenen veya düzenlenen kayıtların üzerine yazılmamalı ve kopya ürünler oluşturulmamalıdır.

### 3.2. Ürün Kütüphanesi ve İçerik Girişi

- Kullanıcı ürün ekleyebilir, düzenleyebilir, silebilir, arayabilir ve filtreleyebilir.
- İçerik listesi elle girilebilir, metin olarak yapıştırılabilir veya OCR ile okunabilir.
- OCR çıktısı kesin/doğrulanmış veri olarak kabul edilmez. Kullanıcı çıktıyı kontrol edip düzeltebilmelidir; mümkün olduğunda ham OCR metni de korunmalıdır.
- İçerik normalizasyonu yalnızca güvenilir ve doğrulanmış eş anlamlıları birleştirmelidir. Ham içerik bilgisi sessizce değiştirilmemelidir.

### 3.3. Ürün Deneyimleri

- Kullanıcı puan, olumlu/olumsuz deneyim, kullanım süresi, tarih ve isteğe bağlı not kaydedebilir.
- Bir ürüne ilişkin olumlu geçmiş deneyim, profilde eşleşen bilinen bir alerjeni geçersiz kılamaz.
- Az sayıda veya tutarsız kayıt varsa sistem kesin bir kişisel örüntü varmış gibi davranmamalı; veri yetersizliğini açıkça belirtmelidir.

### 3.4. Kişiselleştirilmiş İçerik Analizi

- Önce kullanıcının profilinde kayıtlı bilinen alerjenlerle eşleşmeler kontrol edilir. Eşleşme varsa belirgin bir uyarı gösterilir; kişisel skor bu uyarıyı gizleyemez veya etkisizleştiremez.
- Diğer içerik değerlendirmeleri, kullanıcının kaydettiği olumlu ve olumsuz deneyimlerle karşılaştırılır.
- Sonuç, hangi içeriklerin eşleştiğini ve bu eşleşmenin hangi kullanıcı kayıtlarına dayandığını açıklamalıdır.
- Veri miktarı ve tutarlılığına göre güven düzeyi açıkça belirtilmelidir; yeterli veri yoksa skor/sonuç kesinmiş gibi sunulmamalıdır.
- Herhangi bir puan yalnızca kişisel deneyimlere dayalı bir gösterge olarak tanımlanmalıdır; tıbbi risk, alerji olasılığı veya ürünün herkes için güvenli/güvensiz olduğunun ölçüsü değildir.
- Algoritmanın ayrıntılı eşleştirme ve skorlama kuralları `skills.md` içinde tanımlanır.

### 3.5. Sabah / Akşam Rutin Yöneticisi — Aşama 2

- Kullanıcı ürünleri sabah veya akşam rutinlerine ekleyebilir, sıralayabilir, düzenleyebilir ve çıkarabilir.
- Aynı rutinde bulunan ürünler arasında olası içerik/aktif bileşen etkileşimi tespit edilirse sistem uyarı gösterebilir.
- **Uyarılar kesin hüküm gibi sunulmamalıdır.** Bir içerik kombinasyonu yalnızca adları nedeniyle otomatik olarak zararlı ilan edilmemelidir. Uyarı, mevcut ve güvenilir bilgiye dayanmalı; kanıt sınırlıysa bu açıkça belirtilmelidir.
- Uygulama kullanıcıya tanı veya tedavi önermez. Uyarılar genel bilgilendirme niteliğindedir; kullanıcının ürün talimatları ve gerektiğinde sağlık uzmanı tavsiyesi yerine geçmez.
- Rutin uyarısı, kullanıcının bilinen alerjenleri için gösterilen kritik uyarının yerini alamaz.

### 3.6. PAO ve Son Kullanma Tarihi Takibi — Aşama 2

- Kullanıcı ürünün kapağını açtığı tarihi ve ambalaj üzerinde belirtilen PAO süresini (ör. 6M veya 12M) kaydedebilir.
- PAO, ürün açıldıktan sonra önerilen kullanım süresini belirtir; **ambalaj üzerindeki son kullanma tarihiyle aynı şey değildir**.
- Ürünün son kullanma tarihi biliniyorsa bu tarih ayrıca saklanmalıdır. PAO bitiş tarihi, açılış tarihi ve belirtilen PAO süresi üzerinden hesaplanır.
- Hatırlatmalarda bilinen tarihler ayrı ayrı değerlendirilir. Tarihlerden biri geçmişse veya yaklaşıyorsa kullanıcıya hangi tarihin esas alındığı açıkça gösterilir; her iki tarih de biliniyorsa daha erken olan ilgili sınır için uyarı verilir.
- Açılış tarihi, PAO süresi veya son kullanma tarihi bilinmiyorsa sistem tarih uydurmamalı; eksik bilgiyi belirtmelidir.
- Tarihin geçmiş olması tek başına ürünün kesin olarak zararlı olduğunu kanıtlamaz. Uyarı, kullanım süresinin dolduğunu belirtmeli; kesin tıbbi/kimyasal sonuç iddiasında bulunmamalıdır.

### 3.7. Ayarlar ve Kullanılabilirlik

- Temel ekranlarda yükleniyor, veri yok ve hata durumları ele alınmalıdır.
- Kullanıcı ürünlerini, profilini, deneyimlerini ve analiz geçmişini yönetebilmelidir.
- Tema ve kodlama standartları `skills.md` ile uyumlu olmalıdır.

## 4. Geliştirme Aşamaları

### Aşama 1 — MVP

- Cilt profili oluşturma ve düzenleme
- Ürün kütüphanesi ve yerel veri saklama
- Elle/yapıştırarak içerik girişi ve OCR çıktısını doğrulama
- Ürün deneyimlerini kaydetme
- Kişiselleştirilmiş analiz, alerjen uyarıları ve analiz geçmişi
- Temel ayarlar ve hata/boş/yükleniyor durumları

### Aşama 2 — Günlük Kullanım

- Sabah/akşam rutinlerini yönetme
- İçerik kombinasyonları için sınırları açıkça belirtilmiş bilgilendirme uyarıları
- PAO ve biliniyorsa son kullanma tarihi takibi

### Aşama 3 — İyileştirme

- Kullanıcı deneyimi geçmişini görselleştirme
- Erişilebilirlik ve kullanılabilirlik iyileştirmeleri
- Testlerden ve kullanıcı geri bildirimlerinden çıkan yeni ihtiyaçlar

## 5. Başarı Kriterleri ve Doğrulama Testleri

MVP aşağıdaki koşullar sağlandığında temel olarak tamamlanmış kabul edilir:

| Başarı kriteri | Doğrulama / test |
|---|---|
| Kullanıcı profil oluşturup düzenleyebilir. | Profil kaydedilir; uygulama yeniden başlatıldığında güncel bilgiler korunur. |
| Kullanıcı ürün ekleyebilir ve yönetebilir. | Ekleme, düzenleme, silme ve arama akışları doğrulanır. |
| Temel veriler yerel olarak kalıcıdır. | Ürünler, profil ve deneyim kayıtları yeniden başlatma sonrasında korunur. |
| Başlangıç ürünleri güvenli yüklenir. | İlk yükleme ürünleri ekler; tekrar yükleme kopya oluşturmaz ve kullanıcı verisinin üzerine yazmaz. |
| OCR sonucu doğrulanabilir. | Kullanıcı OCR metnini düzenleyebilir; kaydedilen içerik düzeltilmiş değeri kullanır. |
| Bilinen alerjen eşleşmesi görünür. | Eşleşen içerik için belirgin uyarı gösterilir; olumlu ürün puanı bu uyarıyı kaldırmaz. |
| Analiz açıklanabilir ve veri yeterliliğini belirtir. | Eşleşen içerikler ve dayanakları gösterilir; yetersiz veri durumunda kesin sonuç iddia edilmez. |
| Rutin uyarıları kesin zararlılık iddiası oluşturmaz. | Belirsiz veya desteklenmeyen kombinasyonlar otomatik olarak zararlı ilan edilmez; uyarı sınırları belirtilir. |
| PAO ve son kullanma tarihi ayrı değerlendirilir. | Farklı tarih senaryoları, eksik tarihler ve erken dolan sürenin doğru gösterilmesi test edilir. |
| Hata ve boş durumları anlaşılırdır. | Veri yokluğu, okuma/kaydetme hatası ve yüklenme durumları için uygun arayüz gösterilir. |

## 6. Doküman Önceliği

- **`project.md`:** Ürün amacı, kullanıcı akışı, özellik kapsamı, aşamalar ve başarı kriterleri.
- **`agents/skills/skills.md`:** Teknik mimari, kodlama kuralları, algoritma ayrıntıları ve geliştirme standartları.
- Bir gereksinim teknik kurallarla çelişirse değişiklik yapılmadan önce ilgili belgeler birlikte gözden geçirilmelidir. Belgelerden biri değiştiğinde diğeri de gerekiyorsa güncellenmelidir.

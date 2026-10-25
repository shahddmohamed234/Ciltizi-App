---
name: ciltizi-project
description: ciltİzi uygulamasının ürün vizyonunu, kullanıcı akışını, özellik kapsamını ve başarı kriterlerini tanımlar.
---

# ciltİzi — Kişiselleştirilmiş Kozmetik İçerik ve Rutin Analizi

## 1. Proje Özeti

**ciltİzi**, kullanıcıların cilt profillerini, kozmetik ürünlerinin içeriklerini ve ürün kullanım deneyimlerini tek bir yerde takip etmelerini sağlayan Flutter tabanlı, öncelikle çevrimdışı çalışabilen bir mobil uygulamadır.

Uygulama; kullanıcının bildirdiği cilt özellikleri ve alerjenleri, ürünlerin INCI içerik listeleri ve kullanıcının zaman içinde kaydettiği deneyimleri birlikte değerlendirerek anlaşılır, gerekçeli bilgiler sunar. Amaç tıbbi teşhis koymak veya bir ürünün kesin olarak güvenli olduğunu iddia etmek değil; kullanıcının kendi kayıtlarını düzenlemesine ve ürünler hakkında daha bilinçli karar vermesine yardımcı olmaktır.

## 2. Temel İlkeler

- **Kullanıcı kontrolü:** OCR ile çıkarılan içerik listesi kullanıcı tarafından doğrulanmadan kesin veri kabul edilmez.
- **Alerjen önceliği:** Profilde kayıtlı bir alerjenle eşleşme varsa bu, uygunluk puanından ve önceki olumlu deneyimlerden önce gösterilir.
- **Açıklanabilirlik:** Analiz sonucu yalnızca bir puan göstermemeli; eşleşen içerikleri, kullanılan verileri ve uyarının nedenini de açıklamalıdır.
- **Veri yeterliliği:** Eksik veya belirsiz veri açıkça belirtilmelidir. Eksik bilgi, olumlu ya da olumsuz bir varsayımla doldurulmaz.
- **Yerel öncelikli çalışma:** Profil, ürün ve deneyim kayıtları cihazda saklanır; temel işlevler internet bağlantısı olmadan da kullanılabilir.
- **Mahremiyet:** Gereksiz kişisel veri toplanmaz. Hassas kullanıcı kayıtları açık bir gereklilik olmadan dış servislere gönderilmez.
- **Tutarlı görsel kimlik:** Rose & Plum renk paleti hem açık hem koyu temada korunur.
- **Tema seçeneği:** Kullanıcı Light, Dark veya System modunu seçebilir; varsayılan tercih cihaz temasını takip etmektir.
- **Tıbbi sınırlar:** Uygulama teşhis, tedavi veya kesin güvenlik garantisi sunmaz. Ciddi ya da devam eden cilt sorunlarında profesyonel sağlık desteği önerilir.

## 3. Hedef Kullanıcı ve Problem

Kullanıcılar ürün adlarını, içerik listelerini, kendi cilt özelliklerini ve önceki deneyimlerini farklı yerlerde tutabiliyor. Bu durum hangi ürünün hangi deneyimle ilişkili olduğunu takip etmeyi zorlaştırabiliyor.

ciltİzi şu ihtiyaçları tek akışta birleştirir:
- Kişisel cilt profilini ve kaçınılması gereken içerikleri kaydetmek.
- Kozmetik ürünleri ve INCI listelerini kaydetmek.
- Ürün kullanımıyla ilgili olumlu veya olumsuz deneyimleri tarihleriyle not etmek.
- Kayıtlı bilgilere dayalı, gerekçesi açıklanan içerik analizini görmek.
- İlerleyen aşamada sabah/akşam rutinlerini ve açıldıktan sonra kullanım süresini takip etmek.

## 4. Ana Kullanıcı Akışı

1. Kullanıcı profilini oluşturur veya düzenler.
2. Cilt tipi, hedefleri, bilinen alerjenleri ve kaçınmak istediği içerikleri kaydeder.
3. Bir ürünü ürün adıyla ve mümkünse INCI listesiyle ekler.
4. İsterse kamera veya galeriden içerik fotoğrafı seçer; OCR metin önerisi üretir.
5. Kullanıcı OCR sonucunu kontrol eder, yanlışları düzeltir ve onaylar.
6. Uygulama onaylanmış içerik listesini profil ve mevcut deneyim kayıtlarıyla karşılaştırır.
7. Sonuç ekranı eşleşmeleri, uyarı nedenlerini, veri yeterliliğini ve varsa uygunluk puanını açıklar.
8. Kullanıcı ürünle ilgili deneyimini kaydeder ve geçmişini daha sonra inceleyebilir.

## 5. Özellik Kapsamı

### 5.1 MVP — İlk Kullanılabilir Sürüm

- Profil oluşturma, görüntüleme ve düzenleme.
- Cilt tipi, cilt hedefleri, bilinen alerjenler ve kaçınılacak içeriklerin yönetimi.
- Ürün ekleme, görüntüleme, düzenleme ve silme.
- Ürün adı ve INCI listesini elle girme.
- OCR ile içerik metni önerme ve kullanıcıya doğrulatma.
- Ürün deneyimi/incelemesi ekleme, görüntüleme, düzenleme ve silme.
- Kayıtlı profil ve ürün verileri üzerinden içerik analizi.
- Alerjen eşleşmelerini uygunluk puanından önce gösterme.
- Analiz gerekçelerini ve veri yeterliliğini açıklama.
- Yerel kalıcılık, temel yükleniyor/boş/hata durumları ve başlangıç ürün verileri.

### 5.2 Aşama 2 — Günlük Kullanım

- Sabah ve akşam rutinleri oluşturma ve düzenleme.
- Ürünleri rutin adımlarına ekleme ve sıralama.
- Ürünün açıldığı tarihi ve PAO (Period After Opening / açıldıktan sonra kullanım süresi) bilgisini takip etme.
- Son kullanma tarihi ve PAO bilgisini ayrı alanlar olarak gösterme.
- Hatırlatmalar ve kullanım geçmişi için uygun temel altyapı.

### 5.3 Aşama 3 — İyileştirmeler

- Analiz ve deneyim geçmişinde daha gelişmiş filtreleme.
- Erişilebilirlik ve kullanılabilirlik iyileştirmeleri.
- Light, Dark ve System tema tercihlerinin kullanıcı ayarlarından yönetilmesi ve tercihin uygulama yeniden açıldığında korunması.
- Daha ayrıntılı istatistikler ve kişiselleştirilmiş özetler.
- Kullanıcı geri bildirimlerine göre yeni özellikler.

Aşamalar öncelik sırasını ifade eder; ekip kapasitesi ve gerçek uygulama durumu göz önünde bulundurularak planlanabilir.

## 6. İçerik Analizi Davranışı

Analiz, kullanıcının onayladığı INCI listesi ile profil verilerine dayanır.

1. Önce profil alerjenleri ve açıkça kaçınılacak içerikler kontrol edilir.
2. Eşleşme varsa kritik uyarı, uygunluk puanından önce gösterilir.
3. Diğer içerik sinyalleri ve kullanıcının kayıtlı deneyimleri ayrı gerekçeler olarak değerlendirilir.
4. Eksik INCI, belirsiz eşleştirme veya az sayıda deneyim varsa güven/veri yeterliliği düzeyi düşürülür ve bu durum açıklanır.
5. Puan gösteriliyorsa, bunun uygulamanın kayıtlı verilere dayalı bir gösterge olduğu; klinik veya tıbbi değerlendirme olmadığı belirtilir.
6. Aynı içerik birden fazla kategoride bulunuyorsa aynı nedenle iki kez ceza uygulanmaz.

Kullanıcı deneyimleri kişisel gözlemlerdir; tek başlarına bir bileşenin kesin olarak zararlı olduğunu kanıtlamaz. Özellikle olumsuz deneyimlere dayalı şüpheli içerik işaretleri, yeterli ve tekrarlanan kayıt olmadıkça kesin hüküm olarak sunulmamalıdır.

## 7. Rutin, PAO ve Son Kullanma Tarihi Kuralları

- Ürün içerik adlarından hareketle iki ürünün birlikte kesin olarak zararlı olduğu iddia edilmez. Rutin uyarıları gerekçeli, ihtiyatlı ve belirsizliği belirten ifadeler kullanır.
- PAO, ürün açıldıktan sonra önerilen kullanım süresini; son kullanma tarihi ise ürün üzerinde belirtilen takvim tarihini temsil eder. Bunlar birbirinin yerine kullanılmaz.
- PAO uyarısı için açılma tarihi ve PAO süresi; son kullanma tarihi uyarısı için de gerçek tarih bilgisi gerekir.
- İki bilgi de mevcutsa her biri ayrı değerlendirilir ve kullanıcıya hangi bilginin hangi uyarıyı oluşturduğu açıklanır.
- Bilinmeyen tarih, açılma zamanı veya PAO süresi tahmin edilmez.
- Tarihin geçmiş olması tek başına ürünün kesin olarak zararlı olduğunu kanıtlamaz; uygulama bunu tarih temelli bir dikkat uyarısı olarak ifade eder.

## 8. Veri ve Mahremiyet

- Temel profil, ürün ve deneyim verileri cihazda saklanır.
- Uygulama başlangıç verileri kullanıcı verilerini ezmemeli veya çoğaltmamalıdır.
- OCR için seçilen görseller yalnızca gerekli işlem amacıyla kullanılır; uygulama açıkça tasarlanmamışsa dış servise gönderim yapılmaz.
- Kullanıcı verisi silindiğinde ilgili kayıtların ve ilişkilerin tutarlı biçimde ele alınması gerekir.
- Yedekleme veya bulut senkronizasyonu MVP kapsamında varsayılmaz.

## 9. Başarı Kriterleri ve Doğrulama

| Alan | Başarı ölçütü | Doğrulama |
|---|---|---|
| Profil | Kullanıcı profilini oluşturabilir ve güncelleyebilir. | Profil birim/widget testi |
| Ürünler | Ürün ekleme, düzenleme ve silme çalışır. | CRUD testleri |
| Kalıcılık | Uygulama yeniden açıldığında kayıtlar korunur. | Kalıcılık testi |
| Başlangıç verisi | Seed verisi tekrar çalıştırıldığında kullanıcı verisini ezmez ve yinelenen kayıt oluşturmaz. | Seed/idempotency testi |
| OCR | Çıkarılan metin kullanıcı onayı olmadan kesin içerik listesi sayılmaz; ham OCR metni korunabilir. | OCR akışı testi |
| Alerjen | Alerjen eşleşmesi puandan önce kritik uyarı olarak görünür. | Analiz birim testi |
| Açıklama | Analiz, eşleşen içerikleri ve gerekçeleri gösterir. | Birim/widget testi |
| Veri yeterliliği | Eksik veri veya az sayıda deneyim varsa bu açıkça belirtilir. | Analiz testleri |
| Rutin | İçerik adlarından tek başına kesin zararlı kombinasyon hükmü çıkarılmaz. | Rutin analiz testleri |
| PAO/tarih | PAO ve son kullanma tarihi ayrı değerlendirilir; eksik tarih uydurulmaz. | Tarih mantığı testleri |
| Arayüz durumları | Yükleniyor, dolu, boş ve hata durumları ele alınır. | Widget testleri |
| Tema | Light ve Dark temalar tutarlı görünür; System tercihi cihaz temasını izler ve kullanıcı tercihi korunur. | Tema ve ayar testleri |
| Çevrimdışı kullanım | Temel kayıt ve görüntüleme akışları ağ olmadan çalışır. | Entegrasyon testi |

## 10. Dokümantasyon Sorumluluğu

- Bu `project.md`, ürün vizyonu, kapsam, kullanıcı akışları ve başarı kriterleri için ana kaynaktır.
- `skills.md`, mimari ve kodlama kurallarının teknik kaynağıdır.
- İki belge arasında çelişki oluşursa geliştirmeye başlamadan önce karar netleştirilir ve her iki dosya birlikte güncellenir.

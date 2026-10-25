ciltİzi — Kişiselleştirilmiş İçerik ve Rutin Analizi

Bu dosya ciltİzi uygulamasının amacını, ürün kapsamını ve geliştirme önceliklerini tanımlar. Mimari, paketler, veri modelleri, algoritmalar, tema, güvenlik, test ve AI Agent çalışma kurallarında SKILL.md bağlayıcıdır. Bu dosya teknik kuralları tekrarlamaz veya değiştirmez.

1. Proje Amacı

ciltİzi, kullanıcıların kozmetik ürün deneyimlerini INCI içerikleriyle ilişkilendirerek kişiye özel, açıklanabilir ürün değerlendirmeleri sunan, temel özellikleri çevrimdışı çalışan bir Flutter uygulamasıdır.

Amaç, bir bileşeni kesin güvenli ya da zararlı ilan etmek değil; kullanıcının kayıtlarından olası uyum ve hassasiyet örüntülerini görünür kılmaktır. Uygulama tıbbi teşhis veya tedavi önerisi sunmaz.

2. Temel Kullanıcı Akışı

1. Kullanıcı cilt tipini, cilt sorunlarını, bilinen alerjenlerini ve kaçınmak istediği bileşenleri kaydeder.
2. Ürününü adı, markası, kategorisi ve INCI listesiyle kütüphanesine ekler. İçerikler manuel giriş, yapıştırma veya OCR ile alınabilir; OCR çıktısı kullanıcı tarafından doğrulanır.
3. Kullandığı ürünün etkilerini, puanını, kullanım süresini ve notlarını kaydeder.
4. Sistem olumlu ve olumsuz ürün deneyimlerini karşılaştırarak olası şüpheli bileşenleri ve kişisel örüntüleri belirler.
5. Yeni bir ürün için eşleşmeler, alerjen uyarıları, veri yeterliliği ve gerekçeli kişisel uygunluk sonucu sunulur.
6. Kullanıcı geçmiş deneyimlerini ve analizlerini inceleyebilir, düzenleyebilir veya silebilir.

3. Ürün Modülleri

3.1. Cilt Profili

Cilt tipi, cilt sorunları, bilinen alerjenler ve kaçınılan bileşenler birbirinden ayrı yönetilir. Profil sonradan düzenlenebilir.

3.2. Ürün Kütüphanesi

Ürün ekleme, arama, filtreleme, detay görüntüleme, düzenleme ve silme desteklenir. Doğrulanmış başlangıç ürünleri yerel ürün kataloğundan eklenebilir.

3.3. Kullanıcı Deneyimleri

Kullanıcı her ürün için puan, olumlu/olumsuz etkiler, kullanım süresi, tarih ve serbest not tutabilir. Geçmiş kayıtlar kişisel içerik analizine veri sağlar.

3.4. Kişiselleştirilmiş Analiz

Sistem ürünlerin içeriklerini kullanıcının kayıtlarıyla karşılaştırır; bilinen alerjenleri öncelikli olarak gösterir, şüpheli içerik adaylarını ve olumlu deneyim örüntülerini açıklar. Uygunluk skoru yalnızca kişisel değerlendirme göstergesidir; tıbbi risk veya alerji olasılığı değildir. Veriler yetersizse bu durum açıkça belirtilir. Ayrıntılı eşleştirme, skorlama ve kanıt kuralları SKILL.md içindedir.

3.5. Sabah/Akşam Rutinleri — İkinci Aşama

Kullanıcı kütüphanesindeki ürünleri sabah ve akşam rutinlerine atayabilir, sıralayabilir ve rutinlerini düzenleyebilir. Birlikte kullanım konusunda yalnızca koşulları açık, ihtiyatlı bilgilendirmeler gösterilir; içerik çiftleri otomatik olarak kesin zararlı sayılmaz.

3.6. PAO / Ürün Açıldıktan Sonra Kullanım Süresi — İkinci Aşama

Kullanıcı ürünün açılış tarihini, ambalajdaki PAO süresini (ör. 6M, 12M) ve varsa son kullanma tarihini kaydedebilir. Süre yaklaşınca veya dolunca hatırlatma gösterilir; sürenin dolması tek başına ürünün zararlı olduğunu kanıtlayan bir ifade olarak sunulmaz.

3.7. Ayarlar ve Erişilebilirlik

Türkçe ve İngilizce dil desteği, açık/koyu tema, anlaşılır boş-yükleniyor-hata durumları ve kullanıcı verilerini yönetme seçenekleri sunulur. Tema ayrıntıları SKILL.md tarafından belirlenir.

4. Geliştirme Öncelikleri

Aşama 1 — Temel sürüm (MVP): Cilt profili, ürün kütüphanesi, INCI girişi/OCR, kullanıcı deneyimleri, kişiselleştirilmiş analiz, analiz geçmişi ve ayarlar.

Aşama 2 — Günlük kullanım: Sabah/akşam rutinleri, PAO takibi ve koşullu birlikte kullanım bilgilendirmeleri.

Aşama 3 — İyileştirme: Deneyim geçmişinin daha anlaşılır görselleştirilmesi, erişilebilirlik ve kullanılabilirlik iyileştirmeleri; ihtiyaç doğrulanırsa yeni modüller.

5. Başarı Ölçütleri

* Kullanıcı profil oluşturup ürün ekleyebilmeli, deneyim kaydedebilmeli ve kişiselleştirilmiş analiz sonucunu görüntüleyebilmelidir.
* Analiz sonucu eşleşen bileşenleri, uyarıları ve verinin yeterliliğini açıklamalıdır.
* Temel akışlar internet bağlantısı olmadan çalışmalı; kayıtlar uygulama yeniden açıldığında korunmalıdır.
* Kullanıcı kendi ürünlerini, deneyimlerini ve geçmiş kayıtlarını yönetebilmelidir.
* Yeni özellikler mevcut kullanıcı verilerini ve çalışan işlevleri bozmadan geliştirilebilmelidir.

6. Belge Önceliği

PROJECT.md ürün hedeflerini ve kapsamını, SKILL.md ise uygulama ve mühendislik kurallarını tanımlar. Teknik kararlar konusunda çelişki oluşursa SKILL.md esas alınır; yeni bir gereksinim bu kurallarla çelişiyorsa önce belgeler bilinçli olarak birlikte güncellenir.

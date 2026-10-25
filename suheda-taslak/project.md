# ciltİzi — Kişiselleştirilmiş İçerik ve Rutin Analizi

Bu dosya ciltİzi uygulamasının **amacını, ürün kapsamını ve geliştirme önceliklerini** tanımlar. Mimari, paketler, veri modelleri, algoritmalar, tema, güvenlik, test ve AI Agent çalışma kurallarında **`SKILL.md` bağlayıcıdır**. Bu dosya teknik kuralları tekrarlamaz veya değiştirmez.

## 1. Proje Amacı

ciltİzi, kullanıcıların kozmetik ürün deneyimlerini INCI içerikleriyle ilişkilendirerek kişiye özel, açıklanabilir ürün değerlendirmeleri sunan, temel özellikleri çevrimdışı çalışan bir Flutter uygulamasıdır.

Amaç, bir bileşeni kesin güvenli ya da zararlı ilan etmek değil; kullanıcının kayıtlarından olası uyum ve hassasiyet örüntülerini görünür kılmaktır. Uygulama tıbbi teşhis veya tedavi önerisi sunmaz.

## 2. Temel Kullanıcı Akışı

1. Kullanıcı cilt tipini, cilt sorunlarını, bilinen alerjenlerini ve kaçınmak istediği bileşenleri kaydeder.
2. Ürününü adı, markası, kategorisi ve INCI listesiyle kütüphanesine ekler. İçerikler manuel giriş, yapıştırma veya OCR ile alınabilir; OCR çıktısı kullanıcı tarafından doğrulanır.
3. Kullandığı ürünün etkilerini, puanını, kullanım süresini ve notlarını kaydeder.
4. Sistem olumlu ve olumsuz ürün deneyimlerini karşılaştırarak olası şüpheli bileşenleri ve kişisel örüntüleri belirler.
5. Yeni bir ürün için eşleşmeler, alerjen uyarıları, veri yeterliliği ve gerekçeli kişisel uygunluk sonucu sunulur.
6. Kullanıcı geçmiş deneyimlerini ve analizlerini inceleyebilir, düzenleyebilir veya silebilir.

## 3. Ürün Modülleri

### 3.1. Cilt Profili

Cilt tipi, cilt sorunları, bilinen alerjenler ve kaçınılan bileşenler birbirinden ayrı yönetilir. Profil sonradan düzenlenebilir.

### 3.2. Ürün Kütüphanesi

Ürün ekleme, arama, filtreleme, detay görüntüleme, düzenleme ve silme desteklenir. Doğrulanmış başlangıç ürünleri yerel ürün kataloğundan eklenebilir.

### 3.3. Kullanıcı Den

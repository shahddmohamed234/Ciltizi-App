---
name: ciltizi-core-architecture
description: >-
  ciltİzi Flutter projesi için BLoC tabanlı durum yönetimi, Hive yerel veritabanı, 
  Clean Architecture standartları ve genişletilmiş rutin takip özelliklerini içeren proje kılavuzu.
---

# ciltİzi — Gelişmiş İçerik & Rutin Analizi (Alternatif Taslak)

Bu doküman, **ciltİzi** projesinin yapısal bütünlüğünü sağlamak için Clean Architecture prensiplerini merkeze alan, gelişmiş durum yönetimi (BLoC) ve Hive veritabanı kullanan bağlayıcı bir proje planıdır.

---

## 1. Proje Özeti ve Teknik Altyapı

- **Uygulama Adı:** ciltİzi
- **Mimari:** Clean Architecture (Domain, Data, Presentation)
- **Durum Yönetimi:** `flutter_bloc` (Cubit ve BLoC)
- **Veritabanı:** `hive` & `hive_flutter` (Proje gereksinimlerine uygun olarak sunucusuz, tamamen yerel saklama)
- **Tasarım Dili & Tema:** Özelleştirilmiş Material 3. Ana renk paleti **Bordo (Burgundy) ve Pembe** tonlarından oluşacaktır.
- **Dil:** Türkçe (Uygulama içi varsayılan).
- **Ekstra Modüller:** OCR (Google ML Kit) ve PAO (Kapak Açıldıktan Sonraki Ömür) takibi.

---

## 2. Genişletilmiş Özellik Seti (MVP+)

### 2.1. Cilt Profili ve Hive Entegrasyonu
- Cilt tipi ve uzak durulması gereken içerikler (alerjenler) Hive üzerindeki `skin_profile_box` kutusunda tutulur.
- İlk veri yüklemesi `assets/products.json` üzerinden yapılarak başlangıç kütüphanesi oluşturulur.

### 2.2. Ürün & PAO (Son Kullanma) Takibi
- Kullanıcı ürünü okutup kütüphaneye eklerken kapağını açtığı tarihi ve ürünün PAO (Period After Opening - Örn: 6M, 12M) süresini girer.
- **Farkımız:** Sistem sadece içerik analizi yapmakla kalmaz, tarihi geçen ürünler için "Bu ürünün ömrü doldu, cildinde hassasiyet yapabilir" uyarısı verir.

### 2.3. Sabah / Akşam Rutin Yöneticisi
- Ürünler kütüphanede boş durmaz; "Sabah Rutini" ve "Akşam Rutini" olarak listelere atanır.
- Çakışan içerik uyarısı: Kullanıcı aynı rutine hem C Vitamini hem de AHA/BHA asit eklerse sistem anlık olarak "Bu iki aktif içeriği aynı anda kullanmak tahrişe yol açabilir" uyarısı fırlatır.

### 2.4. BLoC Destekli Analiz Algoritması
- Yeni bir ürün eklendiğinde `AnalysisBloc` tetiklenir.
- Ürün INCI listesi ayrıştırılır (`string.split(',')` işlemi `utils` katmanında yapılır).
- **Filtreleme:** `if/else` bloklarıyla güvenli içerik, şüpheli içerik ve alerjen eşleşmeleri Hive veritabanındaki geçmiş verilerle karşılaştırılarak yapılır.
- Skorlama sonucu `AnalysisState` üzerinden UI katmanına yansıtılır.

---

## 3. Klasör ve Mimari Yapısı (Clean Architecture)

```text
lib/
├── core/
│   ├── constants/       # Bordo ve Pembe renk paleti, asset yolları
│   ├── error/           # Exception ve Failure sınıfları
│   └── utils/           # string.split(',') ve diğer temizleme araçları
├── features/
│   ├── skin_profile/
│   │   ├── domain/      # Entity'ler, Repository Interfaceleri
│   │   ├── data/        # Hive TypeAdapter Modelleri, Local DataSource
│   │   └── presentation/# Bloc/Cubit sınıfları, UI sayfaları
│   ├── product_analysis/
│   └── routine_tracker/ # Sabah/Akşam rutin listesi ve PAO takibi
└── main.dart            # Uygulama başlangıcı ve Hive init işlemleri
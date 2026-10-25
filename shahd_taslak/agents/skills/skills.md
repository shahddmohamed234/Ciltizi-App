## Proje İçin Gereken Yetenekler ve Teknolojiler
Bu projenin MVP (Minimum Viable Product) aşamasını başarılı bir şekilde tamamlamak için ekip üyelerinin odaklanması ve geliştirmesi gereken temel yetkinlikler şunlardır:

```markdown
# ciltİzi — AI ve Geliştirici Kodlama Kuralları (BLoC & Hive)

Bu dosya, projedeki geliştirme standartlarını ve AI asistanlarının kod üretirken uyması gereken kesin kuralları içerir.

## 1. Mimari ve Durum Yönetimi (State Management)
- **BLoC Kullanımı:** Tüm durum yönetimi işlemleri için `flutter_bloc` paketi kullanılacaktır.
- Basit durumlar için `Cubit`, karmaşık ve birbirini tetikleyen olaylar (örneğin OCR okuma sonrası analize geçiş) için `Bloc` tercih edilecektir.
- UI (Arayüz) katmanında iş mantığı (business logic) barındırmak KESİNLİKLE YASAKTIR. İş mantığı Domain katmanında olmalıdır.

## 2. Kodlama Stili ve Kontrol Yapıları
- **if/else Kullanımı:** Koşullu ifadelerde (özellikle karmaşık UI dönüşlerinde ve widget render işlemlerinde) kısa ternary operatörleri (`? :`) yerine okunabilirliği artırmak için açık `if / else if / else` yapıları kullanılacaktır.
- **Değişken İsimlendirmeleri:** Anlamlı, İngilizce ve `camelCase` isimlendirme standartlarına uyulacaktır.
- SOLID prensiplerine tam uyum sağlanacaktır.

## 3. UI, Tema ve Tasarım Kuralları
- **Inline Style Yasağı:** Flutter tarafında widget'lara direkt sabit renk veya padding vermek yerine (Örn: `Colors.red`), `Theme.of(context)` üzerinden global tema değerleri çekilecek ve Class tabanlı yapılar kullanılacaktır.
- **Renk Paleti:** Uygulamanın ana teması **Bordo ve Pembe** tonlarıdır. Yeşil veya standart mavi temalar kesinlikle kullanılmamalıdır.
- Tema tanımlamaları `lib/core/constants/app_theme.dart` dosyasında `ThemeData` kullanılarak yapılmalıdır.

## 4. Veritabanı ve Performans (Hive)
- Veritabanı olarak **Hive** kullanılacaktır. Tüm veri modelleri (Ürünler, Profiller, Deneyim Notları) `Hive TypeAdapter` kullanılarak oluşturulmalıdır.
- Başlangıç verileri ilk açılışta `assets/products.json` dosyasından okunup Hive kutularına (`boxes`) yazılacaktır.
- Hive işlemleri hızlı olsa da, Bloc/Cubit içerisinde asenkron (`Future`) olarak yönetilmeli ve UI tarafında `BlocBuilder` ile durum (loading/loaded) kontrolleri yapılmalıdır.

## 5. Algoritma Önceliği
- İçerik eşleştirme algoritmasında, kullanıcı profilindeki *Alerjenler* her şeyden önce değerlendirilmeli ve eğer eşleşme varsa "Uygunluk Skoru" hesaplanmadan önce doğrudan "KRİTİK UYARI" fırlatılmalıdır.
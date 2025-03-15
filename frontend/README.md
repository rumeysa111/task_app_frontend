📱 **Task App - Frontend**

Bu proje, **Flutter** ile geliştirilmiştir.
**Node.js tabanlı backend API** ile entegre çalışır ve **çevrimdışı kullanım desteği** sunar.


---


## 🛠️ Kullanılan Teknolojiler
| **Teknoloji** | **Açıklama** |
|--------------|-------------|
| **Flutter** | UI framework |
| **Dart** | Programlama dili |
| **BLoC / Cubit** | Durum yönetimi |
| **SQLite** | Yerel veritabanı |
| **PostgreSQL** | Uzaktan veri depolama |
| **REST API** | Backend iletişimi |
| **HTTP** | API iletişimi |
| **Connectivity Plus** | Bağlantı durumu takibi |
| **Intl** | Tarih/saat formatlaması |
| **Flex Color Picker** | Görev renk seçimi |
| **UUID** | Benzersiz tanımlayıcılar |

---
## 📁 Proje Yapısı
```
lib/
├── core/
│   ├── constans/
│   │   ├── constans.dart         # API URL ve diğer sabitler
│   │   └── utils.dart            # Yardımcı fonksiyonlar
│   └── services/
├── features/
│   ├── auth/
│   │   ├── cubit/
│   │   │   ├── auth_cubit.dart   # Kimlik doğrulama durumu
│   │   │   └── auth_state.dart   # Auth durum sınıfları
│   │   ├── pages/
│   │   │   ├── login_page.dart   # Giriş sayfası
│   │   │   └── signup_page.dart  # Kayıt sayfası
│   │   └── repository/
│   └── home/
│       ├── cubit/
│       │   ├── task_cubit.dart   # Görev işlemleri durumu
│       │   └── task_state.dart   # Görev durum sınıfları
│       ├── pages/
│       │   ├── home_page.dart    # Ana sayfa
│       │   └── add_new_task_page.dart # Görev ekleme sayfası
│       ├── widgets/
│       │   ├── task_card.dart    # Görev kartı bileşeni
│       │   └── date_selector.dart # Tarih seçici
│       └── repository/
│           ├── task_remote_repository.dart # API görev işlemleri
│           └── task_local_repository.dart  # SQLite görev işlemleri
├── models/
│   ├── task_model.dart           # Görev veri modeli
│   └── user_model.dart           # Kullanıcı veri modeli
└── main.dart                     # Uygulama girişi
```

---

## 🔗 Backend Entegrasyonu
Uygulama Node.js/Express/TypeScript backend API'si ile iletişim kurar. API entegrasyonu şu şekilde yapılandırılmıştır:
```dart
// API endpoint sabitleri
class Constants {
  static const String backendUri = "https://your-backend-url.com";
}
```
### 📡 API İletişim Akışı

#### 🧑‍💼 Kullanıcı İşlemleri:
| **Endpoint** | **Metod** | **Açıklama** |
|-------------|----------|-------------|
| `/auth/signup` | `POST` | Yeni kullanıcı kaydı |
| `/auth/login` | `POST` | Kullanıcı girişi |
| `/auth/token` | `GET` | Token doğrulama |

#### ✅ Görev İşlemleri:
| **Endpoint** | **Metod** | **Açıklama** |
|-------------|----------|-------------|
| `/tasks` | `GET` | Görevleri listele |
| `/tasks` | `POST` | Yeni görev oluştur |
| `/tasks` | `DELETE` | Görev sil |
| `/tasks/sync` | `POST` | Çevrimdışı görevleri senkronize et |

---

### 📡 Backend Bağımsız Repo Yapısı
Backend artık ayrı bir repoda bulunduğu için aşağıdaki adımlarla çalıştırabilirsiniz:

1. Backend reposunu klonlayın:
   ```sh
   git clone https://github.com/rumeysa111/task_app_backend.git
   cd task_app_backend
   ```
2. Bağımlılıkları yükleyin:
   ```sh
   npm install
   ```
3. Docker ile başlatın:
   ```sh
   docker-compose up --build
   ```
4. Backend çalışır hale geldikten sonra Flutter uygulamasıyla entegre edin.


### 📌 Adımlar
1. Projeyi klonlayın:
   ```sh
   git clone https://github.com/rumeysa111/task_app.git
   cd frontend
   ```
2. Bağımlılıkları yükleyin:
   ```sh
   flutter pub get
   ```
3. Uygulamayı başlatın:
   ```sh
   flutter run
   ```


---

## 📱 Ekran Görüntüleri
<div align="center">  
  <img src="assets/images/Screenshot_1737739375.png" alt="Giriş Ekranı" width="300">  
  <img src="assets/images/Screenshot_1737739500.png" alt="Görev Listesi" width="300">  
  <img src="assets/images/Screenshot_1737739570.png" alt="Görev Ekleme" width="300">  
  <img src="assets/images/Screenshot_1737739606.png" alt="Görev Detayları" width="300">  
</div>  

---

## 🔌 Çevrimdışı Çalışma Mekanizması
1️⃣ **Bağlantı Tespiti:** `connectivity_plus` paketi ile internet bağlantısı izlenir.  
2️⃣ **Yerel Depolama:** İnternet yokken görevler **SQLite** veritabanına kaydedilir.  
3️⃣ **Senkronizasyon:** İnternet bağlantısı tekrar sağlandığında veriler backend'e aktarılır.  

---

## 🔐 Güvenlik
✅ **JWT ile kimlik doğrulama**  
✅ **Güvenli token saklama**  
✅ **API isteklerinde token ile yetkilendirme**  

---


# 🎮 Game News
 
Aplikasi Flutter untuk membaca berita seputar game dari media Indonesia. Data diambil dari [GNews API](https://gnews.io) memakai **dio**, ditampilkan dengan **FutureBuilder**, dan setiap kegagalan jaringan ditangani dengan pesan yang jelas lewat `ApiException`.
 
Dibuat untuk tugas mata kuliah **Pemrograman Mobile (Flutter)** — topik: konsumsi REST API, FutureBuilder, dan error handling.
 
## ✨ Fitur
 
- Daftar berita game dengan gambar, judul, ringkasan, nama media, dan tanggal (format Indonesia)
- Chip topik: Semua, Esports, Mobile, PC, Konsol, Rilis Baru, Industri (bisa digeser dengan tombol panah)
- Pencarian kata kunci (otomatis digabung dengan kata `game`)
- Halaman detail berita + tombol salin link
- Pull-to-refresh
- Empat state tampilan: **loading**, **error**, **kosong**, **data**
- Tombol **Coba Lagi** saat error
- Berjalan di Android dan Flutter Web
## 🧰 Teknologi
 
| Paket | Fungsi |
|---|---|
| `dio` | HTTP client (timeout, interceptor log, jenis error terpilah) |
| `get` | Routing / navigasi dan controller halaman detail |
| `cached_network_image` | Cache gambar berita |
| `intl` | Format tanggal Indonesia (`id_ID`) |
 
Butuh **Flutter 3.29+** (memakai `WebHtmlElementStrategy` untuk gambar di web).
 
## 📁 Struktur Folder
 
```
news_app/
├── config/
│   ├── env.example.json        # template (di-commit)
│   ├── env.json                # URL & API key development (.gitignore)
│   ├── env.prod.example.json   # template URL proxy
│   └── env.prod.json           # URL proxy production (.gitignore)
├── proxy-gnews/                # Cloudflare Worker penyimpan API key
└── lib/
    ├── main.dart
    ├── config/env.dart         # baca URL & API key, samarkan key di log
    ├── models/                 # ArticleModel, NewsResponseModel
    ├── services/               # ApiException, NewsApiService
    ├── views/                  # home, search, detail
    ├── widgets/                # ArticleCard, ErrorView, NewsImage
    ├── controllers/            # DetailController
    ├── routes/                 # app_pages, app_routes
    └── utils/                  # app_colors, date_formatter, game_topics
```
 
## 🚀 Menjalankan Project
 
### 1. Prasyarat
- Flutter SDK 3.29 atau lebih baru
- API key GNews gratis: daftar di [gnews.io](https://gnews.io), lalu **verifikasi email** (tanpa verifikasi request ditolak dengan 403)
### 2. Setup
 
```bash
git clone <URL-REPO-KAMU>
cd news_app
 
# Buat folder platform (android/ios/web) bila belum ada
flutter create . --project-name news_app
 
flutter pub get
```
 
### 3. Isi konfigurasi
 
Salin template, lalu isi API key milikmu:
 
```bash
cp config/env.example.json config/env.json        # Windows: copy config\env.example.json config\env.json
```
 
```json
{
  "GNEWS_BASE_URL": "https://gnews.io/api/v4",
  "GNEWS_API_KEY": "ISI_API_KEY_ANDA"
}
```
 
> `config/env.json` sudah masuk `.gitignore`. **Jangan pernah commit API key.**
 
### 4. Jalankan
 
```bash
flutter run --dart-define-from-file=config/env.json
# Browser:
flutter run -d chrome --dart-define-from-file=config/env.json
```
 
Di VS Code, `.vscode/launch.json` sudah menyertakan flag tersebut, jadi tombol **Run** langsung bisa dipakai.
 
### 5. Android release
Tambahkan izin internet di `android/app/src/main/AndroidManifest.xml`, di atas tag `<application>`:
 
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```
 
## 🧯 Skenario Error
 
Setiap kegagalan menghasilkan pesan berbeda di layar:
 
| Skenario | Cara memicu | Pesan |
|---|---|---|
| Konfigurasi kosong | Kosongkan `GNEWS_BASE_URL` | Konfigurasi belum diisi… |
| API key tidak terdaftar | Key 32 karakter acak | API key salah atau tidak terdaftar. |
| Format key salah | `GNEWS_API_KEY` = `salah123` | Permintaan tidak valid. *(pesan server)* |
| Terlalu cepat | Ganti chip berkali-kali dengan cepat | Terlalu cepat. Paket gratis hanya 1 request per detik. |
| Kuota habis / email belum diverifikasi | Akun baru belum verifikasi | Kuota harian habis atau email akun belum diverifikasi. |
| Endpoint salah | Ubah path request | Alamat endpoint tidak ditemukan. |
| Tidak ada internet | Mode pesawat | Tidak ada koneksi internet. Periksa jaringan Anda. |
| Server lambat | `receiveTimeout` diperkecil | Koneksi lambat. Server tidak merespons tepat waktu. |
| JSON tidak cocok model | Ubah tipe field di model | Struktur data dari server berbeda dari model. |
 
Untuk debugging, `LogInterceptor` mencetak setiap request/response ke Debug Console (hanya mode debug, API key disamarkan menjadi `***`).
 
## ⚠️ Batasan Paket Gratis GNews
 
- 100 request per hari, maksimal 10 artikel per request, maksimal 1 request per detik
- Isi artikel (`content`) dipotong 250 karakter, jadi halaman detail hanya cuplikan
- Berita tertunda sekitar 12 jam (bukan real time)
- Topik game memakai pencarian kata kunci (`/search`), jadi hasil bisa kurang presisi dibanding kategori bawaan
## 🔐 Production: Menjaga API Key Tetap Aman
 
Nilai dari `--dart-define-from-file` **ikut terkompilasi ke APK** dan bisa diambil dengan perintah `strings`. Untuk production, gunakan proxy di folder `proxy-gnews/` (Cloudflare Worker) agar API key hanya ada di server.
 
```
Aplikasi Flutter  →  Proxy Cloudflare Worker  →  GNews API
 (tanpa API key)      (key = secret server,       (menerima apikey
                       whitelist, cache 10 mnt)    dari proxy saja)
```
 
```bash
cd proxy-gnews
npx wrangler login
npx wrangler secret put GNEWS_API_KEY   # tempel key di prompt
npx wrangler deploy                     # mencetak URL proxy
```
 
Isi `config/env.prod.json` dengan URL proxy (tanpa key), lalu build:
 
```bash
flutter build apk --release --obfuscate --split-debug-info=build/debug-info \
  --dart-define-from-file=config/env.prod.json
```
 
Simpan `build/debug-info` di tempat aman dan jangan di-commit. Untuk memastikan key tidak ada di APK:
 
```bash
unzip -o build/app/outputs/flutter-apk/app-release.apk -d apk_cek
strings apk_cek/lib/arm64-v8a/libapp.so | grep -i "gnews\|apikey"
```
 
Pada Flutter Web, ganti `Access-Control-Allow-Origin: *` di `proxy-gnews/src/index.js` dengan domain webmu.

License: CaggyID
(c) 2026 CaggyID

# Katalog assets Caggy

Dipakai HANYA kalau pengguna menjawab tidak punya assets (atau hanya sebagian). Kalau pengguna punya assets sendiri, assets mereka selalu didahulukan.

## Cara memilih

1. Cocokkan industri proyek dengan kategori di bawah. Kalau tidak ada yang cocok, pakai kategori `background` saja plus UI tanpa ilustrasi.
2. Ambil 1 sampai 3 file, bukan semuanya. Satu section satu visual dominan.
3. Salin file yang dipilih ke `public/assets/` proyek dan tulis path-nya di setiap prompt yang memakainya.
4. Baca kolom Catatan. Beberapa file punya cacat (watermark, salah eja, kotak-kotak tertanam) yang harus ditangani sebelum dipakai.

## Batas teknis (berlaku untuk semua file)

- Semua file JPG. Tidak ada transparansi asli. File berlatar putih paling aman di atas permukaan terang; di atas permukaan berwarna, pakai `mix-blend-multiply` hanya kalau latarnya benar-benar putih.
- Lebar maksimum 736 px (satu file 980 px). Jangan ditampilkan lebih lebar dari ukuran aslinya; untuk bleed layar penuh, pakai hanya sebagai tekstur di section pendek atau minta pengguna menyediakan versi resolusi tinggi.
- Lembar ikon (`icon-sheet`) harus di-crop per ikon sebelum dipakai. Jangan tampilkan lembar utuh sebagai gambar section.
- Ilustrasi ini adalah gambar pendukung, bukan sistem ikon UI. Ikon UI tetap satu library monokrom (lihat design-rules).
- Aturan desain "screenshot produk asli lebih baik daripada ilustrasi" tetap berlaku: kalau proyek sudah punya tampilan UI nyata, pakai itu untuk visual utama dan pakai assets ini sebagai pendukung.

## Catatan asal-usul

Beberapa nama file asli dan watermark (misalnya "Pikbest", "Iconora Studio", "Free Download") menandakan gambar mungkin berasal dari pihak ketiga. Pemilik repo perlu memastikan hak pakainya sebelum dipakai di produk komersial. Lisensi CaggyID pada skill ini tidak otomatis mencakup hak atas gambar pihak ketiga.


## background

| File | Jenis | Ukuran | Latar | Catatan |
|---|---|---|---|---|
| `assets/caggy/background/bg-medical-cross-blue.jpg` | background | 736x461 | biru muda | Biru muda dengan bentuk plus/cross medis samar. Cocok: rumah sakit, klinik, kesehatan. |
| `assets/caggy/background/bg-wave-white.jpg` | background | 700x350 | putih-abu | Gelombang putih-abu netral. Aman untuk semua industri sebagai dasar section terang. |
| `assets/caggy/background/bg-silver-light.jpg` | background | 735x490 | biru-perak | Garis cahaya biru-perak, mood dingin dan cerah. Cocok: hosting, bisnis, teknologi. |
| `assets/caggy/background/bg-dark-silk.jpg` | background | 735x412 | hitam | Gelombang sutra hitam. Cocok: fashion, trading, editing, mode gelap. |
| `assets/caggy/background/bg-dark-lines.jpg` | background | 735x475 | hitam | Hitam dengan garis cahaya putih. Cocok: developer, hosting, trading, mode gelap. |

## delivery

Saran awal arah desain (boleh diganti): hue brand #C2321F (merah, selaras dengan scooter dan pin); font display Cabinet Grotesk.

| File | Jenis | Ukuran | Latar | Catatan |
|---|---|---|---|---|
| `assets/caggy/delivery/delivery-3d-vehicles-sheet.jpg` | icon-sheet | 736x1376 | krem | Lembar ikon 3D kendaraan oranye (mobil, motor, truk, drone, forklift) di latar krem. Perlu di-crop per ikon. |
| `assets/caggy/delivery/delivery-courier-scooter.jpg` | hero-illustration | 736x736 | putih | Scooter merah keluar dari layar ponsel membawa paket. Cocok jadi visual utama satu section. |
| `assets/caggy/delivery/delivery-location-pin-parcel.jpg` | hero-illustration | 736x736 | putih | Pin lokasi merah dengan tangan menyerahkan paket. Cocok: pelacakan, alamat, area layanan. |

## development

Saran awal arah desain (boleh diganti): hue brand #C2570C (oranye, selaras dengan ikon 3D); font display Bricolage Grotesque.

| File | Jenis | Ukuran | Latar | Catatan |
|---|---|---|---|---|
| `assets/caggy/development/dev-3d-icon-sheet.jpg` | icon-sheet | 736x943 | putih | Lembar ikon 3D hitam-oranye (kode, browser www, folder, HTML, loading). Perlu di-crop per ikon. |

## editing

Saran awal arah desain (boleh diganti): hue brand #B7791F (kuning tua) di atas permukaan hampir-hitam; assetnya multiwarna, jadi UI dibuat netral; font display Bricolage Grotesque.

| File | Jenis | Ukuran | Latar | Catatan |
|---|---|---|---|---|
| `assets/caggy/editing/editing-3d-app-icons-sheet.jpg` | icon-sheet | 736x1355 | gradasi gelap | Lembar ikon aplikasi desain berwarna-warni. PERHATIAN: sebagian ikon mirip logo produk Adobe (Ps, Pr, Ai, Au). Jangan dipakai di produk publik/komersial tanpa dicek. |

## fashion

Saran awal arah desain (boleh diganti): hue brand #B3261E (merah) di atas krem hangat; font display Fraunces.

| File | Jenis | Ukuran | Latar | Catatan |
|---|---|---|---|---|
| `assets/caggy/fashion/fashion-3d-sale-icons-sheet.jpg` | icon-sheet | 736x944 | putih | Lembar ikon 3D hitam-merah (tas belanja, SALE, megafon, troli, jam). Perlu di-crop per ikon. |
| `assets/caggy/fashion/fashion-hero-mobile-shopping.jpg` | hero-illustration | 736x613 | putih | Ponsel dengan kanopi toko, troli, kartu, paket, struk. Cocok: e-commerce, toko online. |

## hospital

Saran awal arah desain (boleh diganti): hue brand #0E7490 (teal-biru); font display Bricolage Grotesque.

| File | Jenis | Ukuran | Latar | Catatan |
|---|---|---|---|---|
| `assets/caggy/hospital/hospital-bed-patient.jpg` | spot-illustration | 736x736 | putih | Ranjang rawat inap isometrik dengan pasien dan infus. |
| `assets/caggy/hospital/hospital-building.jpg` | hero-illustration | 736x736 | abu-terang | Gedung rumah sakit isometrik. Latar abu terang, bukan putih murni. |
| `assets/caggy/hospital/hospital-medical-elements-sheet.jpg` | icon-sheet | 736x736 | putih | Lembar 30 elemen medis (stetoskop, masker, obat, jarum suntik, kursi roda). Perlu di-crop per ikon. |

## hosting

Saran awal arah desain (boleh diganti): hue brand #1F5FBF (biru); font display Satoshi.

| File | Jenis | Ukuran | Latar | Catatan |
|---|---|---|---|---|
| `assets/caggy/hosting/hosting-domain-browser.jpg` | hero-illustration | 736x736 | putih | Jendela browser dengan www, globe, kaca pembesar. PERHATIAN: teks pada gambar salah eja ('.COm', '.arg'). Jangan dipakai tampil utuh; crop bagian globe atau ganti. |
| `assets/caggy/hosting/hosting-business-icons-sheet.jpg` | icon-sheet | 736x1104 | biru muda | Lembar ikon biru bisnis/keuangan/hosting. PERHATIAN: ada watermark 'Iconora Studio' di bagian bawah; crop atau ganti sebelum dipakai. |

## school

Saran awal arah desain (boleh diganti): hue brand #2F4FA0 (biru, selaras dengan seragam); font display Fraunces.

| File | Jenis | Ukuran | Latar | Catatan |
|---|---|---|---|---|
| `assets/caggy/school/school-students-walking.jpg` | hero-illustration | 736x1104 | putih | Dua siswa berseragam putih-biru membawa buku dan tas. Cocok: sekolah, bimbel, kursus. |
| `assets/caggy/school/school-supplies-checkerboard.jpg` | spot-illustration | 736x650 | KOTAK-KOTAK TERPANGGANG | Buku, tas, topi toga, pensil. PERHATIAN: pola kotak-kotak 'transparan' tertanam di gambar (bukan transparansi asli). Tidak bisa ditaruh di atas warna solid; perlu cutout ulang. |

## trading

Saran awal arah desain (boleh diganti): hue brand #17356B (navy). Hijau/merah hanya token semantik untung/rugi, bukan hue brand; font display Cabinet Grotesk.

| File | Jenis | Ukuran | Latar | Catatan |
|---|---|---|---|---|
| `assets/caggy/trading/trading-analytics-clipboard.jpg` | hero-illustration | 980x980 | putih | Clipboard grafik batang, kalkulator, koin. Cocok: keuangan, akuntansi, analitik. |
| `assets/caggy/trading/trading-trader-candles.jpg` | hero-illustration | 736x736 | putih | Trader dengan grafik candlestick dan label BUY/SELL (teks Inggris di dalam gambar). |
| `assets/caggy/trading/trading-coins-growth.jpg` | spot-illustration | 736x736 | putih | Tumpukan koin dan batang hijau naik. Ikon tunggal bersih, mudah dipakai. |

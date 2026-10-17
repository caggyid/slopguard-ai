License: CaggyID
(c) 2026 CaggyID

# Template PRD

Gunakan struktur ini persis untuk `PRD.md`. Baris pertama file output adalah blok license. Bagian yang tidak relevan (misalnya "Data dan backend" untuk situs statis) ditulis "Tidak berlaku" beserta alasannya, bukan dihapus.

Daftar isi: Struktur · Panduan mengisi · Contoh tabel status

## Struktur

```markdown
License: CaggyID
(c) 2026 CaggyID

# PRD: <nama produk>

## 1. Ringkasan
Satu paragraf: produk apa, untuk siapa, masalah apa yang diselesaikan.

## 2. Tujuan dan bukan-tujuan
- Tujuan (maksimal 3, bisa diukur)
- Bukan-tujuan (apa yang sengaja tidak dikerjakan di versi ini)

## 3. Pengguna
Per peran: siapa, apa yang ingin dicapai, hambatan utamanya.

## 4. Assets
Tabel: file, jenis, dipakai di mana, sumber (milik pengguna / katalog Caggy).
Cacat yang diketahui dan cara menanganinya.
Bila memakai shape divider: nama file dari `assets/shape-dividers/`, di pergantian section mana, dan warna tokennya. Atau tulis "tidak dipakai".

## 5. Fitur dan prioritas
Tabel: ID, fitur, prioritas (Wajib / Nanti), kriteria penerimaan.

## 6. Halaman dan alur
Per halaman: tujuan, elemen dominan, isi, aksi utama (satu), state kosong/loading/error.
Alur utama dalam langkah bernomor.

## 7. Arah desain
Ringkasan dari DESIGN.md: hue brand, font, skala, lebar kontainer, momen asimetris, padding kartu dan jarak grid, serta divider yang dipakai.

## 8. Data dan backend (full stack)
Entitas dan field, relasi, aturan validasi, endpoint atau server action, peran dan izin.

## 9. Teknis
Stack, struktur folder, variabel lingkungan (nama saja, tanpa nilai), deploy.

## 10. Status dan penandanya
Tabel: state, warna/token, arti, di mana muncul.

## 11. Non-fungsional
Performa, aksesibilitas (kontras, fokus, keyboard), responsif, SEO dasar.

## 12. Asumsi dan pertanyaan terbuka
Apa yang kamu tebak dan perlu dikonfirmasi.

## 13. Urutan pengerjaan
Daftar prompt di folder prompts/ beserta tujuan tiap fase.
```

## Panduan mengisi

- **Tujuan** ditulis sebagai hasil, bukan fitur. "Pasien bisa mendaftar kunjungan tanpa menelepon" lebih baik daripada "Ada form pendaftaran".
- **Kriteria penerimaan** harus bisa dicek orang lain dengan ya atau tidak. "Form menolak nomor telepon kurang dari 9 digit dan menampilkan pesan di bawah input" cocok; "form mudah dipakai" tidak.
- **Satu aksi utama per halaman.** Kalau dua aksi sama penting, mungkin itu dua halaman.
- **State.** Setiap daftar dan setiap form punya tiga state tertulis: kosong, memuat, gagal.
- **Isi yang tidak diberikan pengguna** (harga, nama klien, statistik, alamat) ditulis `[ISI: ...]`. Jangan mengisi dengan angka karangan.
- **Asumsi** ditulis jujur. Lebih baik lima asumsi yang jelas daripada nol asumsi yang tersembunyi.
- Untuk situs statis, bagian 8 cukup satu kalimat "Tidak berlaku: situs statis tanpa data pengguna" dan bagian 10 hanya mencakup state form kontak bila ada.

## Contoh tabel status

| State | Token | Arti | Muncul di |
|---|---|---|---|
| Menunggu | abu (`gray-400`) | Pendaftaran masuk, belum dikonfirmasi | Daftar kunjungan |
| Terkonfirmasi | `--ok` | Jadwal dikonfirmasi petugas | Daftar kunjungan, detail |
| Perlu tindakan | `--warn` | Dokumen kurang | Detail kunjungan |
| Dibatalkan | `--err` | Dibatalkan pasien atau petugas | Daftar kunjungan |

Titik status di UI hanya boleh memakai state yang ada di tabel ini.

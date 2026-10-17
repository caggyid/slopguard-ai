License: CaggyID
(c) 2026 CaggyID

# Template prompt vibe coding

Setiap file di `prompts/` adalah satu prompt yang berdiri sendiri. Pengguna akan menempelkannya ke Lovable, Bolt, v0, Cursor, Claude Code, atau alat serupa, satu per satu. Alat itu tidak membawa konteks dari prompt sebelumnya dengan andal, jadi setiap prompt memuat sendiri hal-hal yang dibutuhkannya.

Daftar isi: Aturan tiap prompt · Struktur · Daftar fase · Contoh lengkap

## Aturan tiap prompt

1. **Baris pertama adalah blok license**, teks biasa:

   ```
   License: CaggyID
   (c) 2026 CaggyID
   ```

2. **Satu fase, satu tujuan.** Kalau judul prompt butuh kata "dan" lebih dari sekali, pecah.
3. **Nilai konkret, bukan kata sifat.** Tulis nama kelas, hex, lebar, dan jumlah kolom.
4. **Ulangi token desain yang relevan** (hue brand, font, skala, lebar kontainer). Jangan hanya menulis "lihat DESIGN.md"; alat vibe coding sering tidak punya file itu.
5. **Sebut path assets** yang dipakai, persis seperti di `public-assets/` atau `public/assets/`.
6. **Kriteria penerimaan** yang bisa dicek ya atau tidak.
7. **Baris "Di luar cakupan"** supaya alat tidak melompat mengerjakan fase lain.
8. **Baris "Jangan"** hanya untuk melarang pola di `02-design-rules.md`, ditulis spesifik. Jangan menulis perintah positif untuk pola terlarang.
9. Tidak ada fakta karangan. Pakai `[ISI: ...]` dan minta alat membiarkannya terlihat sebagai penanda, bukan mengisinya sendiri.

## Struktur

```markdown
License: CaggyID
(c) 2026 CaggyID

# Prompt NN: <judul fase>

## Konteks
Dua sampai empat kalimat: produk, pengguna, stack, dan apa yang sudah ada dari fase sebelumnya.

## Tujuan fase ini
Satu kalimat.

## Yang harus dibuat
Daftar bernomor, tiap butir menyebut file atau komponen dan perilakunya.

## Desain yang berlaku
Hanya yang relevan untuk fase ini: hue brand, font, kelas komponen, lebar kontainer, momen asimetris.

## Assets
Path file dan penempatannya. Kalau tidak ada: "Tidak ada gambar di fase ini."

## Kriteria penerimaan
Daftar centang yang bisa dicek.

## Di luar cakupan
Apa yang tidak boleh dikerjakan sekarang.

## Jangan
Pola terlarang yang paling mungkin dilanggar di fase ini, ditulis spesifik.
```

## Daftar fase

Sesuaikan dengan proyek. Situs statis biasanya memakai 00, 01, 02 (satu per halaman), 03, dan 07. Full stack memakai semuanya.

| No | Fase | Isi |
|---|---|---|
| 00 | setup | Repo, stack, Tailwind, token desain, font, salin assets, struktur folder |
| 01 | layout-shell | Navigasi `fixed top-0 border-b`, footer minimal, sistem kontainer dan ritme padding |
| 02 | halaman-<nama> | Satu prompt per halaman, menyebut momen asimetris di halaman itu |
| 03 | komponen-form | Tombol, input dengan state error dan sukses, tabel status |
| 04 | data-backend | Skema, migrasi, validasi, endpoint atau server action |
| 05 | auth-peran | Login, sesi, peran dan izin |
| 06 | state-integrasi | State kosong, memuat, gagal; sambungkan UI ke data |
| 07 | qa-polish | Aksesibilitas, kontras, responsif, performa, jalankan audit pola terlarang |

## Contoh lengkap

Contoh ini untuk situs klinik; ganti isinya sesuai proyek.

```markdown
License: CaggyID
(c) 2026 CaggyID

# Prompt 02: Halaman beranda

## Konteks
Situs klinik gigi dua dokter di Surabaya. Next.js App Router, TypeScript, Tailwind. Fase 00 dan 01 selesai: token desain, font, navigasi, dan footer sudah ada.

## Tujuan fase ini
Membuat halaman beranda yang mengarahkan pengunjung ke satu aksi: mendaftar kunjungan.

## Yang harus dibuat
1. `app/page.tsx` berisi empat section dengan urutan: hero, layanan, jadwal dokter, kontak.
2. Hero: grid 12 kolom. Teks `col-span-7` rata kiri, `max-w-prose`. Judul `text-4xl font-bold leading-tight` (Bricolage Grotesque). Satu tombol primer "Daftar kunjungan" dan satu tautan teks "Lihat layanan". Visual `col-span-5` menembus tepi kanan kontainer dengan `-mr-12`.
3. Layanan: judul di kolom kiri sempit (`col-span-4`), daftar layanan di kolom kanan (`col-span-8`) sebagai baris dengan garis pemisah, bukan kartu.
4. Jadwal dokter: tabel sederhana, `max-w-2xl`.
5. Kontak: alamat `[ISI: alamat klinik]`, tautan WhatsApp `[ISI: nomor]`.

## Desain yang berlaku
- Hue brand `#0E7490`, dipakai hanya untuk tombol primer dan tautan. Permukaan `#FAFAF7` (60%), `#F0EFE9` (30%).
- Padding section berurutan: hero `py-24`, layanan `py-12`, jadwal `py-16`, kontak `py-32`.
- Teks isi `text-gray-700`, `leading-relaxed`.
- Dua momen asimetris di halaman ini: visual hero yang menembus tepi, dan judul layanan di kolom sempit.

## Assets
- `public/assets/hospital/hospital-building.jpg` di kolom visual hero, tampil maksimal 480 px lebar. Latar abu terang; taruh di panel `bg-[#F0EFE9]`.

## Kriteria penerimaan
- [ ] Hero tidak rata tengah dan hanya punya satu tombol solid.
- [ ] Empat section memakai tiga lebar kontainer berbeda (`max-w-6xl`, `max-w-2xl`, dan satu full-bleed).
- [ ] Tidak ada dua section bersebelahan dengan padding yang sama.
- [ ] Semua `[ISI: ...]` tampil sebagai penanda yang terlihat.
- [ ] Kontras teks isi lulus WCAG AA.

## Di luar cakupan
Form pendaftaran (fase 03), backend (fase 04), halaman lain.

## Jangan
Jangan membuat grid tiga kartu layanan, jangan memusatkan hero, jangan menambah strip logo klien atau testimoni.
```

License: CaggyID
(c) 2026 CaggyID

# Aturan desain

Aturan ini dibuat dari satu masalah: alat vibe coding, kalau dibiarkan, menghasilkan tampilan yang sama di semua proyek. Tujuan aturan ini adalah membuat setiap proyek terlihat dirancang untuk produknya.

Daftar isi: Terlarang · Warna · Tipografi · Layout · Ikon dan gambar · Komponen · Salinan teks · Token siap tempel · Cara menulisnya di prompt

## Terlarang

Pola di bawah ini tidak boleh diminta dalam prompt maupun muncul di kode.

UI/UX dan komponen bergaya AI:

- gradasi ungu (purple gradient)
- Inter atau Geist dipakai untuk semuanya
- hero rata tengah dengan dua tombol (dual CTA)
- grid tiga kartu yang identik
- `rounded-2xl`
- tombol pil dengan gradasi (gradient pill button)
- strip "Trusted by"
- kata "Supercharge"
- gumpalan aurora (aurora blobs)
- glassmorphism
- emoji sebagai ikon
- kartu dengan garis tebal di sisi kiri (left-border cards)
- judul bergradasi (gradient headline)
- `font-extrabold tracking-tighter`

Layout:

- semuanya rata tengah
- `max-w-7xl` sebagai kontainer semua section
- `py-20` seragam di semua section
- grid tiga kolom simetris

Alasannya: masing-masing pola ini adalah "tanda tangan" keluaran AI yang paling cepat dikenali orang. Satu saja sudah cukup membuat halaman terasa generik.

## Warna

- **Satu hue brand yang disengaja.** Tidak ada hue kedua untuk dekorasi. Warna semantik (sukses, error, peringatan) boleh ada, tetapi hanya untuk status.
- **Distribusi 60-30-10.** 60% permukaan netral, 30% permukaan sekunder atau teks, 10% hue brand. Brand dipakai sedikit supaya terasa.
- **Permukaan flat dan solid.** Tanpa gradasi dan tanpa blur latar.
- **Bayangan fungsional.** Hanya `shadow-sm` atau `shadow-md`, netral (hitam transparan, bukan berwarna). Bayangan dipakai untuk menandai lapisan (dropdown, modal), bukan hiasan.
- **Teks isi minimal `gray-700` di mode terang, `gray-200` di mode gelap.** Tidak ada teks isi abu pucat.
- **Selaraskan dengan assets.** Hue brand harus akur dengan warna dominan gambar yang dipakai (brand biru + gambar biru selaras; brand merah + gambar hijau bertabrakan). Warna di dalam ilustrasi tidak dihitung sebagai hue UI.

## Tipografi

- **Font display yang khas**: Fraunces, Bricolage Grotesque, Satoshi, atau Cabinet Grotesk. Pilih satu untuk judul.
- **Font isi** yang mudah dibaca dan bukan Inter/Geist, kecuali merek pengguna memang memakainya. Opsi: Satoshi, Public Sans, IBM Plex Sans, atau font display yang punya bobot teks.
- **Skala modular 1.25** dari dasar 16 px: 12.8, 16, 20, 25, 31.25, 39, 48.8, 61 px (0.8, 1, 1.25, 1.563, 1.953, 2.441, 3.052, 3.815 rem).
- **Maksimal 2 sampai 3 bobot**: 400, 500, 700. Tidak ada `font-extrabold`, tidak ada `tracking-tighter`.
- **Judul `leading-tight`, isi `leading-relaxed`.**
- **Paragraf rata kiri dan `max-w-prose`** (sekitar 65 karakter).
- Satoshi dan Cabinet Grotesk tersedia lewat Fontshare; Fraunces dan Bricolage Grotesque lewat Google Fonts. Minta prompt memuat font lewat `next/font` atau `@font-face` lokal, dengan fallback sistem.

## Layout

- **Lebar kontainer menyesuaikan isi**: `max-w-2xl` untuk teks, `max-w-6xl` untuk grid, dan sesekali full-bleed untuk pemisah. Tidak ada satu lebar untuk semua section.
- **Padding section bervariasi.** Pilih dari `py-12`, `py-16`, `py-24`, `py-32`. Dua section yang bersebelahan tidak boleh memakai padding yang sama.
- **Struktur grid bercampur**: kolom 2, 4, atau span asimetris (misalnya 5/7 atau 8/4 pada grid 12 kolom). Hindari tiga kolom yang sama lebar.
- **Satu elemen dominan per section.** Satu judul besar, atau satu visual besar, bukan lima hal sama berat.
- **Skala jarak kontekstual**: 4 px antar elemen sebaris, 16 px dalam kartu, 48 px antar blok section.
- **Minimal dua momen asimetris yang disengaja per halaman.** Contoh: hero dengan teks di kolom kiri 7/12 dan visual yang menembus tepi kanan; satu section dengan judul di kolom sempit kiri dan isi di kolom lebar kanan; satu gambar yang bergeser keluar dari kontainer. Sebut momennya satu per satu di DESIGN.md.
- Rata kiri sebagai default. Rata tengah hanya untuk elemen tunggal pendek (misalnya satu kalimat penutup), tidak untuk seluruh halaman.

## Ikon dan gambar

- **Satu library ikon, satu varian.** Usulan: Lucide, stroke 1.5, ukuran 16 sampai 24 px. Monokrom, paling banyak dua warna.
- **Screenshot produk asli lebih baik daripada ilustrasi.** Kalau produk punya UI, bangun UI itu dari komponen asli dan jadikan itu visual utama. Ilustrasi dan ikon 3D dari katalog Caggy adalah pendukung.
- **Setiap titik status punya arti terdokumentasi.** Hijau, kuning, merah, abu masing-masing dipetakan ke satu state di tabel (lihat PRD). Tidak ada titik berwarna hanya sebagai hiasan.
- Gambar di atas permukaan: beri teks panel solid, jangan menaruh teks langsung di atas gambar.

## Komponen

| Komponen | Spesifikasi |
|---|---|
| Tombol | Satu tombol primer solid per section. Aksi sekunder berupa tautan teks. `rounded-md` atau `rounded-lg`, `px-4 py-2 text-sm`, bobot 500. Tanpa gradasi, tanpa pil. |
| Input | `border border-gray-300 rounded-md`, label di atas. Wajib punya state fokus, error (pesan di bawah, warna error), dan sukses nyata. |
| Navigasi | `fixed top-0` dengan `border-b`, latar solid. Tanpa blur. |
| Footer | Minimal, hanya tautan yang benar-benar ada. |
| Cookie | Hanya bila hukum atau fitur membutuhkan. Dua pilihan dengan bobot visual sama. |
| Kartu | Latar solid, `rounded-md`, `shadow-sm` atau `border`. Tanpa garis tebal di sisi kiri. |

## Salinan teks

- Tulis kalimat spesifik tentang produk: apa yang dilakukan, untuk siapa, hasilnya apa.
- Tidak ada "Trusted by", "Supercharge", "Unlock", "Revolutionize", "Seamless".
- Tidak ada testimoni, logo klien, atau angka yang tidak diberikan pengguna. Pakai `[ISI: ...]`.
- Tombol memakai kata kerja jelas ("Daftar kunjungan", "Lihat harga"), bukan "Mulai sekarang".

## Token siap tempel

```css
:root {
  /* 60: permukaan netral */
  --surface: #FAFAF7;
  /* 30: permukaan sekunder dan teks */
  --surface-alt: #F0EFE9;
  --ink: #374151;          /* gray-700, minimum untuk teks isi */
  --ink-strong: #111827;   /* judul */
  --line: #D1D5DB;         /* gray-300 */
  /* 10: satu-satunya hue brand */
  --brand: #000000;       /* GANTI: hex dari logo atau saran katalog */
  --brand-ink: #000000;   /* GANTI: versi lebih gelap untuk hover dan teks di atas permukaan terang */
  /* semantik, hanya untuk status */
  --ok: #15803D; --warn: #B45309; --err: #B91C1C;

  /* skala 1.25 */
  --t-sm: 0.8rem; --t-base: 1rem; --t-md: 1.25rem; --t-lg: 1.563rem;
  --t-xl: 1.953rem; --t-2xl: 2.441rem; --t-3xl: 3.052rem; --t-4xl: 3.815rem;

  /* jarak kontekstual */
  --gap-inline: 4px; --gap-card: 16px; --gap-section: 48px;
}
@media (prefers-color-scheme: dark) {
  :root {
    --surface: #14140F; --surface-alt: #1E1E18;
    --ink: #E5E7EB;       /* gray-200, minimum untuk teks isi gelap */
    --ink-strong: #F9FAFB; --line: #3F3F37;
  }
}
```

Nilai netral di atas adalah titik awal; sesuaikan kehangatannya dengan hue brand. Jangan menambah variabel warna dekoratif.

## Cara menulisnya di prompt

Ganti kata sifat dengan nilai.

- Hindari: "buat hero yang modern dan bersih".
- Tulis: "Hero dua kolom pada grid 12: teks `col-span-7` rata kiri dengan `max-w-prose`, judul `text-4xl font-bold leading-tight` memakai Bricolage Grotesque; visual `col-span-5` yang melewati tepi kanan kontainer dengan `-mr-12`. Satu tombol primer solid `rounded-md px-4 py-2 text-sm`, aksi sekunder berupa tautan teks."

Kalau alat vibe coding mulai melanggar, tambahkan satu baris "Jangan" yang menyebut pola itu secara spesifik, bukan peringatan umum.

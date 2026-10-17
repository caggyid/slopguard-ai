License: CaggyID
(c) 2026 CaggyID

# Checklist audit

Jalankan sebelum mengirim hasil ke pengguna. Skrip menangkap yang bisa dicari lewat teks; sisanya perlu dibaca manusia (kamu).

```bash
python scripts/audit.py <folder-output> --mode prompts
```

Skrip bersifat heuristik. Baris yang memuat kata penolak ("jangan", "tanpa", "hindari", dan sejenisnya) dilewati karena dianggap melarang pola. Akibatnya kalimat seperti "pakai rounded-2xl tanpa bayangan" bisa lolos. Karena itu baca ulang prompt, jangan hanya mengandalkan skrip.

## Otomatis (skrip)

- [ ] Setiap file `PRD.md`, `DESIGN.md`, dan `prompts/*.md` diawali `License: CaggyID`
- [ ] Setiap prompt punya bagian "Kriteria penerimaan" dan "Di luar cakupan"
- [ ] Tidak ada kelas atau frasa terlarang yang muncul sebagai instruksi
- [ ] Tidak ada gradasi atau warna neon di divider SVG; path divider cocok dengan `assets/shape-dividers/` (mode code)
- [ ] Tidak ada padding kartu di bawah `p-6` dan tidak ada padding section di luar `py-12/16/24/32` (WARN, tinjau manual)
- [ ] Tidak ada kartu di dalam kartu (WARN, tinjau manual)
- [ ] Tidak ada emoji

## Manual: assets

- [ ] Pertanyaan assets sudah diajukan dan dijawab sebelum PRD ditulis
- [ ] Setiap file assets yang dipakai tercatat di PRD bagian 4 dan di prompt yang memakainya
- [ ] File katalog Caggy yang bercacat (watermark, salah eja, kotak-kotak tertanam, mirip logo merek) ditangani atau diganti
- [ ] Lembar ikon di-crop per ikon, tidak tampil utuh
- [ ] Tidak ada gambar yang lebih lebar dari ukuran aslinya

## Manual: desain

- [ ] Satu hue brand; hue lain hanya untuk status
- [ ] Pembagian 60-30-10 tertulis di DESIGN.md
- [ ] Font display dari daftar (Fraunces, Bricolage Grotesque, Satoshi, Cabinet Grotesk); font isi bukan Inter/Geist
- [ ] Skala 1.25, maksimal tiga bobot (400/500/700)
- [ ] Lebar kontainer berbeda menurut isi; tidak ada satu lebar untuk semua section
- [ ] Padding dua section bersebelahan tidak sama
- [ ] Setiap halaman menyebut minimal dua momen asimetris
- [ ] Setiap section punya satu elemen dominan
- [ ] Hero tidak rata tengah dan hanya satu tombol solid; aksi sekunder berupa tautan teks
- [ ] Tidak ada tiga kartu identik sejajar
- [ ] Tidak ada kartu di dalam kartu; isi kartu dikelompokkan dengan jarak atau `border-t`
- [ ] Padding tidak sesak: kartu minimal `p-6`, grid minimal `gap-6`, gutter minimal `px-6`, tombol dan input tinggi minimal 44 px
- [ ] Divider hanya dari `assets/shape-dividers/`, path tidak diubah, satu warna solid sama dengan section di bawahnya, tanpa gradasi atau neon, DESIGN.md menyebut di mana dipakai
- [ ] Satu library ikon, satu varian, 16 sampai 24 px
- [ ] Setiap titik status ada di tabel status PRD
- [ ] Input punya state fokus, error, dan sukses
- [ ] Teks isi minimal `gray-700` (terang) dan `gray-200` (gelap)

## Manual: isi

- [ ] Tidak ada nama klien, testimoni, atau angka karangan; semuanya `[ISI: ...]`
- [ ] Salinan teks spesifik, tidak ada klise
- [ ] Setiap fitur di PRD punya kriteria penerimaan yang bisa dicek ya/tidak
- [ ] Setiap daftar dan form punya state kosong, memuat, dan gagal
- [ ] Asumsi ditulis, termasuk stack default bila pengguna tidak memilih

## Setelah itu

Laporkan ke pengguna hasilnya dalam satu baris (misalnya "audit: 0 ERROR, 1 WARN yang sudah ditinjau") dan sebutkan WARN yang kamu biarkan beserta alasannya.

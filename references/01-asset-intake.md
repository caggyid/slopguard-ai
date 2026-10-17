License: CaggyID
(c) 2026 CaggyID

# Gerbang assets

Ini pertanyaan pertama di setiap proyek. Tanyakan sebelum menulis PRD, memilih warna, memilih font, atau membuat prompt.

## Pertanyaan

Dengan `ask_user_input_v0`:

- Pertanyaan: "Sebelum mulai: kamu punya file assets untuk website ini? (logo, foto produk, gambar, ikon, font, screenshot, brand guideline)"
- Pilihan:
  1. Ada, aku upload sekarang
  2. Sebagian saja (misalnya cuma logo)
  3. Tidak ada, pakai assets Caggy

Tanpa alat tersebut, tulis pesan biasa dengan isi yang sama, lalu tambahkan satu baris: "Kalau ada, kirim juga hex warna brand dan nama font kalau sudah punya."

Setelah mengirim pertanyaan, berhenti. Jangan lanjut menulis PRD sambil menunggu.

## Menangani jawaban

### A. Ada assets

1. Lihat tiap file yang diunggah. Catat jenisnya: logo, foto produk, ilustrasi, ikon, screenshot UI.
2. Kalau ada logo, periksa format. SVG paling baik; PNG transparan cukup; JPG dengan latar putih perlu dicatat sebagai keterbatasan.
3. Ambil hue brand dari logo. Contoh cepat di sandbox:

   ```python
   from PIL import Image
   im = Image.open("logo.png").convert("RGB").resize((64, 64))
   colors = im.quantize(5).convert("RGB").getcolors()
   ```

   Pilih warna paling jenuh yang bukan putih/abu/hitam. Itu hue brand. Jangan menambah hue kedua.
4. Kalau pengguna juga punya hex atau font, itu menang atas hasil ekstraksi.
5. Tuliskan di DESIGN.md daftar assets (nama file, dipakai di mana).

### B. Sebagian

Pakai yang ada. Untuk yang kurang, tawarkan dua jalan dalam satu kalimat: isi dari katalog Caggy, atau biarkan section itu tanpa gambar dan fokus ke tipografi. Jangan membuat gambar ilustrasi sendiri atau memakai gambar stok dari internet.

### C. Tidak ada

1. Buka `references/06-caggy-assets-catalog.md`.
2. Pilih kategori yang cocok dengan industri. Pilih 1 sampai 3 file, bukan semuanya.
3. Baca kolom Catatan tiap file. Kalau file bercacat (watermark, salah eja, kotak-kotak tertanam, mirip logo merek lain), pilih file lain atau tulis di DESIGN.md cara menanganinya (misalnya "crop bagian bawah untuk membuang watermark").
4. Tanpa logo, jangan membuat logo gambar. Pakai wordmark teks: nama produk dalam font display, satu bobot.
5. Beri tahu pengguna file mana yang dipilih dan kenapa, dalam satu atau dua kalimat. Kalau ada keterbatasan resolusi (lebar maksimum 736 px), sebutkan.
6. Salin file terpilih ke `public-assets/` di folder output.

## Yang tidak boleh

- Menganggap "tidak disebut" sebagai "tidak ada". Kalau pengguna belum menjawab, tanyakan.
- Memakai gambar dari URL stok atau placeholder acak.
- Memakai emoji sebagai pengganti ikon atau gambar.
- Mengubah warna atau memotong logo pengguna tanpa diminta.

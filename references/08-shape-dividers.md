License: CaggyID
(c) 2026 CaggyID

# Shape divider

Pemisah bentuk di pergantian dua section (lengkung, gelombang, miring, dan sebagainya). Dibaca di Langkah 2 (DESIGN.md) dan setiap kali menulis prompt yang menyentuh pemisah section.

Gambar acuan dari pemilik skill: `docs/images/shape-dividers-reference.png`. File SVG-nya ada di `assets/shape-dividers/`, daftar mesinnya di `assets/shape-dividers/manifest.json`.

## Aturan keras

1. **Hanya 14 bentuk di folder assets.** Tidak ada divider yang digambar sendiri, dikarang, atau ditiru dari library lain. Kalau tidak ada bentuk yang cocok, tidak pakai divider (sambungan section lurus).
2. **Bentuk tidak boleh diubah.** Jangan edit atribut `d`, `viewBox`, atau `preserveAspectRatio="none"`. Jangan tambah, hapus, gabung, putar, atau balik layer. Jangan dibuat ulang dengan `clip-path`, `border-radius`, atau CSS lain. Variasi "Alt" yang tersedia (Curve Asym. Alt, Tilt Alt) sudah cukup; tidak ada variasi lain.
3. **Satu-satunya yang boleh diganti adalah warna.** Dan warnanya harus:
   - satu warna solid (`fill` / `currentColor`), tanpa gradasi sama sekali, baik `linearGradient`, `radialGradient`, maupun gradasi CSS;
   - sederhana dan tidak neon: tanpa warna pendar atau berjenuh tinggi seperti `#00FFFF`, `#39FF14`, `#FF00FF`, `#FF3CAC`; tanpa `glow`, `drop-shadow`, `filter`, `blur`, `stroke`, atau animasi warna;
   - sama dengan warna permukaan section yang ada di bawahnya, diambil dari token DESIGN.md: `--surface`, `--surface-alt`, atau `--ink-strong` bila section di bawahnya blok gelap. `--brand` hanya bila section di bawahnya memang blok brand solid.
4. **Nilai opacity di dalam file tetap.** Bentuk bertingkat (Fan, Curve Opacity, Mountains, Waves Opacity, Waves Opacity 2) memang memakai beberapa layer transparan dari warna yang sama. Itu bagian dari bentuknya, jangan diubah dan jangan diberi warna berbeda per layer.
5. **Hanya di dasar section.** Divider ditaruh di bagian bawah section atas, lebar penuh, tidak diputar ke atas section bawah.

## Default yang disarankan

Ini default, boleh diganti pengguna:

- Pakai hemat: hanya di pergantian permukaan yang memang berbeda warna, bukan di setiap sambungan section.
- Pakai satu bentuk di seluruh situs supaya konsisten.
- Tinggi tampil `h-12 md:h-20`, lebar `w-full`. Ini ukuran tampil, bukan perubahan bentuk.

## Daftar bentuk

| ID | File | Karakter |
|---|---|---|
| curve | `assets/shape-dividers/curve.svg` | Lengkung simetris, menggembung ke bawah di tengah |
| fan | `assets/shape-dividers/fan.svg` | Dua pita transparan bersilang |
| curve-opacity | `assets/shape-dividers/curve-opacity.svg` | Lengkung dengan dua lapis transparan |
| mountains | `assets/shape-dividers/mountains.svg` | Bukit bertumpuk, tiga lapis transparan |
| curve-asym | `assets/shape-dividers/curve-asym.svg` | Lengkung tidak simetris, puncak di kanan |
| curve-asym-alt | `assets/shape-dividers/curve-asym-alt.svg` | Cermin curve-asym, puncak di kiri |
| tilt | `assets/shape-dividers/tilt.svg` | Garis miring turun ke kanan |
| tilt-alt | `assets/shape-dividers/tilt-alt.svg` | Garis miring turun ke kiri |
| triangle | `assets/shape-dividers/triangle.svg` | Takik segitiga di tengah |
| waves | `assets/shape-dividers/waves.svg` | Satu gelombang naik ke kanan |
| waves-opacity | `assets/shape-dividers/waves-opacity.svg` | Gelombang dengan dua lapis transparan |
| waves-opacity-2 | `assets/shape-dividers/waves-opacity-2.svg` | Gelombang landai dengan tiga lapis transparan |
| clouds | `assets/shape-dividers/clouds.svg` | Gumpalan awan di tepi bawah |
| speech | `assets/shape-dividers/speech.svg` | Tepi lurus dengan ekor gelembung ucapan kecil |

Semua file memakai `viewBox="0 0 1000 100"`, `fill="currentColor"`, dan layer terakhir selalu solid dan menutup dasar penuh lebar.

## Cara memakai di kode

Salin isi `<path>` apa adanya dari file SVG ke komponen. Jangan mengetik ulang atau menyederhanakan `d`. Warna diatur lewat `color` (karena `fill="currentColor"`).

```tsx
// components/ShapeDivider.tsx
// License: CaggyID | (c) 2026 CaggyID
export function ShapeDividerWaves({ className = "" }: { className?: string }) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 1000 100"
      preserveAspectRatio="none"
      fill="currentColor"
      aria-hidden="true"
      focusable="false"
      className={`block w-full h-12 md:h-20 -mb-px ${className}`}
    >
      {/* d disalin persis dari assets/shape-dividers/waves.svg */}
      <path d="..." />
    </svg>
  );
}

// pemakaian: warna = permukaan section di bawahnya
// <section className="bg-surface">...<ShapeDividerWaves className="text-surface-alt" /></section>
```

`-mb-px` menutup garis tipis antar section akibat pembulatan piksel. Untuk bentuk berlayer, salin semua `<path>` beserta atribut `opacity` aslinya.

## Cara menulisnya di prompt

Tulis nama file, warna token, dan larangan, bukan "tambahkan pemisah gelombang yang modern":

> Di dasar hero, pakai `public/assets/shape-dividers/curve-asym.svg` apa adanya (path tidak diubah). Warna `text-[#F0EFE9]`, sama dengan section layanan di bawahnya, satu warna solid. Tinggi `h-12 md:h-20`, lebar penuh.
>
> Jangan menggambar divider sendiri, jangan mengubah path, jangan pakai gradasi atau warna neon pada divider.

Setiap prompt yang memakai divider harus menyalin file yang dipilih ke `public/assets/shape-dividers/` dan mencantumkannya di bagian Assets.

## Catatan asal

File SVG di folder ini digambar ulang mengikuti gambar acuan pemilik skill, bukan diekspor dari file vektor aslinya. Kalau kamu punya SVG aslinya, ganti file dengan nama yang sama dan perbarui `manifest.json`; aturan di atas tetap berlaku.

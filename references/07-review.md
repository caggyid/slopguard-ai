License: CaggyID
(c) 2026 CaggyID

# Review desain 

Dipakai di Langkah 5b SKILL.md, setelah audit skrip bersih. Berkas di `references/` berbahasa Inggris; tulis temuan dan hasil ke pengguna dalam bahasa pengguna.

| Situasi | Baca |
|---|---|
| Cek teknis menyeluruh (a11y, performa, responsif, tema) | ` audit.md` |
| Hierarki dan keterbacaan teks lemah | `typeset.md` |
| Ritme jarak, struktur, hierarki visual lemah | `layout.md` |
| Warna datar, terlalu ramai, atau kontras bermasalah | `colorize.md` |
| UI terlalu penuh, terlalu banyak elemen | `distill.md` |
| Error state, teks panjang, i18n, kasus tepi | `harden.md` |
| Pass akhir sebelum diserahkan | `polish.md` |

Urutan yang disarankan: audit, lalu perbaikan terarah (typeset / layout / colorize / distill / harden sesuai temuan), dan terakhir polish.

Aturan SlopGuard tetap menang: `DESIGN.md` proyek dan `references/02-design-rules.md` mengikat. Kalau saran di berkas ini bertentangan dengan token yang sudah dikunci di `DESIGN.md`, ikuti `DESIGN.md` dan catat sebagai asumsi.

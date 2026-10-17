#!/usr/bin/env python3
# License: CaggyID
# (c) 2026 CaggyID
"""
SlopGuard: audit pola terlarang dan blok license.

Pemakaian:
  python scripts/audit.py <folder> --mode prompts   # periksa PRD, DESIGN, dan prompts/
  python scripts/audit.py <folder> --mode code      # periksa kode hasil vibe coding

Kode keluar: 1 bila ada ERROR, 0 bila bersih atau hanya WARN.
Hanya memakai pustaka standar Python.
"""
import argparse
import colorsys
import json
import os
import re
import sys

LICENSE_LINE = "License: CaggyID"

# (pola, label, tingkat). ERROR = harus diperbaiki, WARN = perlu ditinjau manusia.
RULES = [
    (r"\b(from|via|to)-(purple|violet|fuchsia|indigo)-\d{2,3}\b", "gradasi ungu", "ERROR"),
    (r"\brounded-2xl\b", "rounded-2xl", "ERROR"),
    (r"\bmax-w-7xl\b", "max-w-7xl", "ERROR"),
    (r"\bfont-extrabold\b", "font-extrabold", "ERROR"),
    (r"\btracking-tighter\b", "tracking-tighter", "ERROR"),
    (r"\bbackdrop-blur(-[a-z0-9]+)?\b|backdrop-filter", "glassmorphism (backdrop blur)", "ERROR"),
    (r"\bbg-clip-text\b", "judul bergradasi (bg-clip-text)", "ERROR"),
    (r"\bblur-(2xl|3xl)\b", "gumpalan aurora (blur besar)", "ERROR"),
    (r"\bbg-(gradient|linear)-to-|linear-gradient\(|radial-gradient\(|conic-gradient\(", "gradasi (permukaan harus flat)", "WARN"),
    (r"\bborder-l-(2|4|8)\b", "kartu dengan garis tebal di sisi kiri", "WARN"),
    (r"\bgrid-cols-3\b", "grid 3 kolom (pastikan bukan tiga kartu identik)", "WARN"),
    (r"\b(Inter|Geist)\b", "font Inter/Geist", "WARN"),
    (r"(?i)trusted by|supercharge|unlock the power|revolutioni[sz]e|seamless(ly)?\b", "frasa klise AI", "ERROR"),
    (r"\btext-gray-(100|200|300|400|500|600)\b", "teks abu pucat (isi minimal gray-700 terang / gray-200 gelap)", "WARN"),
    (r"(?i)<(linear|radial)Gradient|\bfill\s*=\s*[\"']url\(", "gradasi di SVG (divider dan permukaan harus solid)", "ERROR"),
]

# Padding sesak pada kartu: baris yang menyebut kartu/panel tetapi memakai padding di bawah p-6.
CARD_WORD = re.compile(r"(?i)\b(card|panel|tile|callout|kartu)\b")
SMALL_PAD = re.compile(r"(?<![\w-])(?:[a-z]+:)?(?:p|px|py)-(?:0|0\.5|1|1\.5|2|2\.5|3|3\.5|4|5)(?![\w.-])")
SECTION_PY = re.compile(r"(?<![\w-])(?:[a-z]+:)?py-(\d+(?:\.\d+)?)(?![\w.-])")
ALLOWED_SECTION_PY = {"12", "16", "24", "32"}
HEX = re.compile(r"#(?:[0-9a-fA-F]{6}|[0-9a-fA-F]{3})\b")
DIVIDER_TRANSFORM = re.compile(r"rotate-180|(?<![\w])-?scale-[xy]-\[?-?1\]?|rotate\(180|scale\(-1")

HERE = os.path.dirname(os.path.abspath(__file__))
MANIFEST = os.path.join(HERE, "..", "assets", "shape-dividers", "manifest.json")

EMOJI = re.compile("[\U0001F300-\U0001FAFF\u2600-\u27BF\u2B50\u2B06\u2B07]")

# Baris yang berisi kata-kata ini dianggap melarang pola, bukan memintanya.
NEGATION = re.compile(
    r"(?i)\b(jangan|dilarang|hindari|terlarang|tidak boleh|tanpa|bukan|banned|never|avoid|don't|do not|no)\b"
)

CODE_EXT = {".tsx", ".jsx", ".ts", ".js", ".html", ".css", ".scss", ".vue", ".svelte", ".astro", ".mdx", ".svg"}
MARKUP_EXT = {".tsx", ".jsx", ".html", ".vue", ".svelte", ".astro", ".mdx"}
SKIP_DIRS = {"node_modules", ".next", "dist", "build", ".git", ".turbo", ".vercel", "coverage"}


def walk(root, exts):
    for d, dirs, files in os.walk(root):
        dirs[:] = [x for x in dirs if x not in SKIP_DIRS]
        for f in sorted(files):
            if os.path.splitext(f)[1].lower() in exts:
                yield os.path.join(d, f)


def read_lines(path):
    with open(path, encoding="utf-8", errors="replace") as fh:
        return fh.read().splitlines()


def check_license(path, lines, out):
    first = next((l.strip() for l in lines if l.strip()), "")
    if first != LICENSE_LINE:
        out.append((path, 1, "ERROR", f"baris pertama harus '{LICENSE_LINE}'"))
        return
    nonempty = [l for l in lines if l.strip()][:3]
    if not any("CaggyID" in l and "(c)" in l for l in nonempty[1:]):
        out.append((path, 2, "WARN", "baris kedua sebaiknya '(c) 2026 CaggyID'"))


def is_neon(hexstr):
    h = hexstr.lstrip("#")
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    r, g, b = (int(h[i:i + 2], 16) / 255 for i in (0, 2, 4))
    _, light, sat = colorsys.rgb_to_hls(r, g, b)
    return sat >= 0.97 and 0.45 <= light <= 0.78


def known_divider_paths():
    try:
        with open(MANIFEST, encoding="utf-8") as fh:
            data = json.load(fh)
    except (OSError, ValueError):
        return None
    return {re.sub(r"\s+", "", d) for item in data for d in item["d"]}


SVG_BLOCK = re.compile(r"<svg\b([^>]*)>(.*?)</svg>", re.S | re.I)
VIEWBOX_DIV = re.compile(r"viewBox\s*=\s*[\"']\s*0\s+0\s+1000\s+100\s*[\"']")
PATH_D = re.compile(r"\bd\s*=\s*[\"']([^\"']+)[\"']")


def check_dividers(path, text, out):
    known = known_divider_paths()
    if known is None:
        return
    for m in SVG_BLOCK.finditer(text):
        if not VIEWBOX_DIV.search(m.group(1)):
            continue
        line = text.count("\n", 0, m.start()) + 1
        for d in PATH_D.findall(m.group(2)):
            if re.sub(r"\s+", "", d) not in known:
                out.append((path, line, "WARN", "bentuk divider tidak cocok dengan assets/shape-dividers (path tidak boleh diubah)"))
                break
        if DIVIDER_TRANSFORM.search(m.group(1)):
            out.append((path, line, "WARN", "divider diputar atau dibalik (pakai varian Alt yang tersedia, jangan transform)"))


TAG = re.compile(r"<(/?)([A-Za-z][\w.]*)((?:[^<>\"'{}]|\"[^\"]*\"|'[^']*'|\{[^{}]*\})*?)(/?)>")
VOID = {"img", "br", "hr", "input", "meta", "link", "source", "area", "col", "embed", "wbr", "path", "circle", "rect", "line", "use"}
NOT_CARD_TAGS = {"button", "input", "textarea", "select", "img", "td", "th", "tr", "pre", "code", "svg", "a", "span", "label", "option"}
CLASS_ATTR = re.compile(r"(?:class|className)\s*=\s*(?:\"([^\"]*)\"|'([^']*)'|\{`([^`]*)`\}|\{\"([^\"]*)\"\})")


def is_card(name, attrs):
    if name in NOT_CARD_TAGS:
        return False
    if name == "Card" or name.endswith(".Card"):
        return True
    m = CLASS_ATTR.search(attrs)
    if not m:
        return False
    cls = next((g for g in m.groups() if g), "")
    toks = set(re.split(r"\s+", cls.strip()))
    base = {t.split(":")[-1] for t in toks}
    if base & {"badge", "chip", "avatar", "pill"} or "rounded-full" in base:
        return False
    if "card" in base or any(t.endswith("-card") or t.startswith("card-") for t in base):
        return True
    rounded = any(t.startswith("rounded") and t != "rounded-none" for t in base)
    edged = "border" in base or any(t.startswith("shadow") and t != "shadow-none" for t in base)
    return rounded and edged


def check_nested_cards(path, text, out):
    stack = []
    for m in TAG.finditer(text):
        closing, name, attrs, selfclose = m.groups()
        if closing:
            for i in range(len(stack) - 1, -1, -1):
                if stack[i][0] == name:
                    del stack[i:]
                    break
            continue
        card = is_card(name, attrs)
        if card and any(c for _, c in stack):
            line = text.count("\n", 0, m.start()) + 1
            out.append((path, line, "WARN", "kartu di dalam kartu (nested card dilarang)"))
        if not selfclose and name.lower() not in VOID:
            stack.append((name, card))


def scan_lines(path, lines, out, skip_negated):
    py20 = 0
    center = 0
    for i, line in enumerate(lines, 1):
        negated = skip_negated and NEGATION.search(line)
        for pat, label, level in RULES:
            if re.search(pat, line):
                if negated:
                    continue
                out.append((path, i, level, label))
        if EMOJI.search(line) and not negated:
            out.append((path, i, "ERROR", "emoji/dingbat (jangan dipakai sebagai ikon)"))
        if not negated:
            if CARD_WORD.search(line) and SMALL_PAD.search(line):
                out.append((path, i, "WARN", "padding kartu sempit (minimal p-6)"))
            if re.search(r"<section\b", line):
                bad = [n for n in SECTION_PY.findall(line) if n not in ALLOWED_SECTION_PY]
                if bad:
                    out.append((path, i, "WARN", f"padding section py-{bad[0]} di luar py-12/16/24/32"))
            for hx in HEX.findall(line):
                if is_neon(hx):
                    out.append((path, i, "WARN", f"warna neon atau berjenuh tinggi {hx} (pakai warna sederhana)"))
                    break
        py20 += len(re.findall(r"\bpy-20\b", line))
        center += len(re.findall(r"\btext-center\b", line))
    if py20 >= 3:
        out.append((path, 0, "ERROR", f"py-20 dipakai {py20} kali (padding section harus bervariasi)"))
    if center >= 5:
        out.append((path, 0, "WARN", f"text-center dipakai {center} kali (layout condong serba-tengah)"))


def audit_prompts(root, out):
    # Berkas wajib
    for name in ("PRD.md", "DESIGN.md"):
        if not os.path.isfile(os.path.join(root, name)):
            out.append((os.path.join(root, name), 0, "ERROR", "berkas wajib tidak ada"))
    pdir = os.path.join(root, "prompts")
    if not os.path.isdir(pdir):
        out.append((pdir, 0, "ERROR", "folder prompts/ tidak ada"))
    else:
        if not any(f.endswith(".md") for f in os.listdir(pdir)):
            out.append((pdir, 0, "ERROR", "prompts/ kosong"))

    targets = []
    for name in ("PRD.md", "DESIGN.md"):
        p = os.path.join(root, name)
        if os.path.isfile(p):
            targets.append(p)
    if os.path.isdir(pdir):
        targets += [p for p in walk(pdir, {".md"})]

    for p in targets:
        lines = read_lines(p)
        check_license(p, lines, out)
        scan_lines(p, lines, out, skip_negated=True)
        text_all = "\n".join(lines)
        if re.search(r"(?i)\bdivider\b|pemisah (section|bentuk)", text_all) and "shape-dividers" not in text_all:
            out.append((p, 0, "WARN", "menyebut divider tanpa merujuk assets/shape-dividers/"))
        if os.path.basename(os.path.dirname(p)) == "prompts":
            text = "\n".join(lines)
            for section in ("Kriteria penerimaan", "Di luar cakupan"):
                if section not in text:
                    out.append((p, 0, "ERROR", f"bagian '{section}' tidak ada"))


def audit_code(root, out):
    for p in walk(root, CODE_EXT):
        lines = read_lines(p)
        scan_lines(p, lines, out, skip_negated=False)
        text = "\n".join(lines)
        check_dividers(p, text, out)
        if os.path.splitext(p)[1].lower() in MARKUP_EXT:
            check_nested_cards(p, text, out)


def main():
    ap = argparse.ArgumentParser(description="SlopGuard audit: pola terlarang dan blok license")
    ap.add_argument("folder")
    ap.add_argument("--mode", choices=["prompts", "code"], default="prompts")
    a = ap.parse_args()

    if not os.path.isdir(a.folder):
        print(f"Folder tidak ditemukan: {a.folder}")
        return 2

    out = []
    (audit_prompts if a.mode == "prompts" else audit_code)(a.folder, out)

    errors = [o for o in out if o[2] == "ERROR"]
    warns = [o for o in out if o[2] == "WARN"]
    for path, line, level, msg in out:
        loc = f"{path}:{line}" if line else path
        print(f"[{level}] {loc}  {msg}")
    print(f"\nRingkasan: {len(errors)} ERROR, {len(warns)} WARN")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())

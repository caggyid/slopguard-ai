#!/usr/bin/env bash
# License: CaggyID
# (c) 2026 CaggyID
#
# SlopGuard installer: pasang skill ke beberapa agent AI sekaligus.
# Jalankan dari dalam folder repo ini (harus ada SKILL.md di sebelah script).
#
#   ./install.sh                       menu interaktif
#   ./install.sh -a claude,codex       pilih agent langsung
#   ./install.sh --all                 semua agent
#   ./install.sh --list                lihat daftar agent dan lokasinya
#   ./install.sh -h                    bantuan lengkap

set -u

SKILL_NAME="slopguard"
INSTALLER_VERSION="1.0.0"
AGENT_IDS="claude codex antigravity gemini cursor opencode copilot windsurf cline"

# Isi skill yang disalin. docs/ sengaja tidak ikut (hanya gambar README).
PAYLOAD="SKILL.md LICENSE NOTICE.md references scripts assets third_party"

SRC="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# ---------------------------------------------------------------- warna
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_RESET=$'\033[0m'; C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'
  C_GREEN=$'\033[32m'; C_RED=$'\033[31m'; C_YELLOW=$'\033[33m'; C_CYAN=$'\033[36m'
  USE_COLOR=1
else
  C_RESET=""; C_BOLD=""; C_DIM=""; C_GREEN=""; C_RED=""; C_YELLOW=""; C_CYAN=""
  USE_COLOR=0
fi

# ---------------------------------------------------------------- banner
banner() {
  local rows i color
  rows=(
'███████╗██╗      ██████╗ ██████╗  ██████╗ ██╗   ██╗ █████╗ ██████╗ ██████╗ '
'██╔════╝██║     ██╔═══██╗██╔══██╗██╔════╝ ██║   ██║██╔══██╗██╔══██╗██╔══██╗'
'███████╗██║     ██║   ██║██████╔╝██║  ███╗██║   ██║███████║██████╔╝██║  ██║'
'╚════██║██║     ██║   ██║██╔═══╝ ██║   ██║██║   ██║██╔══██║██╔══██╗██║  ██║'
'███████║███████╗╚██████╔╝██║     ╚██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝'
'╚══════╝╚══════╝ ╚═════╝ ╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ '
  )
  local gradient=(177 141 105 69 39 33)
  echo
  i=0
  for row in "${rows[@]}"; do
    if [ "$USE_COLOR" -eq 1 ]; then
      color="${gradient[$i]}"
      printf '\033[38;5;%sm%s\033[0m\n' "$color" "$row"
    else
      printf '%s\n' "$row"
    fi
    i=$((i + 1))
  done
  echo
  printf '  %sPRD & prompt vibe coding yang tidak terlihat buatan AI%s\n' "$C_DIM" "$C_RESET"
  printf '  %sInstaller v%s  |  License: CaggyID  |  (c) 2026 CaggyID%s\n' "$C_DIM" "$INSTALLER_VERSION" "$C_RESET"
  echo
}

# ---------------------------------------------------------------- util
die()  { printf '%sERROR:%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; exit 2; }
info() { printf '  %s\n' "$*"; }
ok()   { printf '  %s✓%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
warn() { printf '  %s!%s %s\n' "$C_YELLOW" "$C_RESET" "$*"; }
bad()  { printf '  %s✗%s %s\n' "$C_RED" "$C_RESET" "$*"; }

pretty() {
  case "$1" in
    "$HOME"/*) printf '~%s' "${1#"$HOME"}" ;;
    *)         printf '%s' "$1" ;;
  esac
}

lower() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }

# Lokasi tiap agent. Ubah di sini kalau agent memindahkan folder skill-nya.
#   A_GLOBAL  : folder skill level pengguna (semua proyek)
#   A_PROJECT : folder skill relatif terhadap root proyek
#   A_DETECT  : folder yang menandakan agent sudah terpasang
agent_info() {
  case "$1" in
    claude)
      A_NAME="Claude Code"
      A_GLOBAL="$HOME/.claude/skills";  A_PROJECT=".claude/skills";  A_DETECT="$HOME/.claude" ;;
    codex)
      A_NAME="OpenAI Codex"
      A_GLOBAL="$HOME/.agents/skills";  A_PROJECT=".agents/skills";  A_DETECT="$HOME/.codex" ;;
    antigravity)
      A_NAME="Google Antigravity"
      A_GLOBAL="$HOME/.gemini/antigravity/skills"; A_PROJECT=".agent/skills"; A_DETECT="$HOME/.gemini/antigravity" ;;
    gemini)
      A_NAME="Gemini CLI"
      A_GLOBAL="$HOME/.gemini/skills";  A_PROJECT=".gemini/skills";  A_DETECT="$HOME/.gemini" ;;
    cursor)
      A_NAME="Cursor"
      A_GLOBAL="$HOME/.cursor/skills";  A_PROJECT=".cursor/skills";  A_DETECT="$HOME/.cursor" ;;
    opencode)
      A_NAME="OpenCode"
      A_GLOBAL="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/skills"; A_PROJECT=".opencode/skills"
      A_DETECT="${XDG_CONFIG_HOME:-$HOME/.config}/opencode" ;;
    copilot)
      A_NAME="GitHub Copilot"
      A_GLOBAL="$HOME/.copilot/skills"; A_PROJECT=".github/skills";  A_DETECT="$HOME/.copilot" ;;
    windsurf)
      A_NAME="Windsurf"
      A_GLOBAL="$HOME/.codeium/windsurf/skills"; A_PROJECT=".windsurf/skills"; A_DETECT="$HOME/.codeium/windsurf" ;;
    cline)
      A_NAME="Cline"
      A_GLOBAL="$HOME/.cline/skills";   A_PROJECT=".cline/skills";   A_DETECT="$HOME/.cline" ;;
    *) return 1 ;;
  esac
  return 0
}

normalize_id() {
  case "$(lower "$1")" in
    claude|claude-code|claudecode|cc)      echo claude ;;
    codex|openai|openai-codex)             echo codex ;;
    antigravity|agy|anti|google-antigravity) echo antigravity ;;
    gemini|gemini-cli|geminicli)           echo gemini ;;
    cursor)                                echo cursor ;;
    opencode|open-code)                    echo opencode ;;
    copilot|github-copilot|gh-copilot)     echo copilot ;;
    windsurf|codeium)                      echo windsurf ;;
    cline)                                 echo cline ;;
    all|semua)                             echo all ;;
    *)                                     echo "" ;;
  esac
}

target_base() {  # $1 = id ; hasil: folder induk tempat "slopguard" dipasang
  if [ "$1" = "custom" ]; then
    printf '%s' "$CUSTOM_DIR"
    return
  fi
  agent_info "$1" || return 1
  if [ "$SCOPE" = "project" ]; then
    printf '%s/%s' "$PROJECT_DIR" "$A_PROJECT"
  else
    printf '%s' "$A_GLOBAL"
  fi
}

has_selected() {
  case " $SELECTED " in *" $1 "*) return 0 ;; *) return 1 ;; esac
}

add_selected() {
  has_selected "$1" || SELECTED="${SELECTED:+$SELECTED }$1"
}

add_agents() {  # "claude,codex antigravity"
  local raw tok id
  raw="$(printf '%s' "$1" | tr ',' ' ')"
  for tok in $raw; do
    id="$(normalize_id "$tok")"
    [ -n "$id" ] || die "agent tidak dikenal: '$tok'. Jalankan ./install.sh --list untuk daftar agent."
    if [ "$id" = "all" ]; then ALL=1; else add_selected "$id"; fi
  done
}

# ---------------------------------------------------------------- bantuan
usage() {
  cat <<EOF
Pemakaian: ./install.sh [opsi]

Tanpa opsi, muncul menu untuk memilih agent.

Pilih agent:
  -a, --agent LIST     Daftar dipisah koma, mis. claude,codex,antigravity
      --all            Semua agent yang didukung
  -d, --dir PATH       Pasang ke folder skill lain (agent yang belum ada di daftar)

Lokasi pemasangan:
  -g, --global         Level pengguna, berlaku di semua proyek (default)
  -p, --project        Level proyek, di folder kerja saat ini
      --project-dir D  Level proyek, di folder D

Perilaku:
  -s, --symlink        Buat symlink ke repo ini, bukan salin (update otomatis ikut)
  -u, --uninstall      Hapus slopguard dari agent yang dipilih
  -n, --dry-run        Tampilkan yang akan dilakukan tanpa mengubah apa pun
  -y, --yes            Lewati pertanyaan konfirmasi
  -l, --list           Tampilkan daftar agent dan lokasinya, lalu keluar
  -h, --help           Bantuan ini

Agent yang didukung:
  claude, codex, antigravity, gemini, cursor, opencode, copilot, windsurf, cline

Contoh:
  ./install.sh -a claude,codex
  ./install.sh --all -y
  ./install.sh -a antigravity -p            # hanya untuk proyek ini
  ./install.sh -a claude --uninstall
  ./install.sh -d ~/skills-saya

Catatan:
  Hanya folder "$SKILL_NAME" di dalam folder skill agent yang disentuh. File skill
  lain milikmu tidak dihapus atau diubah. Restart agent setelah pemasangan.
EOF
}

list_agents() {
  local id mark
  printf '  %-4s %-20s %-8s %s\n' "No" "Agent" "Status" "Lokasi global"
  printf '  %s\n' "------------------------------------------------------------------"
  local n=1
  for id in $AGENT_IDS; do
    agent_info "$id"
    if [ -d "$A_DETECT" ]; then mark="${C_GREEN}ada${C_RESET}"; else mark="${C_DIM}-${C_RESET}"; fi
    printf '  %-4s %-20s %-17b %s\n' "$n" "$A_NAME" "$mark" "$(pretty "$A_GLOBAL")"
    n=$((n + 1))
  done
  echo
  info "Lokasi proyek: .claude/skills, .agents/skills, .agent/skills, .gemini/skills, dst."
  info "(jalankan dengan --project untuk memakainya)"
}

# ---------------------------------------------------------------- menu
detected_ids() {
  local id out=""
  for id in $AGENT_IDS; do
    agent_info "$id"
    [ -d "$A_DETECT" ] && out="${out:+$out }$id"
  done
  printf '%s' "$out"
}

menu() {
  local id n choice tok picked det base
  if ! ( : </dev/tty ) 2>/dev/null; then
    die "tidak ada terminal interaktif. Pakai --agent claude,codex atau --all."
  fi
  det="$(detected_ids)"

  printf '  %sPilih agent tujuan%s  %s(%s)%s\n\n' "$C_BOLD" "$C_RESET" "$C_DIM" \
    "$([ "$SCOPE" = project ] && echo "proyek: $(pretty "$PROJECT_DIR")" || echo "global")" "$C_RESET"

  n=1
  for id in $AGENT_IDS; do
    agent_info "$id"
    base="$(target_base "$id")"
    if [ -d "$A_DETECT" ]; then
      printf '   %s[%d]%s %-20s %s%s%s  %s✓ terdeteksi%s\n' "$C_CYAN" "$n" "$C_RESET" "$A_NAME" \
        "$C_DIM" "$(pretty "$base")" "$C_RESET" "$C_GREEN" "$C_RESET"
    else
      printf '   %s[%d]%s %-20s %s%s%s\n' "$C_CYAN" "$n" "$C_RESET" "$A_NAME" \
        "$C_DIM" "$(pretty "$base")" "$C_RESET"
    fi
    n=$((n + 1))
  done
  echo
  info "Ketik nomor dipisah koma (mis. ${C_BOLD}1,2,3${C_RESET}), ${C_BOLD}all${C_RESET} untuk semua,"
  info "Enter untuk yang terdeteksi, atau ${C_BOLD}q${C_RESET} untuk batal."
  echo
  printf '  > '
  read -r choice </dev/tty || choice="q"

  choice="$(lower "$choice" | tr ',' ' ')"
  if [ -z "$choice" ]; then
    if [ -z "$det" ]; then
      echo
      warn "Tidak ada agent yang terdeteksi. Pilih nomor secara manual."
      exit 1
    fi
    for id in $det; do add_selected "$id"; done
    return
  fi

  for tok in $choice; do
    case "$tok" in
      q|quit|keluar|batal) echo; info "Dibatalkan."; exit 0 ;;
      all|semua|a)         ALL=1 ;;
      *[!0-9]*)
        picked="$(normalize_id "$tok")"
        [ -n "$picked" ] || die "pilihan tidak dikenal: '$tok'"
        if [ "$picked" = "all" ]; then ALL=1; else add_selected "$picked"; fi ;;
      *)
        n=1; picked=""
        for id in $AGENT_IDS; do
          [ "$n" -eq "$tok" ] && picked="$id"
          n=$((n + 1))
        done
        [ -n "$picked" ] || die "nomor di luar daftar: $tok"
        add_selected "$picked" ;;
    esac
  done
}

confirm() {
  local ans
  [ "$ASSUME_YES" -eq 1 ] && return 0
  [ "$FROM_MENU" -eq 1 ] || return 0
  printf '\n  Lanjut? [Y/n] '
  read -r ans </dev/tty || ans="n"
  case "$(lower "$ans")" in ""|y|ya|yes) return 0 ;; *) info "Dibatalkan."; exit 0 ;; esac
}

# ---------------------------------------------------------------- aksi
safe_remove() {  # hanya menghapus path yang berakhir di /slopguard
  case "$1" in
    */"$SKILL_NAME") rm -rf -- "$1" ;;
    *) return 1 ;;
  esac
}

install_one() {
  local id="$1" name base target item copied=0
  if [ "$id" = "custom" ]; then name="Folder kustom"; else agent_info "$id"; name="$A_NAME"; fi
  base="$(target_base "$id")" || { bad "$name: lokasi tidak ditemukan"; return 1; }
  target="$base/$SKILL_NAME"

  if [ "$SCOPE" = "project" ] && [ "$id" != "custom" ] && [ ! -d "$PROJECT_DIR" ]; then
    bad "$name: folder proyek tidak ada ($(pretty "$PROJECT_DIR"))"; return 1
  fi

  if [ "$ACTION" = "uninstall" ]; then
    if [ -e "$target" ] || [ -L "$target" ]; then
      if [ "$DRY" -eq 1 ]; then info "[dry-run] hapus $(pretty "$target")"; return 0; fi
      if safe_remove "$target"; then ok "$name: dihapus dari $(pretty "$target")"; else bad "$name: gagal menghapus"; return 1; fi
    else
      info "${C_DIM}-${C_RESET} $name: tidak terpasang di $(pretty "$target")"
    fi
    return 0
  fi

  local verb="dipasang"
  { [ -e "$target" ] || [ -L "$target" ]; } && verb="diperbarui"

  if [ "$DRY" -eq 1 ]; then
    info "[dry-run] $name: $([ "$MODE" = link ] && echo symlink || echo salin) -> $(pretty "$target")"
    return 0
  fi

  mkdir -p "$base" 2>/dev/null || { bad "$name: tidak bisa membuat $(pretty "$base")"; return 1; }
  if [ "$verb" = "diperbarui" ]; then safe_remove "$target" || { bad "$name: gagal mengganti versi lama"; return 1; }; fi

  if [ "$MODE" = "link" ]; then
    ln -s "$SRC" "$target" 2>/dev/null || { bad "$name: gagal membuat symlink (di Windows pakai mode salin)"; return 1; }
  else
    mkdir -p "$target" || { bad "$name: tidak bisa membuat $(pretty "$target")"; return 1; }
    for item in $PAYLOAD; do
      if [ -e "$SRC/$item" ]; then
        cp -R "$SRC/$item" "$target/" || { bad "$name: gagal menyalin $item"; return 1; }
        copied=$((copied + 1))
      fi
    done
  fi

  if [ -f "$target/SKILL.md" ]; then
    ok "$name: $verb  ${C_DIM}$(pretty "$target")${C_RESET}"
  else
    bad "$name: SKILL.md tidak ditemukan setelah pemasangan"; return 1
  fi
  return 0
}

# ---------------------------------------------------------------- main
SELECTED=""; ALL=0; SCOPE="global"; PROJECT_DIR="$PWD"; MODE="copy"
ACTION="install"; DRY=0; ASSUME_YES=0; CUSTOM_DIR=""; LIST=0; FROM_MENU=0

while [ $# -gt 0 ]; do
  case "$1" in
    -a|--agent)
      [ $# -ge 2 ] || die "$1 butuh nilai, mis. $1 claude,codex"
      add_agents "$2"; shift 2 ;;
    --agent=*)       add_agents "${1#*=}"; shift ;;
    --all)           ALL=1; shift ;;
    -d|--dir)
      [ $# -ge 2 ] || die "$1 butuh path folder"
      CUSTOM_DIR="$2"; shift 2 ;;
    --dir=*)         CUSTOM_DIR="${1#*=}"; shift ;;
    -g|--global)     SCOPE="global"; shift ;;
    -p|--project)    SCOPE="project"; shift ;;
    --project-dir)
      [ $# -ge 2 ] || die "$1 butuh path folder"
      SCOPE="project"; PROJECT_DIR="$2"; shift 2 ;;
    -s|--symlink)    MODE="link"; shift ;;
    -u|--uninstall)  ACTION="uninstall"; shift ;;
    -n|--dry-run)    DRY=1; shift ;;
    -y|--yes)        ASSUME_YES=1; shift ;;
    -l|--list)       LIST=1; shift ;;
    -h|--help)       banner; usage; exit 0 ;;
    *)               die "opsi tidak dikenal: $1 (coba --help)" ;;
  esac
done

# Folder kustom: ~ di awal diperluas, path dijadikan absolut.
if [ -n "$CUSTOM_DIR" ]; then
  case "$CUSTOM_DIR" in "~"|"~/"*) CUSTOM_DIR="$HOME${CUSTOM_DIR#\~}" ;; esac
  case "$CUSTOM_DIR" in /*) ;; *) CUSTOM_DIR="$PWD/$CUSTOM_DIR" ;; esac
fi
[ -d "$PROJECT_DIR" ] && PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

banner

if [ "$LIST" -eq 1 ]; then list_agents; exit 0; fi

[ -f "$SRC/SKILL.md" ] || die "SKILL.md tidak ditemukan di $(pretty "$SRC"). Jalankan install.sh dari dalam folder repo SlopGuard."

if [ "$ALL" -eq 1 ]; then
  SELECTED=""
  for id in $AGENT_IDS; do add_selected "$id"; done
fi
[ -n "$CUSTOM_DIR" ] && add_selected "custom"

if [ -z "$SELECTED" ]; then
  FROM_MENU=1
  menu
  if [ "$ALL" -eq 1 ]; then
    for id in $AGENT_IDS; do add_selected "$id"; done
  fi
fi

[ -n "$SELECTED" ] || die "tidak ada agent yang dipilih."

# Urutkan sesuai daftar resmi supaya keluaran konsisten.
ORDERED=""
for id in $AGENT_IDS custom; do has_selected "$id" && ORDERED="${ORDERED:+$ORDERED }$id"; done

echo
if [ "$ACTION" = "uninstall" ]; then
  printf '  %sMenghapus%s' "$C_BOLD" "$C_RESET"
else
  printf '  %sMemasang%s' "$C_BOLD" "$C_RESET"
fi
printf ' %s ke %d agent  %s(%s, %s)%s\n' "$SKILL_NAME" "$(echo "$ORDERED" | wc -w | tr -d ' ')" "$C_DIM" \
  "$([ "$SCOPE" = project ] && echo "proyek" || echo "global")" \
  "$([ "$MODE" = link ] && echo "symlink" || echo "salin")" "$C_RESET"
[ "$DRY" -eq 1 ] && warn "mode dry-run: tidak ada yang diubah"

confirm
echo

FAILED=0; DONE=0
for id in $ORDERED; do
  if install_one "$id"; then DONE=$((DONE + 1)); else FAILED=$((FAILED + 1)); fi
done

echo
if [ "$FAILED" -gt 0 ]; then
  printf '  %sSelesai dengan %d kegagalan.%s\n' "$C_RED" "$FAILED" "$C_RESET"
  exit 1
fi

if [ "$DRY" -eq 1 ]; then
  info "Dry-run selesai."
elif [ "$ACTION" = "uninstall" ]; then
  printf '  %sSelesai.%s\n' "$C_GREEN" "$C_RESET"
else
  printf '  %sSelesai. %d agent siap.%s Restart agent-nya, lalu coba:\n\n' "$C_GREEN" "$DONE" "$C_RESET"
  printf '    %s"Bikinkan PRD dan prompt vibe coding untuk website klinik gigi di Surabaya."%s\n\n' "$C_DIM" "$C_RESET"
  info "SlopGuard akan bertanya soal file assets lebih dulu sebelum mengerjakan apa pun."
fi
echo
exit 0

# License: CaggyID
# (c) 2026 CaggyID
#
# SlopGuard installer untuk Windows (PowerShell 5.1 atau lebih baru).
# Padanan dari install.sh. Jalankan dari dalam folder repo ini.
#
#   install                          menu interaktif (lewat install.cmd)
#   install -Agent claude,codex      pilih agent langsung
#   install -All                     semua agent
#   install -List                    daftar agent dan lokasinya
#   install -Help                    bantuan

[CmdletBinding()]
param(
    [string[]]$Agent,
    [switch]$All,
    [string]$Dir,
    [switch]$Project,
    [string]$ProjectDir,
    [switch]$Uninstall,
    [switch]$DryRun,
    [switch]$Yes,
    [switch]$List,
    [switch]$Help,
    [Parameter(ValueFromRemainingArguments = $true)][string[]]$Rest
)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$SkillName = 'slopguard'
$Version   = '1.0.0'
$Payload   = @('SKILL.md', 'LICENSE', 'NOTICE.md', 'references', 'scripts', 'assets', 'third_party')

$Src = $PSScriptRoot
if (-not $Src) { $Src = Split-Path -Parent $MyInvocation.MyCommand.Path }

$HomeDir = $env:USERPROFILE
if (-not $HomeDir) { $HomeDir = $HOME }

# Lokasi tiap agent. Ubah di sini kalau agent memindahkan folder skill-nya.
#   Global  : folder skill level pengguna (semua proyek)
#   Project : folder skill relatif terhadap root proyek
#   Detect  : folder yang menandakan agent sudah terpasang
$Agents = @(
    @{ Id = 'claude';      Name = 'Claude Code';        Global = (Join-Path $HomeDir '.claude\skills');                  Project = '.claude\skills';   Detect = (Join-Path $HomeDir '.claude') },
    @{ Id = 'codex';       Name = 'OpenAI Codex';       Global = (Join-Path $HomeDir '.agents\skills');                  Project = '.agents\skills';   Detect = (Join-Path $HomeDir '.codex') },
    @{ Id = 'antigravity'; Name = 'Google Antigravity'; Global = (Join-Path $HomeDir '.gemini\antigravity\skills');      Project = '.agent\skills';    Detect = (Join-Path $HomeDir '.gemini\antigravity') },
    @{ Id = 'gemini';      Name = 'Gemini CLI';         Global = (Join-Path $HomeDir '.gemini\skills');                  Project = '.gemini\skills';   Detect = (Join-Path $HomeDir '.gemini') },
    @{ Id = 'cursor';      Name = 'Cursor';             Global = (Join-Path $HomeDir '.cursor\skills');                  Project = '.cursor\skills';   Detect = (Join-Path $HomeDir '.cursor') },
    @{ Id = 'opencode';    Name = 'OpenCode';           Global = (Join-Path $HomeDir '.config\opencode\skills');         Project = '.opencode\skills'; Detect = (Join-Path $HomeDir '.config\opencode') },
    @{ Id = 'copilot';     Name = 'GitHub Copilot';     Global = (Join-Path $HomeDir '.copilot\skills');                 Project = '.github\skills';   Detect = (Join-Path $HomeDir '.copilot') },
    @{ Id = 'windsurf';    Name = 'Windsurf';           Global = (Join-Path $HomeDir '.codeium\windsurf\skills');        Project = '.windsurf\skills'; Detect = (Join-Path $HomeDir '.codeium\windsurf') },
    @{ Id = 'cline';       Name = 'Cline';              Global = (Join-Path $HomeDir '.cline\skills');                   Project = '.cline\skills';    Detect = (Join-Path $HomeDir '.cline') }
)

# ---------------------------------------------------------------- tampilan
function Show-Banner {
    $rows = @(
        '███████╗██╗      ██████╗ ██████╗  ██████╗ ██╗   ██╗ █████╗ ██████╗ ██████╗ ',
        '██╔════╝██║     ██╔═══██╗██╔══██╗██╔════╝ ██║   ██║██╔══██╗██╔══██╗██╔══██╗',
        '███████╗██║     ██║   ██║██████╔╝██║  ███╗██║   ██║███████║██████╔╝██║  ██║',
        '╚════██║██║     ██║   ██║██╔═══╝ ██║   ██║██║   ██║██╔══██║██╔══██╗██║  ██║',
        '███████║███████╗╚██████╔╝██║     ╚██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝',
        '╚══════╝╚══════╝ ╚═════╝ ╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ '
    )
    $colors = @('Magenta', 'Magenta', 'DarkMagenta', 'Blue', 'Cyan', 'Cyan')
    Write-Host ''
    for ($i = 0; $i -lt $rows.Count; $i++) {
        Write-Host $rows[$i] -ForegroundColor $colors[$i]
    }
    Write-Host ''
    Write-Host '  PRD & prompt vibe coding yang tidak terlihat buatan AI' -ForegroundColor DarkGray
    Write-Host "  Installer v$Version  |  License: CaggyID  |  (c) 2026 CaggyID" -ForegroundColor DarkGray
    Write-Host ''
}

function Write-Ok($msg)   { Write-Host '  ' -NoNewline; Write-Host '[OK]' -ForegroundColor Green -NoNewline; Write-Host " $msg" }
function Write-Bad($msg)  { Write-Host '  ' -NoNewline; Write-Host '[X] ' -ForegroundColor Red -NoNewline; Write-Host " $msg" }
function Write-Warn($msg) { Write-Host '  ' -NoNewline; Write-Host '[!] ' -ForegroundColor Yellow -NoNewline; Write-Host " $msg" }
function Write-Info($msg) { Write-Host "  $msg" }

function Stop-Fatal($msg) {
    Write-Host ''
    Write-Host "  ERROR: $msg" -ForegroundColor Red
    Write-Host ''
    exit 2
}

function Get-PrettyPath($p) {
    if ($p -and $p.StartsWith($HomeDir, [System.StringComparison]::OrdinalIgnoreCase)) {
        return '~' + $p.Substring($HomeDir.Length)
    }
    return $p
}

function Show-Usage {
    @"
Pemakaian: install [opsi]      (atau: powershell -ExecutionPolicy Bypass -File .\install.ps1 [opsi])

Tanpa opsi, muncul menu untuk memilih agent.

Pilih agent:
  -Agent LIST        Daftar dipisah koma, mis. claude,codex,antigravity
  -All               Semua agent yang didukung
  -Dir PATH          Pasang ke folder skill lain (agent yang belum ada di daftar)

Lokasi pemasangan:
  (default)          Level pengguna, berlaku di semua proyek
  -Project           Level proyek, di folder kerja saat ini
  -ProjectDir D      Level proyek, di folder D

Perilaku:
  -Uninstall         Hapus slopguard dari agent yang dipilih
  -DryRun            Tampilkan yang akan dilakukan tanpa mengubah apa pun
  -Yes               Lewati pertanyaan konfirmasi
  -List              Daftar agent dan lokasinya
  -Help              Bantuan ini

Agent yang didukung:
  claude, codex, antigravity, gemini, cursor, opencode, copilot, windsurf, cline
  (singkatan: cc = claude, agy = antigravity)

Contoh:
  install -Agent claude,codex
  install -All -Yes
  install -Agent antigravity -Project
  install -Agent claude -Uninstall
  install -Dir C:\skills-saya

Hanya folder "$SkillName" di dalam folder skill agent yang disentuh. Skill lain
milikmu tidak dihapus atau diubah. Restart agent setelah pemasangan.
"@ | Write-Host
}

# ---------------------------------------------------------------- util
function ConvertTo-AgentId([string]$text) {
    switch ($text.ToLower().Trim()) {
        { $_ -in @('claude', 'claude-code', 'claudecode', 'cc') }                  { return 'claude' }
        { $_ -in @('codex', 'openai', 'openai-codex') }                            { return 'codex' }
        { $_ -in @('antigravity', 'agy', 'anti', 'google-antigravity') }           { return 'antigravity' }
        { $_ -in @('gemini', 'gemini-cli', 'geminicli') }                          { return 'gemini' }
        'cursor'                                                                    { return 'cursor' }
        { $_ -in @('opencode', 'open-code') }                                      { return 'opencode' }
        { $_ -in @('copilot', 'github-copilot', 'gh-copilot') }                    { return 'copilot' }
        { $_ -in @('windsurf', 'codeium') }                                        { return 'windsurf' }
        'cline'                                                                     { return 'cline' }
        { $_ -in @('all', 'semua') }                                               { return 'all' }
        default                                                                     { return '' }
    }
}

function Get-AgentById([string]$id) {
    foreach ($a in $Agents) { if ($a.Id -eq $id) { return $a } }
    return $null
}

$Selected = New-Object System.Collections.ArrayList
function Add-Selected([string]$id) {
    if (-not $Selected.Contains($id)) { [void]$Selected.Add($id) }
}

function Add-AgentTokens($tokens) {
    foreach ($raw in $tokens) {
        if (-not $raw) { continue }
        foreach ($tok in ($raw -split '[,\s]+')) {
            if (-not $tok) { continue }
            $id = ConvertTo-AgentId $tok
            if (-not $id) { Stop-Fatal "agent tidak dikenal: '$tok'. Jalankan: install -List" }
            if ($id -eq 'all') { $script:All = [switch]$true } else { Add-Selected $id }
        }
    }
}

function Get-TargetBase([string]$id) {
    if ($id -eq 'custom') { return $script:CustomDir }
    $a = Get-AgentById $id
    if ($script:UseProject) { return (Join-Path $script:ProjectRoot $a.Project) }
    return $a.Global
}

function Get-DetectedIds {
    $out = @()
    foreach ($a in $Agents) { if (Test-Path -LiteralPath $a.Detect) { $out += $a.Id } }
    return $out
}

function Show-AgentList {
    '{0,-4} {1,-20} {2,-8} {3}' -f 'No', 'Agent', 'Status', 'Lokasi global' | ForEach-Object { Write-Host "  $_" }
    Write-Host '  ------------------------------------------------------------------'
    $n = 1
    foreach ($a in $Agents) {
        $status = '-'
        if (Test-Path -LiteralPath $a.Detect) { $status = 'ada' }
        Write-Host ('  {0,-4} {1,-20} {2,-8} {3}' -f $n, $a.Name, $status, (Get-PrettyPath $a.Global))
        $n++
    }
    Write-Host ''
    Write-Info 'Lokasi proyek: .claude\skills, .agents\skills, .agent\skills, .gemini\skills, dst.'
    Write-Info '(jalankan dengan -Project untuk memakainya)'
}

function Read-AgentMenu {
    $scopeText = 'global'
    if ($script:UseProject) { $scopeText = 'proyek: ' + (Get-PrettyPath $script:ProjectRoot) }
    Write-Host "  Pilih agent tujuan  ($scopeText)" -ForegroundColor White
    Write-Host ''
    $n = 1
    foreach ($a in $Agents) {
        $base = Get-PrettyPath (Get-TargetBase $a.Id)
        Write-Host '   ' -NoNewline
        Write-Host ("[{0}]" -f $n) -ForegroundColor Cyan -NoNewline
        Write-Host (" {0,-20} " -f $a.Name) -NoNewline
        Write-Host $base -ForegroundColor DarkGray -NoNewline
        if (Test-Path -LiteralPath $a.Detect) {
            Write-Host '  [terdeteksi]' -ForegroundColor Green
        } else {
            Write-Host ''
        }
        $n++
    }
    Write-Host ''
    Write-Info 'Ketik nomor dipisah koma (mis. 1,2,3), all untuk semua,'
    Write-Info 'Enter untuk yang terdeteksi, atau q untuk batal.'
    Write-Host ''
    $choice = Read-Host '  >'
    if ($null -eq $choice) { $choice = 'q' }
    $choice = $choice.ToLower().Trim()

    if (-not $choice) {
        $det = Get-DetectedIds
        if ($det.Count -eq 0) {
            Write-Host ''
            Write-Warn 'Tidak ada agent yang terdeteksi. Pilih nomor secara manual.'
            exit 1
        }
        foreach ($id in $det) { Add-Selected $id }
        return
    }

    foreach ($tok in ($choice -split '[,\s]+')) {
        if (-not $tok) { continue }
        if ($tok -in @('q', 'quit', 'keluar', 'batal')) { Write-Host ''; Write-Info 'Dibatalkan.'; exit 0 }
        if ($tok -in @('all', 'semua', 'a')) { $script:All = [switch]$true; continue }
        if ($tok -match '^\d+$') {
            $idx = [int]$tok
            if ($idx -lt 1 -or $idx -gt $Agents.Count) { Stop-Fatal "nomor di luar daftar: $tok" }
            Add-Selected $Agents[$idx - 1].Id
            continue
        }
        $id = ConvertTo-AgentId $tok
        if (-not $id) { Stop-Fatal "pilihan tidak dikenal: '$tok'" }
        if ($id -eq 'all') { $script:All = [switch]$true } else { Add-Selected $id }
    }
}

# ---------------------------------------------------------------- aksi
function Remove-SkillDir([string]$path) {
    if ((Split-Path -Leaf $path) -ne $SkillName) { throw "menolak menghapus path yang bukan '$SkillName': $path" }
    Remove-Item -LiteralPath $path -Recurse -Force
}

function Install-One([string]$id) {
    if ($id -eq 'custom') { $name = 'Folder kustom' } else { $name = (Get-AgentById $id).Name }
    $base   = Get-TargetBase $id
    $target = Join-Path $base $SkillName
    $exists = Test-Path -LiteralPath $target

    if ($script:UseProject -and $id -ne 'custom' -and -not (Test-Path -LiteralPath $script:ProjectRoot)) {
        Write-Bad "${name}: folder proyek tidak ada ($(Get-PrettyPath $script:ProjectRoot))"
        return $false
    }

    if ($Uninstall) {
        if (-not $exists) {
            Write-Info "-  ${name}: tidak terpasang di $(Get-PrettyPath $target)"
            return $true
        }
        if ($DryRun) { Write-Info "[dry-run] hapus $(Get-PrettyPath $target)"; return $true }
        try {
            Remove-SkillDir $target
            Write-Ok "${name}: dihapus dari $(Get-PrettyPath $target)"
            return $true
        } catch {
            Write-Bad "${name}: gagal menghapus ($($_.Exception.Message))"
            return $false
        }
    }

    if ($DryRun) {
        Write-Info "[dry-run] ${name}: salin -> $(Get-PrettyPath $target)"
        return $true
    }

    $verb = 'dipasang'
    if ($exists) { $verb = 'diperbarui' }

    try {
        if (-not (Test-Path -LiteralPath $base)) { New-Item -ItemType Directory -Path $base -Force | Out-Null }
        if ($exists) { Remove-SkillDir $target }
        New-Item -ItemType Directory -Path $target -Force | Out-Null
        foreach ($item in $Payload) {
            $from = Join-Path $Src $item
            if (Test-Path -LiteralPath $from) {
                Copy-Item -LiteralPath $from -Destination $target -Recurse -Force
            }
        }
    } catch {
        Write-Bad "${name}: gagal ($($_.Exception.Message))"
        return $false
    }

    if (Test-Path -LiteralPath (Join-Path $target 'SKILL.md')) {
        Write-Ok "${name}: $verb  $(Get-PrettyPath $target)"
        return $true
    }
    Write-Bad "${name}: SKILL.md tidak ditemukan setelah pemasangan"
    return $false
}

# ---------------------------------------------------------------- main
if ($Help) { Show-Banner; Show-Usage; exit 0 }

$UseProject = [bool]($Project -or $ProjectDir)
if ($ProjectDir) { $ProjectRoot = $ProjectDir } else { $ProjectRoot = (Get-Location).Path }
if (Test-Path -LiteralPath $ProjectRoot) { $ProjectRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path }

$CustomDir = ''
if ($Dir) {
    $CustomDir = $Dir
    if ($CustomDir -eq '~' -or $CustomDir.StartsWith('~\') -or $CustomDir.StartsWith('~/')) {
        $CustomDir = $HomeDir + $CustomDir.Substring(1)
    }
    if (-not [System.IO.Path]::IsPathRooted($CustomDir)) {
        $CustomDir = Join-Path (Get-Location).Path $CustomDir
    }
}

Show-Banner

if ($List) { Show-AgentList; exit 0 }

if (-not (Test-Path -LiteralPath (Join-Path $Src 'SKILL.md'))) {
    Stop-Fatal "SKILL.md tidak ditemukan di $(Get-PrettyPath $Src). Jalankan install dari dalam folder repo SlopGuard."
}

if ($Agent)  { Add-AgentTokens $Agent }
if ($Rest)   { Add-AgentTokens $Rest }
if ($CustomDir) { Add-Selected 'custom' }

$FromMenu = $false
if ($All) {
    foreach ($a in $Agents) { Add-Selected $a.Id }
}
if ($Selected.Count -eq 0) {
    $FromMenu = $true
    Read-AgentMenu
    if ($All) { foreach ($a in $Agents) { Add-Selected $a.Id } }
}
if ($Selected.Count -eq 0) { Stop-Fatal 'tidak ada agent yang dipilih.' }

$Ordered = @()
foreach ($a in $Agents) { if ($Selected.Contains($a.Id)) { $Ordered += $a.Id } }
if ($Selected.Contains('custom')) { $Ordered += 'custom' }

Write-Host ''
$act = 'Memasang'
if ($Uninstall) { $act = 'Menghapus' }
$scopeText = 'global'
if ($UseProject) { $scopeText = 'proyek' }
Write-Host "  $act $SkillName ke $($Ordered.Count) agent  ($scopeText, salin)" -ForegroundColor White
if ($DryRun) { Write-Warn 'mode dry-run: tidak ada yang diubah' }

if ($FromMenu -and -not $Yes) {
    Write-Host ''
    $ans = Read-Host '  Lanjut? [Y/n]'
    if ($null -eq $ans) { $ans = 'n' }
    if ($ans.Trim().ToLower() -notin @('', 'y', 'ya', 'yes')) { Write-Info 'Dibatalkan.'; exit 0 }
}
Write-Host ''

$failed = 0; $done = 0
foreach ($id in $Ordered) {
    if (Install-One $id) { $done++ } else { $failed++ }
}

Write-Host ''
if ($failed -gt 0) {
    Write-Host "  Selesai dengan $failed kegagalan." -ForegroundColor Red
    exit 1
}

if ($DryRun) {
    Write-Info 'Dry-run selesai.'
} elseif ($Uninstall) {
    Write-Host '  Selesai.' -ForegroundColor Green
} else {
    Write-Host "  Selesai. $done agent siap." -ForegroundColor Green -NoNewline
    Write-Host ' Restart agent-nya, lalu coba:'
    Write-Host ''
    Write-Host '    "Bikinkan PRD dan prompt vibe coding untuk website klinik gigi di Surabaya."' -ForegroundColor DarkGray
    Write-Host ''
    Write-Info 'SlopGuard akan bertanya soal file assets lebih dulu sebelum mengerjakan apa pun.'
}
Write-Host ''
exit 0

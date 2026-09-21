# Kéo bộ khung sdlc-harness về máy (cài plugin Claude Code một lần, dùng cho mọi dự án).
# Dùng:  irm https://raw.githubusercontent.com/yutobeo2024/Codding-framework/main/scripts/bootstrap.ps1 | iex
#        & ([scriptblock]::Create((irm <url>))) -Yes    # không hỏi, tự git init
#        & ([scriptblock]::Create((irm <url>))) -Init   # sau khi cài, mở Claude Code và chạy /sdlc:init --vibe
[CmdletBinding()]
param([switch]$Yes, [switch]$Init)
$ErrorActionPreference = "Stop"

$MarketName = "sdlc-harness"
$MarketSrc  = "yutobeo2024/Codding-framework"
$Plugin     = "sdlc"

function Fail([string]$m) { Write-Host "LỖI: $m" -ForegroundColor Red; exit 1 }
function Has([string]$cmd) { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

# 1. Kiểm tra công cụ
if (-not (Has "claude")) { Fail "chưa có Claude Code. Cài theo https://code.claude.com/docs/en/setup rồi chạy lại." }
if (-not (Has "git"))    { Fail "chưa có git. Cài từ https://git-scm.com (kèm Git Bash, hook cần bash) rồi chạy lại." }
if (-not (Has "bash"))   { Fail "chưa thấy bash (Git Bash). Cài Git for Windows và bật 'Add to PATH' rồi chạy lại." }
$jsonOk = Has "jq"
if (-not $jsonOk) {
  foreach ($py in @("python3", "python")) {
    if (Has $py) { & $py -c "import json" 2>$null; if ($LASTEXITCODE -eq 0) { $jsonOk = $true; break } }
  }
}
if (-not $jsonOk) { Fail "hook của plugin cần jq hoặc python. Cài Python từ python.org (tick 'Add to PATH') rồi chạy lại." }
Write-Host "✓ Công cụ: claude $((claude --version 2>$null | Select-Object -First 1)), git, bash, trình đọc JSON"

# 2. Marketplace (idempotent)
$markets = (claude plugin marketplace list 2>$null) -join "`n"
if ($markets -match [regex]::Escape($MarketName)) {
  Write-Host "✓ Marketplace $MarketName đã có, cập nhật..."
  claude plugin marketplace update $MarketName *> $null
} else {
  Write-Host "→ Thêm marketplace $MarketSrc ..."
  claude plugin marketplace add $MarketSrc *> $null
  if ($LASTEXITCODE -ne 0) { Fail "không thêm được marketplace $MarketSrc" }
  Write-Host "✓ Đã thêm marketplace $MarketName"
}

# 3. Plugin (scope user)
$plugins = (claude plugin list 2>$null) -join "`n"
if ($plugins -match [regex]::Escape("${Plugin}@${MarketName}")) {
  Write-Host "✓ Plugin ${Plugin}@${MarketName} đã cài"
} else {
  Write-Host "→ Cài plugin ${Plugin}@${MarketName} ..."
  claude plugin install "${Plugin}@${MarketName}" -s user *> $null
  if ($LASTEXITCODE -ne 0) { Fail "không cài được plugin ${Plugin}@${MarketName}" }
  Write-Host "✓ Đã cài plugin $Plugin"
}

# 4. Git repo cho thư mục hiện tại
git rev-parse --is-inside-work-tree 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
  $doInit = $Yes
  if (-not $Yes -and [Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
    $ans = Read-Host "Thư mục hiện tại chưa phải kho git. Khởi tạo (để lưu mốc và hoàn tác)? [Y/n]"
    if ($ans -eq "" -or $ans -match "^[Yy]") { $doInit = $true }
  }
  if ($doInit) { git init -q; Write-Host "✓ Đã git init ở $(Get-Location)" }
  else { Write-Host "  Bỏ qua git init (/sdlc:init sẽ tự làm)." }
} else {
  Write-Host "✓ Thư mục hiện tại đã là kho git"
}

Write-Host ""
Write-Host "Xong. Bước tiếp theo trong thư mục dự án:"
Write-Host "  claude"
Write-Host "  /sdlc:init --vibe        # cài lõi Harness + sdlc vào dự án (một lần)"
Write-Host "  /sdlc:vibe <bạn muốn app làm gì>"
Write-Host "Hoàn tác: /sdlc:undo   ·   Quy tắc cứng: /sdlc:rule   ·   Cập nhật lõi: /sdlc:update"

if ($Init) {
  Write-Host ""; Write-Host "→ Mở Claude Code và chạy /sdlc:init --vibe ..."
  claude "/sdlc:init --vibe"
}

# Keo bo khung sdlc-harness ve may (cai plugin Claude Code mot lan, dung cho moi du an).
# Dung:  irm https://raw.githubusercontent.com/yutobeo2024/Codding-framework/main/scripts/bootstrap.ps1 | iex
#        & ([scriptblock]::Create((irm <url>))) -Yes    # khong hoi, tu git init
#        & ([scriptblock]::Create((irm <url>))) -Init   # sau khi cai, mo Claude Code va chay /sdlc:init --vibe
[CmdletBinding()]
param([switch]$Yes, [switch]$Init)
# "Continue": loi cua lenh ngoai (stderr) khong duoc bien thanh exception; script tu kiem tra $LASTEXITCODE.
$ErrorActionPreference = "Continue"

$MarketName = "sdlc-harness"
$MarketSrc  = "yutobeo2024/Codding-framework"
$Plugin     = "sdlc"

function Fail([string]$m) { Write-Host "LOI: $m" -ForegroundColor Red; exit 1 }
function Has([string]$cmd) { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

# 1. Kiem tra cong cu
if (-not (Has "claude")) { Fail "chua co Claude Code. Cai theo https://code.claude.com/docs/en/setup roi chay lai." }
if (-not (Has "git"))    { Fail "chua co git. Cai tu https://git-scm.com (kem Git Bash, hook can bash) roi chay lai." }
if (-not (Has "bash"))   { Fail "chua thay bash (Git Bash). Cai Git for Windows va bat 'Add to PATH' roi chay lai." }
$jsonOk = Has "jq"
if (-not $jsonOk) {
  foreach ($py in @("python3", "python")) {
    if (Has $py) { & $py -c "import json" 2>$null; if ($LASTEXITCODE -eq 0) { $jsonOk = $true; break } }
  }
}
if (-not $jsonOk) { Fail "hook cua plugin can jq hoac python. Cai Python tu python.org (tick 'Add to PATH') roi chay lai." }
Write-Host "[OK] Cong cu: claude $((claude --version 2>$null | Select-Object -First 1)), git, bash, trinh doc JSON"

# 2. Marketplace (idempotent)
$markets = (claude plugin marketplace list 2>$null) -join "`n"
if ($markets -match [regex]::Escape($MarketName)) {
  Write-Host "[OK] Marketplace $MarketName da co, cap nhat..."
  claude plugin marketplace update $MarketName *> $null
} else {
  Write-Host "-> Them marketplace $MarketSrc ..."
  claude plugin marketplace add $MarketSrc *> $null
  if ($LASTEXITCODE -ne 0) { Fail "khong them duoc marketplace $MarketSrc" }
  Write-Host "[OK] Da them marketplace $MarketName"
}

# 3. Plugin (scope user)
$plugins = (claude plugin list 2>$null) -join "`n"
if ($plugins -match [regex]::Escape("${Plugin}@${MarketName}")) {
  Write-Host "[OK] Plugin ${Plugin}@${MarketName} da cai"
} else {
  Write-Host "-> Cai plugin ${Plugin}@${MarketName} ..."
  claude plugin install "${Plugin}@${MarketName}" -s user *> $null
  if ($LASTEXITCODE -ne 0) { Fail "khong cai duoc plugin ${Plugin}@${MarketName}" }
  Write-Host "[OK] Da cai plugin $Plugin"
}

# 4. Git repo cho thu muc hien tai
git rev-parse --is-inside-work-tree 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
  $doInit = $Yes
  if (-not $Yes -and [Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
    $ans = Read-Host "Thu muc hien tai chua phai kho git. Khoi tao (de luu moc va hoan tac)? [Y/n]"
    if ($ans -eq "" -or $ans -match "^[Yy]") { $doInit = $true }
  }
  if ($doInit) { git init -q; Write-Host "[OK] Da git init o $(Get-Location)" }
  else { Write-Host "  Bo qua git init (/sdlc:init se tu lam)." }
} else {
  Write-Host "[OK] Thu muc hien tai da la kho git"
}

# 5. Loi Harness (repository-harness) vao thu muc hien tai - do NGUOI chay, agent khong duoc curl|bash (luat K4)
git rev-parse --is-inside-work-tree 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
  if (Test-Path ".harness-core\manifest.json") {
    Write-Host "[OK] Loi Harness da co trong thu muc nay (cap nhat bang /sdlc:update)"
  } else {
    Write-Host "-> Cai loi Harness (repository-harness) vao $(Get-Location) o che do merge ..."
    try {
      $installer = irm "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.ps1?$(Get-Random)"
      & ([scriptblock]::Create($installer)) -Merge -Yes *> $null
      if (Test-Path ".harness-core\manifest.json") { Write-Host "[OK] Da cai loi Harness" }
      else { Write-Host "  Khong cai duoc loi Harness. Chay lai bootstrap sau; /sdlc:init van dung duoc phan con lai." }
    } catch {
      Write-Host "  Khong cai duoc loi Harness (mang?). Chay lai bootstrap sau; /sdlc:init van dung duoc phan con lai."
    }
  }
}

Write-Host ""
Write-Host "Xong. Buoc tiep theo trong thu muc du an:"
Write-Host "  claude"
Write-Host "  /sdlc:init --vibe        # cai loi Harness + sdlc vao du an (mot lan)"
Write-Host "  /sdlc:vibe <ban muon app lam gi>"
Write-Host "Hoan tac: /sdlc:undo   |   Quy tac cung: /sdlc:rule   |   Cap nhat loi: /sdlc:update"

if ($Init) {
  Write-Host ""; Write-Host "-> Mo Claude Code va chay /sdlc:init --vibe ..."
  claude "/sdlc:init --vibe"
}

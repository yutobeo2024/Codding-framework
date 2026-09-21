# Keo bo khung sdlc-harness ve may (cai plugin Claude Code mot lan) va cai loi Harness vao thu muc du an hien tai.
# CHAY TRONG CUA SO POWERSHELL, SAU KHI cd VAO THU MUC DU AN. Khong go trong Claude Code (o do dau ! chay bang bash).
# Dung:  & ([scriptblock]::Create((irm https://raw.githubusercontent.com/yutobeo2024/Codding-framework/main/scripts/bootstrap.ps1))) -Yes
#        -Yes    khong hoi, tu git init neu chua phai repo
#        -Init   sau khi cai, mo Claude Code va chay luon /sdlc:init --vibe
[CmdletBinding()]
param([switch]$Yes, [switch]$Init)
# "Continue": loi cua lenh ngoai (stderr) khong duoc bien thanh exception; script tu kiem tra $LASTEXITCODE.
$ErrorActionPreference = "Continue"

$MarketName = "sdlc-harness"
$MarketSrc  = "yutobeo2024/Codding-framework"
$Plugin     = "sdlc"
# Trinh cai loi Harness ghim theo tag phat hanh (khong lay tu main).
$HarnessRef  = if ($env:HARNESS_REF) { $env:HARNESS_REF } else { "harness-v0.1.10" }
$HarnessBase = "https://raw.githubusercontent.com/hoangnb24/repository-harness/$HarnessRef"
$Log = ".harness-install.log"

function Fail([string]$m) { Write-Host "LOI: $m" -ForegroundColor Red; exit 1 }
function Has([string]$cmd) { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

# 0. Dung thu muc chua?
$here = (Get-Location).Path.TrimEnd('\')
$userHome = $env:USERPROFILE.TrimEnd('\')
foreach ($bad in @($userHome, "$userHome\Desktop", "$userHome\Documents", "$userHome\Downloads")) {
  if ($here -ieq $bad) { Fail "ban dang o $here, khong phai thu muc du an. Tao thu muc cho du an, cd vao do roi chay lai." }
}

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
  Write-Host "[OK] Plugin ${Plugin}@${MarketName} da cai, cap nhat len ban moi nhat..."
  claude plugin update "${Plugin}@${MarketName}" *> $null
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
    Write-Host "-> Cai loi Harness ($HarnessRef) vao $(Get-Location) o che do merge (log: $Log) ..."
    $direct = "`$env:HARNESS_SOURCE_BASE_URL='$HarnessBase'; & ([scriptblock]::Create((irm $HarnessBase/scripts/install-harness.ps1))) -Merge -Yes"
    $ok = $false
    try {
      $env:HARNESS_SOURCE_BASE_URL = $HarnessBase
      $installer = irm "$HarnessBase/scripts/install-harness.ps1"
      # Khong nuot thong bao: ghi toan bo output vao log de doc duoc khi hong
      & ([scriptblock]::Create($installer)) -Merge -Yes *>&1 | Out-File -FilePath $Log -Encoding utf8
      if (Test-Path ".harness-core\manifest.json") { $ok = $true }
    } catch {
      Add-Content -Path $Log -Value ("EXCEPTION: " + $_.Exception.Message)
    }
    if ($ok) {
      Write-Host "[OK] Da cai loi Harness"
      if (-not (Select-String -Path .gitignore -Pattern "harness-install.log" -Quiet -ErrorAction SilentlyContinue)) {
        [IO.File]::AppendAllText((Join-Path (Get-Location) ".gitignore"), "`n# log cai loi Harness (bootstrap)`n.harness-install.log`n")
      }
      # Luu moc ngay de /sdlc:init khong phai commit code ngoai (bo phan loai cua Claude Code co the chan)
      git add -- .harness-core .agents AGENTS.md docs .gitignore 2>$null
      git commit -q -m "chore(harness): cai loi Harness $HarnessRef" 2>&1 | Out-File -FilePath $Log -Append -Encoding utf8
      if ($LASTEXITCODE -eq 0) { Write-Host "[OK] Da luu moc: chore(harness): cai loi Harness" }
      else { Write-Host "  Chua luu moc duoc (git chua co user.name/email?). Xem $Log. Tu chay: git add -A; git commit -m `"chore(harness): cai loi Harness`"" }
    } else {
      Write-Host "[X] Khong cai duoc loi Harness. Dong cuoi trong ${Log}:" -ForegroundColor Yellow
      if (Test-Path $Log) { Get-Content $Log -Tail 3 | ForEach-Object { "    $_" } }
      Write-Host "  Cai truc tiep de thay du thong bao (dan vao PowerShell, dung trong thu muc nay):"
      Write-Host "    $direct"
    }
  }
}

Write-Host ""
Write-Host "Xong. Buoc tiep theo trong thu muc du an:"
Write-Host "  claude"
Write-Host "  /sdlc:init --vibe        # cai lop an toan + sdlc vao du an (mot lan; loi Harness da cai o tren)"
Write-Host "  /sdlc:vibe <ban muon app lam gi>"
Write-Host "Hoan tac: /sdlc:undo   |   Quy tac cung: /sdlc:rule   |   Cap nhat loi: /sdlc:update"

if ($Init) {
  Write-Host ""; Write-Host "-> Mo Claude Code va chay /sdlc:init --vibe ..."
  claude "/sdlc:init --vibe"
}

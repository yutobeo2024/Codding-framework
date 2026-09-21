#!/usr/bin/env bash
# Kéo bộ khung sdlc-harness về máy (cài plugin Claude Code một lần, dùng cho mọi dự án).
# Dùng:  curl -fsSL https://raw.githubusercontent.com/yutobeo2024/Codding-framework/main/scripts/bootstrap.sh | bash
#        ... | bash -s -- --yes    # không hỏi, tự git init nếu thư mục hiện tại chưa phải repo
#        ... | bash -s -- --init   # sau khi cài, mở Claude Code và chạy luôn /sdlc:init --vibe
set -euo pipefail

MARKET_NAME="sdlc-harness"
MARKET_SRC="yutobeo2024/Codding-framework"
PLUGIN="sdlc"
YES=0; INIT=0
for a in "$@"; do
  case "$a" in
    --yes|-y) YES=1 ;;
    --init) INIT=1 ;;
    -h|--help) sed -n '2,5p' "$0" 2>/dev/null || true; exit 0 ;;
    *) echo "Tham số không hiểu: $a" >&2; exit 1 ;;
  esac
done

say()  { printf '%s\n' "$*"; }
fail() { printf 'LỖI: %s\n' "$*" >&2; exit 1; }

# 1. Kiểm tra công cụ
command -v claude >/dev/null 2>&1 || fail "chưa có Claude Code. Cài theo https://code.claude.com/docs/en/setup rồi chạy lại."
command -v git    >/dev/null 2>&1 || fail "chưa có git. Cài git (Windows: https://git-scm.com) rồi chạy lại."
json_ok=0
if command -v jq >/dev/null 2>&1; then json_ok=1; else
  for py in python3 python; do
    if command -v "$py" >/dev/null 2>&1 && "$py" -c 'import json' >/dev/null 2>&1; then json_ok=1; break; fi
  done
fi
[ "$json_ok" = 1 ] || fail "hook của plugin cần một trong jq, python3, python. Cài một cái rồi chạy lại."
say "✓ Công cụ: claude $(claude --version 2>/dev/null | head -1), git, trình đọc JSON"

# 2. Marketplace (idempotent)
if claude plugin marketplace list 2>/dev/null | grep -q "$MARKET_NAME"; then
  say "✓ Marketplace $MARKET_NAME đã có, cập nhật..."
  claude plugin marketplace update "$MARKET_NAME" >/dev/null 2>&1 || say "  (không cập nhật được, dùng bản đang có)"
else
  say "→ Thêm marketplace $MARKET_SRC ..."
  claude plugin marketplace add "$MARKET_SRC" >/dev/null
  say "✓ Đã thêm marketplace $MARKET_NAME"
fi

# 3. Plugin (scope user: dùng được ở mọi thư mục)
if claude plugin list 2>/dev/null | grep -q "^$PLUGIN@$MARKET_NAME\|$PLUGIN@$MARKET_NAME"; then
  say "✓ Plugin $PLUGIN@$MARKET_NAME đã cài"
else
  say "→ Cài plugin $PLUGIN@$MARKET_NAME ..."
  claude plugin install "$PLUGIN@$MARKET_NAME" -s user >/dev/null
  say "✓ Đã cài plugin $PLUGIN"
fi

# 4. Git repo cho thư mục hiện tại
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  do_init=$YES
  if [ "$YES" = 0 ] && [ -t 0 ]; then
    printf 'Thư mục hiện tại chưa phải kho git. Khởi tạo (để lưu mốc và hoàn tác)? [Y/n] '
    read -r ans; case "${ans:-Y}" in [Yy]*) do_init=1 ;; esac
  fi
  if [ "$do_init" = 1 ]; then git init -q && say "✓ Đã git init ở $(pwd)"; else say "  Bỏ qua git init (/sdlc:init sẽ tự làm)."; fi
else
  say "✓ Thư mục hiện tại đã là kho git"
fi

# 5. Lõi Harness (repository-harness) vào thư mục hiện tại — do NGƯỜI chạy, agent không được curl|bash (luật K4)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [ -f .harness-core/manifest.json ]; then
    say "✓ Lõi Harness đã có trong thư mục này (cập nhật bằng /sdlc:update)"
  else
    say "→ Cài lõi Harness (repository-harness) vào $(pwd) ở chế độ merge ..."
    ok=0
    case "$(uname -s 2>/dev/null)" in
      MINGW*|MSYS*|CYGWIN*)
        # Git Bash trên Windows: installer .sh của upstream không hỗ trợ, dùng bản PowerShell
        if command -v powershell.exe >/dev/null 2>&1; then
          powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \
            "& ([scriptblock]::Create((irm 'https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.ps1?$(date +%s)'))) -Merge -Yes" >/dev/null 2>&1 && ok=1
        fi ;;
      *)
        curl -fsSL "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.sh?$(date +%s)" | bash -s -- --merge --yes >/dev/null 2>&1 && ok=1 ;;
    esac
    if [ "$ok" = 1 ] && [ -f .harness-core/manifest.json ]; then
      say "✓ Đã cài lõi Harness"
    else
      say "  Không cài được lõi Harness (mạng?). Chạy lại bootstrap sau; /sdlc:init vẫn dùng được phần còn lại."
    fi
  fi
fi

say ""
say "Xong. Bước tiếp theo trong thư mục dự án:"
say "  claude"
say "  /sdlc:init --vibe        # cài lõi Harness + sdlc vào dự án (một lần)"
say "  /sdlc:vibe <bạn muốn app làm gì>"
say "Hoàn tác: /sdlc:undo   ·   Quy tắc cứng: /sdlc:rule   ·   Cập nhật lõi: /sdlc:update"

if [ "$INIT" = 1 ]; then
  say ""; say "→ Mở Claude Code và chạy /sdlc:init --vibe ..."
  exec claude "/sdlc:init --vibe"
fi

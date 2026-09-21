#!/bin/bash
# HOOK 1 - Bao ve test khi dang sua bug.
# Khi ton tai file .sdlc/fix-mode trong repo, agent KHONG duoc sua file test
# va khong duoc sua chinh file co nay. Ly do: test that bai duoc commit truoc
# la bang chung bug da het; agent khong duoc lam yeu bang chung do.
# Bat:  /sdlc:build --fix   (lenh tu tao co)
# Tat:  nguoi dung tu chay `rm .sdlc/fix-mode` o terminal cua minh.
source "$(dirname "$0")/_lib.sh"
HOOK_INPUT="$(cat)"
ROOT="$(project_dir)"
FLAG="$ROOT/.sdlc/fix-mode"

file="$(hook_field '.tool_input.file_path')" || hook_block_unreadable
[ -z "$file" ] && { file="$(hook_field '.tool_input.notebook_path')" || hook_block_unreadable; }
[ -z "$file" ] && exit 0
# Duong dan Windows (C:\x\tests\a.py) -> doi sang / de cac mau ben duoi khop
file="${file//\\//}"
[ -f "$FLAG" ] || exit 0

# Khong cho agent tu sua co fix-mode hoac cau hinh mau test
case "$file" in
  *".sdlc/fix-mode"|*".sdlc/test-patterns.txt")
    echo "BI CHAN: dang o fix-mode nen khong duoc sua $file. Chi nguoi dung moi tat fix-mode (rm .sdlc/fix-mode)." >&2
    exit 2 ;;
esac

# Mau file test mac dinh; them mau rieng vao .sdlc/test-patterns.txt (moi dong 1 regex)
patterns='(^|/)(tests?|__tests__|spec|specs|e2e|itest)/|(_test|_spec|\.test|\.spec)\.[A-Za-z0-9]+$|(^|/)test_[^/]+\.py$|(^|/)conftest\.py$|Tests?\.(java|kt|cs)$'
hit=""
if printf '%s' "$file" | grep -Eq "$patterns"; then hit=1; fi
if [ -z "$hit" ] && [ -f "$ROOT/.sdlc/test-patterns.txt" ]; then
  while IFS= read -r p; do
    [ -z "$p" ] && continue
    case "$p" in \#*) continue ;; esac
    if printf '%s' "$file" | grep -Eq "$p"; then hit=1; break; fi
  done < "$ROOT/.sdlc/test-patterns.txt"
fi

if [ -n "$hit" ]; then
  echo "BI CHAN: dang o fix-mode nen khong duoc sua file test ($file). Hay sua code de test pass, khong sua test. Neu test thuc su sai, dung lai va giai thich cho nguoi dung." >&2
  exit 2
fi
exit 0

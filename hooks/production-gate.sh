#!/bin/bash
# HOOK 2 - Cong production.
# Agent duoc lam moi thu DEN TRUOC cong production, khong duoc vuot qua.
# Chan: (a) lenh deploy/release nham vao production khi chua co uy quyen,
#       (b) push thang len nhanh chinh, (c) force push,
#       (d) go co fix-mode bang shell.
# Uy quyen: nguoi phu trach release dat bien RELEASE_APPROVAL=<ma phieu>
# TRUOC khi mo Claude Code, roi tu giam sat buoc cuoi.
source "$(dirname "$0")/_lib.sh"
HOOK_INPUT="$(cat)"
ROOT="$(project_dir)"
cmd="$(hook_field '.tool_input.command')" || hook_block_unreadable
[ -z "$cmd" ] && exit 0

block() { echo "BI CHAN (production-gate): $1" >&2; exit 2; }
has() { printf '%s' "$cmd" | grep -Eiq "$1"; }

# (d) khong cho go co fix-mode bang shell
# Chi chan khi lenh xoa/di chuyen/ghi de NHAM VAO file co; nhac ten file
# (vd. echo ".sdlc/fix-mode" >> .gitignore, cat .sdlc/fix-mode) thi cho qua.
if has '(^|[;&|[:space:]])(rm|mv|unlink|truncate)[[:space:]][^;&|]*\.sdlc/fix-mode'    || has '>[[:space:]]*["'"'"']?[^[:space:];&|"'"'"']*\.sdlc/fix-mode'; then
  block "khong duoc tu tat fix-mode. Nho nguoi dung go /sdlc:fix-done (hoac tu chay: rm .sdlc/fix-mode)"
fi

# (c) force push
if has 'git[[:space:]]+push.*(--force|[[:space:]]-f([[:space:]]|$))'; then
  block "cam force push. Mo PR thay vi ghi de lich su."
fi

# (b) push thang len nhanh chinh
if has 'git[[:space:]]+push.*[[:space:]:](main|master|production|release)([[:space:]]|$)'; then
  block "khong push thang len nhanh chinh. Day len nhanh rieng roi mo PR de code owner duyet."
fi

# (a) deploy vao production
is_deploy=0
if has '(deploy|release|rollout|publish|promote|terraform[[:space:]]+apply|kubectl[[:space:]]+apply|helm[[:space:]]+(upgrade|install))' \
   && has '(^|[^[:alnum:]])(prod|production|live)([^[:alnum:]]|$)'; then is_deploy=1; fi
if has 'vercel.*--prod|npm[[:space:]]+publish'; then is_deploy=1; fi
# Mau rieng cua du an: .sdlc/gate-patterns.txt (moi dong 1 regex)
if [ "$is_deploy" = 0 ] && [ -f "$ROOT/.sdlc/gate-patterns.txt" ]; then
  while IFS= read -r p; do
    [ -z "$p" ] && continue
    case "$p" in \#*) continue ;; esac
    if has "$p"; then is_deploy=1; break; fi
  done < "$ROOT/.sdlc/gate-patterns.txt"
fi

if [ "$is_deploy" = 1 ] && [ -z "$RELEASE_APPROVAL" ]; then
  block "lenh nay cham vao production va chua co uy quyen release. Hay chuan bi ban release (changelog, PR, ket qua test) roi bao nguoi phu trach. Ho se dat RELEASE_APPROVAL=<ma phieu> va giam sat buoc cuoi."
fi
exit 0

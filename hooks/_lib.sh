#!/bin/bash
# Doc mot truong tu JSON cua hook (stdin da luu vao $HOOK_INPUT).
# Uu tien jq, roi python3, roi python (tren Windows "python3" thuong la stub
# cua Microsoft Store: co tren PATH nhung khong chay duoc, nen phai thu that).
# Khong co trinh doc nao thi hook CHAN (fail-closed), khong lang le cho qua.

_hook_python_ok() { "$1" -c 'import json' >/dev/null 2>&1; }

hook_pick_json_tool() {
  if command -v jq >/dev/null 2>&1; then HOOK_JSON_TOOL="jq"; return; fi
  local py
  for py in python3 python; do
    if command -v "$py" >/dev/null 2>&1 && _hook_python_ok "$py"; then
      HOOK_JSON_TOOL="$py"; return
    fi
  done
  HOOK_JSON_TOOL=""
}
hook_pick_json_tool

# hook_field <.duong.dan>
#   in gia tri (rong neu thieu truong), return 0
#   return 2 neu khong co trinh doc JSON, 3 neu JSON hong
hook_field() {
  local path="$1"
  case "$HOOK_JSON_TOOL" in
    "")  return 2 ;;
    jq)  printf '%s' "$HOOK_INPUT" | jq -r "$path // empty" 2>/dev/null || return 3 ;;
    *)   printf '%s' "$HOOK_INPUT" | PYTHONUTF8=1 PYTHONIOENCODING=utf-8 "$HOOK_JSON_TOOL" -c '
import json, sys
path = sys.argv[1].lstrip(".").split(".")
try:
    v = json.load(sys.stdin)
except Exception:
    sys.exit(3)
for p in path:
    v = v.get(p) if isinstance(v, dict) else None
print(v if v is not None else "", end="")
' "$path" || return 3 ;;
  esac
}

# Goi khi hook_field that bai: chan va bao, khong cho qua.
hook_block_unreadable() {
  if [ -z "$HOOK_JSON_TOOL" ]; then
    echo "BI CHAN: khong doc duoc du lieu hook (can jq, python3 hoac python). Cai mot trong ba roi mo lai Claude Code." >&2
  else
    echo "BI CHAN: du lieu hook khong phai JSON hop le (trinh doc: $HOOK_JSON_TOOL)." >&2
  fi
  exit 2
}

project_dir() { printf '%s' "${CLAUDE_PROJECT_DIR:-$(pwd)}"; }

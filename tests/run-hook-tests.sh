#!/bin/bash
# Kiem thu 2 hook. Chay: bash tests/run-hook-tests.sh
H="$(cd "$(dirname "$0")/../hooks" && pwd)"
P="$(mktemp -d)"; mkdir -p "$P/.sdlc"; export CLAUDE_PROJECT_DIR="$P"; unset RELEASE_APPROVAL
fail=0
# t <ten> <rc mong doi> <json> <hook> [regex stderr mong doi]
# Khi mong doi 2 ma khong cho regex: thong bao KHONG duoc la loi doc du lieu
# (tranh "dat" vi ly do sai, vi loi doc du lieu cung tra ve 2).
t() { err="$(printf '%s' "$3" | bash "$H/$4" 2>&1 >/dev/null)"; rc=$?
      if [ "$rc" != "$2" ]; then echo "FAIL  $1 (rc=$rc, mong doi $2)"; fail=1; return; fi
      if [ -n "$5" ]; then
        printf '%s' "$err" | grep -Eq "$5" || { echo "FAIL  $1 (thong bao sai: $err)"; fail=1; return; }
      elif [ "$2" = 2 ] && printf '%s' "$err" | grep -q 'du lieu hook'; then
        echo "FAIL  $1 (chan vi loi doc du lieu, khong phai vi luat: $err)"; fail=1; return
      fi
      echo "PASS  $1"; }
# Sinh JSON bang printf (khong phu thuoc python): escape \ va " trong gia tri
j() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'; }
e() { printf '{"tool_name":"Edit","tool_input":{"file_path":"%s"}}' "$(j "$1")"; }
b() { printf '{"tool_name":"Bash","tool_input":{"command":"%s"}}' "$(j "$1")"; }

t "fix-mode tat: sua test duoc"        0 "$(e src/foo.test.ts)"      protect-tests.sh
touch "$P/.sdlc/fix-mode"
t "fix-mode bat: chan foo.test.ts"     2 "$(e src/foo.test.ts)"      protect-tests.sh
t "fix-mode bat: chan tests/test_x.py" 2 "$(e tests/test_x.py)"      protect-tests.sh
t "fix-mode bat: chan FooTest.java"    2 "$(e src/FooTest.java)"     protect-tests.sh
t "fix-mode bat: cho sua src/foo.ts"   0 "$(e src/foo.ts)"           protect-tests.sh
t "khong nham latest.ts la test"       0 "$(e src/latest.ts)"        protect-tests.sh
t "chan sua co fix-mode"               2 "$(e .sdlc/fix-mode)"       protect-tests.sh
t "windows: chan D:\\proj\\tests\\test_x.py"    2 "$(e 'D:\proj\tests\test_x.py')"    protect-tests.sh
t "windows: chan D:\\proj\\src\\__tests__\\a.ts" 2 "$(e 'D:\proj\src\__tests__\a.ts')" protect-tests.sh
t "windows: chan D:\\proj\\.sdlc\\fix-mode"     2 "$(e 'D:\proj\.sdlc\fix-mode')"     protect-tests.sh
t "windows: cho sua D:\\proj\\src\\foo.ts"      0 "$(e 'D:\proj\src\foo.ts')"         protect-tests.sh

t "make test"                          0 "$(b 'make test')"                        production-gate.sh
t "push nhanh rieng"                   0 "$(b 'git push -u origin fix-main-menu')" production-gate.sh
t "chan push main"                     2 "$(b 'git push origin main')"             production-gate.sh
t "chan push HEAD:main"                2 "$(b 'git push origin HEAD:main')"        production-gate.sh
t "chan force push"                    2 "$(b 'git push -f origin feat')"          production-gate.sh
t "chan deploy production"             2 "$(b './deploy.sh --env production')"     production-gate.sh
t "cho deploy staging"                 0 "$(b './deploy.sh --env staging')"        production-gate.sh
t "chan kubectl apply -n prod"         2 "$(b 'kubectl apply -f k8s/ -n prod')"    production-gate.sh
t "chan npm publish"                   2 "$(b 'npm publish')"                      production-gate.sh
t "khong nham 'product' la prod"       0 "$(b 'grep -r "release product" src/')"   production-gate.sh
t "chan rm fix-mode"                   2 "$(b 'rm .sdlc/fix-mode')"                production-gate.sh
t "chan rm -f duong dan day du"        2 "$(b 'rm -f ./.sdlc/fix-mode')"           production-gate.sh
t "chan mv fix-mode"                   2 "$(b 'mv .sdlc/fix-mode /tmp/x')"          production-gate.sh
t "chan ghi de fix-mode"               2 "$(b 'echo x > .sdlc/fix-mode')"           production-gate.sh
t "chan rm sau &&"                     2 "$(b 'npm test && rm .sdlc/fix-mode')"     production-gate.sh
t "cho ghi ten file vao .gitignore"    0 "$(b 'echo .sdlc/fix-mode >> .gitignore')" production-gate.sh
t "cho doc fix-mode"                   0 "$(b 'cat .sdlc/fix-mode')"                production-gate.sh
t "cho rm file khac trong .sdlc"       0 "$(b 'rm .sdlc/test-patterns.txt')"        production-gate.sh
t "lenh co tieng Viet van bi chan"     2 "$(b 'git commit -m "sửa lỗi" && git push origin main')" production-gate.sh
t "JSON escape \\u2713 van bi chan"    2 '{"tool_name":"Bash","tool_input":{"command":"git push origin main # \u2713"}}' production-gate.sh
t "JSON hong: chan"                    2 'khong phai json'                          production-gate.sh 'khong phai JSON'
export RELEASE_APPROVAL=CHG-123
t "co uy quyen: cho deploy production" 0 "$(b './deploy.sh --env production')"     production-gate.sh
t "co uy quyen: van chan force push"   2 "$(b 'git push --force origin feat')"     production-gate.sh
unset RELEASE_APPROVAL

# Fail-closed: PATH chi co thu muc chua bash (khong thay jq/python) -> hook phai CHAN
BASH_BIN="$(command -v bash)"; BASH_DIR="$(dirname "$BASH_BIN")"
tn() { err="$(printf '%s' "$3" | PATH="$BASH_DIR" "$BASH_BIN" "$H/$4" 2>&1 >/dev/null)"; rc=$?
       if [ "$rc" = "$2" ] && printf '%s' "$err" | grep -q 'khong doc duoc du lieu hook'; then echo "PASS  $1"
       else echo "FAIL  $1 (rc=$rc, mong doi $2; $err)"; fail=1; fi; }
if PATH="$BASH_DIR" "$BASH_BIN" -c 'command -v jq || command -v python3 || command -v python' >/dev/null 2>&1; then
  echo "SKIP  fail-closed (thu muc cua bash van co jq/python)"
else
  tn "khong co trinh doc JSON: gate chan"         2 "$(b 'git push origin main')" production-gate.sh
  tn "khong co trinh doc JSON: protect-tests chan" 2 "$(e src/foo.test.ts)"       protect-tests.sh
fi

rm -rf "$P"
. "$H/_lib.sh"; echo "Trinh doc JSON da dung: ${HOOK_JSON_TOOL:-KHONG CO}"
[ "$fail" = 0 ] && echo "TAT CA DAT" || { echo "CO LOI"; exit 1; }

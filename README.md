# sdlc — AI-native SDLC harness cho Claude Code

Đóng gói 6 giai đoạn (Plan → Design → Build → Test → Deploy → Maintain) thành một plugin:
lệnh cho từng giai đoạn, chuỗi artifact trong git, và 2 hook cưỡng chế.

```
/sdlc:intent ──► intent.md ──► /sdlc:spec ──► spec.md ──► /sdlc:plan ──► plan.md
      ▲            (duyệt)                     (duyệt)                    (duyệt)
      │                                                                      │
/sdlc:triage ◄── sự cố / ticket ◄── production ◄── PR ◄── /sdlc:review ◄── /sdlc:build
```

Mỗi mũi tên "duyệt" là một cổng: con người đổi `status: accepted`, agent không tự duyệt.

## Cài đặt

Thử cục bộ (không cần đẩy lên git):
```bash
claude --plugin-dir /duong/dan/toi/sdlc-harness
```

Dùng cho cả đội: đẩy thư mục này lên một repo git, rồi trong Claude Code:
```
/plugin marketplace add <org>/<repo>
/plugin install sdlc@sdlc-harness
```
Sau khi sửa hook hoặc agent: chạy `/reload-plugins` hoặc mở lại Claude Code.
Yêu cầu: `bash`, và một trong `jq`, `python3`, `python` (hook tự chọn cái chạy được).
Trên Windows, `python3` thường chỉ là stub của Microsoft Store nên hook sẽ tự thử `python`.
Nếu không có trình đọc JSON nào, hook **chặn** mọi thao tác Edit/Bash và báo lỗi, không lặng lẽ cho qua.
Đường dẫn Windows (`C:\...\tests\x.py`) được nhận diện như đường dẫn `/`.
Cú pháp lệnh plugin có thể đổi theo phiên bản: https://code.claude.com/docs/en/plugins

## Dùng thế nào

| Lệnh | Giai đoạn | Đầu ra |
|------|-----------|--------|
| `/sdlc:init` | thiết lập một lần cho repo | `sdlc/`, `.sdlc/`, `CLAUDE.md`, `REVIEW.md` |
| `/sdlc:intent <ý tưởng>` | 1 Plan | `sdlc/<slug>/intent.md` |
| `/sdlc:spec <slug>` | 2 Design | `sdlc/<slug>/spec.md` (có "Điểm đáng lo") |
| `/sdlc:plan <slug>` | 3 Build | `sdlc/<slug>/plan.md`, chưa sửa code |
| `/sdlc:build <slug> [--fix]` | 3+4 Build, Test | code + test + output kiểm chứng |
| `/sdlc:review [slug]` | 5 Deploy | phát hiện theo 3 lượt, không tự duyệt |
| `/sdlc:triage <ticket/log>` | 6 Maintain | PR nhỏ hoặc `intent.md` mới |
| `/sdlc:quick <việc nhỏ>` | đường tắt | plan ngắn + test, tự từ chối nếu việc lớn |

Thành phần khác:
- Skills: `artifact-chain` (quy ước + template), `grill` (phỏng vấn), `tdd-loop` (đỏ → xanh → dọn)
- Subagents: `verifier` (kiểm chứng độc lập), `reviewer` (review 3 lượt)

## Hai hook

**1. `protect-tests.sh`** — khi có file `.sdlc/fix-mode`, chặn agent sửa file test (và chặn sửa chính cờ này).
`/sdlc:build --fix` tự bật cờ sau khi test đỏ đã commit. Tắt cờ: BẠN chạy `rm .sdlc/fix-mode` ở terminal của mình.
Thêm mẫu file test riêng: `.sdlc/test-patterns.txt`, mỗi dòng một regex.

**2. `production-gate.sh`** — chặn lệnh shell: deploy/release vào production khi chưa có `RELEASE_APPROVAL`, push thẳng `main|master|production|release`, force push, và gỡ cờ fix-mode.
Cấp quyền release: `RELEASE_APPROVAL=CHG-123 claude` (đặt TRƯỚC khi mở phiên). Force push luôn bị chặn.
Thêm mẫu lệnh deploy riêng: `.sdlc/gate-patterns.txt`, mỗi dòng một regex.

Kiểm thử hook: `bash tests/run-hook-tests.sh`

> Hook là lưới an toàn ở máy lập trình viên, KHÔNG thay cho kiểm soát phía máy chủ.
> So khớp bằng regex thì luôn có cách lách (script bọc ngoài, alias). Vẫn phải bật branch
> protection và giữ credentials production ngoài tầm với của agent.

## Phần plugin KHÔNG làm được (cấu hình ở hạ tầng)

- Branch protection + bắt buộc code owner duyệt PR (GitHub/GitLab)
- Workflow CI: chạy test, review tự động, evals khi `CLAUDE.md` / `.claude/**` thay đổi
- Script giám sát tất định + metrics cho khâu Maintain (`bands.yaml` chỉ là mẫu cấu hình)
- Managed settings cấp tổ chức (sandbox, deny đọc secrets, chỉ cho phép hook được quản lý)

## Quan hệ với mattpocock/skills

Plugin này tự chứa: `grill` và `tdd-loop` được viết mới theo cùng ý tưởng phổ biến (phỏng vấn từng câu, TDD),
không sao chép nội dung của repo đó. Muốn dùng thêm bộ của Matt Pocock (MIT), cài song song:
```bash
npx skills@latest add mattpocock/skills
```
Gợi ý ghép: `grill-me` thay cho `grill` ở `/sdlc:intent`; `to-prd` hỗ trợ `/sdlc:spec`;
`to-issues` tách `plan.md` thành issue; `tdd` thay cho `tdd-loop`; `triage` + `diagnose` hỗ trợ `/sdlc:triage`.
Phần mà plugin này bổ sung: cổng `status: accepted` giữa các giai đoạn, truy vết bằng commit, và 2 hook.

## Tuỳ biến nên làm đầu tiên

1. Sửa `skills/artifact-chain/templates/*` cho khớp cách đội bạn viết yêu cầu.
2. Viết skill chính sách riêng (bảo mật API, thương hiệu...) để `/sdlc:spec` nạp vào.
3. Điền `REVIEW.md`: file sinh tự động cần bỏ qua, định nghĩa "Quan trọng".
4. Thêm mẫu lệnh deploy thật của bạn vào `.sdlc/gate-patterns.txt`.

## Đo hiệu quả (lấy từ git, không cần công cụ mới)

- Thời gian intent → spec → plan → merge: `git log --grep "(<slug>)" --format="%ad %s"`
- Làm lại yêu cầu: số commit `spec(<slug>)` xuất hiện SAU commit `plan(<slug>)` đầu tiên
- Tỉ lệ PR qua CI ngay lần đầu, số vòng sửa mỗi PR, thời gian review mỗi PR

## Giấy phép
MIT. Ý tưởng quy trình dựa trên "The AI-Native SDLC playbook" của Anthropic (08/2026).

# sdlc — AI-native SDLC harness cho Claude Code

Đóng gói 6 giai đoạn (Plan → Design → Build → Test → Deploy → Maintain) thành một plugin:
lệnh cho từng giai đoạn, chuỗi artifact trong git, và 2 hook cưỡng chế.
Nền bên dưới là lõi [repository-harness](https://github.com/hoangnb24/repository-harness)
(`AGENTS.md`, `docs/`, skill onboarding và encode-invariant, bộ cập nhật merge 3 chiều).
`/sdlc:init` cài cả hai lớp.

## Dành cho người không biết code

```
/sdlc:vibe tôi muốn danh sách việc cần làm có nút xoá
```

Bạn chỉ trả lời câu hỏi về sản phẩm (muốn gì, cho ai, đúng/sai trông ra sao) và duyệt
bảng **"Khi xong bạn sẽ thấy…"**. Agent lo phần còn lại: code, test, git (nhánh riêng,
lưu mốc sau mỗi bước chạy đúng), mở app lên và chụp màn hình để bạn tự xác nhận.

| Lệnh | Khi nào |
|------|---------|
| `/sdlc:vibe <mong muốn>` | mọi việc: tính năng mới, sửa lỗi, hỏi đáp |
| `/sdlc:undo` | muốn quay về mốc trước (không mất gì, có nhánh sao lưu) |
| `/sdlc:rule "<không bao giờ được…>"` | biến một quy tắc thành kiểm tra tự động |
| `/sdlc:fix-done` | tắt chế độ bảo vệ test sau khi sửa lỗi |

Điều agent **sẽ dừng lại hỏi**: khi còn nhiều cách làm cho ra hành vi khác nhau mà bạn
nhìn thấy được (agent đưa 2–3 lựa chọn kèm đề xuất). Điều agent **không hỏi lại**: những gì
bạn đã chọn ở các lần trước, vì chúng được ghi ở `docs/product/` và `docs/decisions/`.
Việc dài được ghi ở `docs/plans/active/` để phiên sau làm tiếp nếu giữa chừng bị ngắt.

Hook vẫn chặn agent push thẳng lên `main`, force push, và deploy production.
Với tính năng nhạy cảm (đăng nhập, thanh toán, dữ liệu cá nhân), agent sẽ khuyên nhờ
một kỹ sư xem trước khi đưa cho người dùng thật.

### An toàn (OWASP LLM Top 10 + Agentic Top 10, ghép từ "Khung An Toàn AI Agent")

`/sdlc:init` cài bộ luật `an-toan/` (mã K/N/L/A) làm **thẩm quyền** mà agent phải tuân theo, cộng
ổ khóa thật `.claude/settings.json` (chặn đọc `.env`, chặn `curl`/`sudo`/`rm -rf`/force push, hỏi trước khi cài
thư viện hay push). Luật áp dụng theo tỉ lệ: việc chạm đăng nhập, dữ liệu, AI, tool, upload, mạng, thư viện mới
thì phải có bằng chứng trong `SECURITY-REPORT.md`; sửa chữ, đổi giao diện thì không thêm thủ tục.

| Lệnh | Khi nào |
|------|---------|
| `/sdlc:audit` | phiên mới rà từng luật, chấm ĐẠT/CHƯA ĐẠT kèm bằng chứng, kết luận được ra mắt chưa |
| `/sdlc:attack` | agent đóng vai kẻ xấu thử phá bản thử nghiệm, test lưu ở `tests/security/` |
| `/sdlc:launch` | cổng ra mắt: agent chỉ bằng chứng, bạn tick `CHECKLIST-RA-MAT.md` |
| `/sdlc:incident` | nghi bị tấn công: dừng, xoay khóa, giữ log, điều tra chỉ đọc |

Đọc `an-toan/HUONG-DAN-CHU-DU-AN.md` (5 phút) sau khi init. Ba chỗ hai bộ từng cấn nhau đã được ghi thành ngoại lệ
trong `an-toan/LUAT-CHUNG.md`: `/sdlc:undo` dùng `git reset --hard` (chỉ người gõ, có nhánh sao lưu),
`RELEASE_APPROVAL` chỉ cho chế độ kỹ sư (vibe không deploy), và lõi Harness do người cài qua bootstrap chứ không phải agent.

```
/sdlc:intent ──► intent.md ──► /sdlc:spec ──► spec.md ──► /sdlc:plan ──► plan.md
      ▲            (duyệt)                     (duyệt)                    (duyệt)
      │                                                                      │
/sdlc:triage ◄── sự cố / ticket ◄── production ◄── PR ◄── /sdlc:review ◄── /sdlc:build
```

Mỗi mũi tên "duyệt" là một cổng: con người đổi `status: accepted`, agent không tự duyệt.

## Bắt đầu dự án mới (kéo bộ khung về bằng một lệnh)

Mở terminal trong thư mục dự án (trống cũng được), chạy **một** dòng:

```bash
# macOS / Linux / Git Bash
curl -fsSL https://raw.githubusercontent.com/yutobeo2024/Codding-framework/main/scripts/bootstrap.sh | bash
```
```powershell
# Windows PowerShell
irm https://raw.githubusercontent.com/yutobeo2024/Codding-framework/main/scripts/bootstrap.ps1 | iex
```

Script kiểm tra công cụ, cài plugin `sdlc` một lần cho cả máy (scope user), `git init` nếu cần, và cài
lõi repository-harness vào thư mục hiện tại (chế độ merge). Việc cài lõi do **bạn** chạy chứ không phải agent,
đúng luật K4 (agent không được `curl | bash`). Chạy lại lần sau chỉ cập nhật, không hỏi gì.
Thêm `--init` / `-Init` để mở Claude Code và chạy luôn bước sau.

Rồi trong thư mục dự án:
```
claude
/sdlc:init --vibe          # cài lõi Harness + sdlc vào dự án này (một lần)
/sdlc:vibe tôi muốn ...    # bắt đầu làm
```

## Cài đặt thủ công

Thử cục bộ (không cần đẩy lên git):
```bash
claude --plugin-dir /duong/dan/toi/Codding-framework
```

Qua marketplace, trong Claude Code:
```
/plugin marketplace add yutobeo2024/Codding-framework
/plugin install sdlc@sdlc-harness
```
Hoặc ngoài terminal: `claude plugin marketplace add yutobeo2024/Codding-framework && claude plugin install sdlc@sdlc-harness -s user`.
Sau khi sửa hook hoặc agent: chạy `/reload-plugins` hoặc mở lại Claude Code.
Yêu cầu: `bash`, và một trong `jq`, `python3`, `python` (hook tự chọn cái chạy được).
Trên Windows, `python3` thường chỉ là stub của Microsoft Store nên hook sẽ tự thử `python`.
Nếu không có trình đọc JSON nào, hook **chặn** mọi thao tác Edit/Bash và báo lỗi, không lặng lẽ cho qua.
Đường dẫn Windows (`C:\...\tests\x.py`) được nhận diện như đường dẫn `/`.
Cú pháp lệnh plugin có thể đổi theo phiên bản: https://code.claude.com/docs/en/plugins

## Dùng thế nào

| Lệnh | Giai đoạn | Đầu ra |
|------|-----------|--------|
| `/sdlc:init [--vibe\|--engineer]` | thiết lập một lần cho repo | lõi Harness (`AGENTS.md`, `docs/`, `.agents/skills/`, `scripts/bin/harness`), `sdlc/`, `.sdlc/`, `CLAUDE.md`, `REVIEW.md`, `docs/runbook.md` |
| `/sdlc:intent <ý tưởng>` | 1 Plan | `sdlc/<slug>/intent.md` |
| `/sdlc:spec <slug>` | 2 Design | `sdlc/<slug>/spec.md` (có "Điểm đáng lo") |
| `/sdlc:plan <slug>` | 3 Build | `sdlc/<slug>/plan.md`, chưa sửa code |
| `/sdlc:build <slug> [--fix]` | 3+4 Build, Test | code + test + output kiểm chứng |
| `/sdlc:review [slug]` | 5 Deploy | phát hiện theo 3 lượt, không tự duyệt |
| `/sdlc:triage <ticket/log>` | 6 Maintain | PR nhỏ hoặc `intent.md` mới |
| `/sdlc:quick <việc nhỏ>` | đường tắt | plan ngắn + test, tự từ chối nếu việc lớn |
| `/sdlc:vibe <mong muốn>` | chế độ nontech | `docs/product/<slug>.md`, plan ở `docs/plans/`, nhánh `vibe/<slug>` |
| `/sdlc:undo [n]` | hoàn tác | quay về mốc trước, giữ nhánh sao lưu |
| `/sdlc:rule <quy tắc>` | encode-invariant | decision + kiểm tra tự động có bằng chứng hai chiều |
| `/sdlc:onboard [phạm vi]` | repo có sẵn | khảo sát chỉ đọc → đề xuất runbook/tài liệu |
| `/sdlc:improve <ma sát>` | bảo trì hướng dẫn | sửa nhỏ nhất + chạy lại bằng agent mới |
| `/sdlc:update` | bảo trì lõi | `harness update` merge 3 chiều, giải thích xung đột |
| `/sdlc:fix-done` | sau khi sửa lỗi | gỡ cờ fix-mode (chỉ người dùng gõ được) |
| `/sdlc:audit [phạm vi]` | an toàn | subagent `security-auditor` chấm theo luật K/N/L/A, cập nhật `SECURITY-REPORT.md` |
| `/sdlc:attack [nhóm]` | an toàn | test tấn công mô phỏng ở `tests/security/`, bằng chứng hai chiều |
| `/sdlc:launch` | an toàn | đi từng mục `CHECKLIST-RA-MAT.md`, người dùng tick |
| `/sdlc:incident <dấu hiệu>` | an toàn | 4 việc làm ngay + điều tra chỉ đọc |

Thành phần khác:
- Skills của plugin: `artifact-chain` (quy ước + template), `grill` (phỏng vấn), `tdd-loop` (đỏ → xanh → dọn), `an-toan` (luật OWASP + template an toàn)
- Skills của lõi Harness (trong repo đích, `.agents/skills/`): `encode-invariant`, `onboard-repository`,
  `audit-onboarding-proposal`, `improve-harness`. Các lệnh `/sdlc:rule`, `/sdlc:onboard`, `/sdlc:improve`
  chỉ là lớp mỏng bảo agent làm theo skill đó, nên `harness update` vẫn cập nhật được nội dung.
- Subagents: `verifier` (kiểm chứng độc lập), `reviewer` (review 3 lượt), `security-auditor` (kiểm tra bảo mật độc lập)

## Hai chế độ, một nơi plan

| | Vibe (`/sdlc:vibe`) | Kỹ sư (`/sdlc:intent`…) |
|---|---|---|
| Ai duyệt gì | bảng "Khi xong bạn sẽ thấy…" + lựa chọn sản phẩm | `status: accepted` trên intent/spec/plan |
| Ý định, tiêu chí | `docs/product/<slug>.md` | `sdlc/<slug>/intent.md`, `spec.md` |
| Plan | `docs/plans/active/<slug>.md` (chỉ khi việc dài) | `sdlc/<slug>/plan.md` |
| Quyết định lâu dài | `docs/decisions/` | trong `spec.md` (nên ghi thêm vào `docs/decisions/`) |
| Git | agent tự tạo nhánh `vibe/<slug>`, commit mốc | người dùng commit theo `intent(<slug>)…` |

Quy tắc chung lấy từ Harness: quy trình tỉ lệ với cỡ việc; dừng khi còn quyết định sản phẩm
(mặc định của công cụ không phải thẩm quyền); chỉ báo xong khi có bằng chứng quan sát được.

## Hai hook

**1. `protect-tests.sh`** — khi có file `.sdlc/fix-mode`, chặn agent sửa file test (và chặn sửa chính cờ này).
`/sdlc:build --fix` tự bật cờ sau khi test đỏ đã commit. Tắt cờ: BẠN gõ `/sdlc:fix-done` (lệnh có
`disable-model-invocation: true` nên agent không gọi được; cờ được xoá lúc mở rộng lệnh bằng cú pháp
`` !`…` ``, không qua công cụ Bash nên không cần nới hook) hoặc chạy `rm .sdlc/fix-mode` ở terminal của mình.
Nếu bạn đặt `disableSkillShellExecution: true` trong settings thì `/sdlc:fix-done` không xoá được, dùng cách thứ hai.
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

# sdlc — AI-native SDLC harness cho Claude Code

Đóng gói 6 giai đoạn (Plan → Design → Build → Test → Deploy → Maintain) thành một plugin:
lệnh cho từng giai đoạn, chuỗi artifact trong git, và 2 hook cưỡng chế.
Nền bên dưới là lõi [repository-harness](https://github.com/hoangnb24/repository-harness)
(`AGENTS.md`, `docs/`, skill onboarding và encode-invariant, bộ cập nhật merge 3 chiều).
`/sdlc:init` cài cả hai lớp.

## Hướng dẫn 5 phút — bắt đầu một dự án mới từ đầu

Dành cho người không biết code. Bạn chỉ quyết định **sản phẩm** (muốn gì, cho ai, đúng/sai trông ra sao);
agent lo code, test, git và bằng chứng.

### Chuẩn bị (một lần trên máy)
Cần **Claude Code**, **git** (Windows: Git for Windows, kèm Git Bash) và **Python hoặc jq** (hook cần để đọc JSON).
Script ở bước 1 tự kiểm tra và báo thiếu gì.

### Bước 1 — Kéo khung về (1 lệnh, trong thư mục dự án)
Ba điều quan trọng trước khi chạy:
1. Chạy trong **cửa sổ PowerShell / Terminal riêng**, KHÔNG gõ trong Claude Code (ở đó dấu `!` chạy bằng bash nên lệnh PowerShell sẽ lỗi).
2. **`cd` vào thư mục dự án trước** (tạo thư mục trống nếu chưa có). Script tự dừng nếu bạn đang ở thư mục người dùng, Desktop, Documents hay Downloads.
3. Không có dấu `!` ở đầu lệnh.

```powershell
# Windows PowerShell
cd D:\du-an\ten-du-an
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/yutobeo2024/Codding-framework/main/scripts/bootstrap.ps1))) -Yes
```
```bash
# macOS / Linux / Git Bash
cd ~/du-an/ten-du-an
curl -fsSL https://raw.githubusercontent.com/yutobeo2024/Codding-framework/main/scripts/bootstrap.sh | bash -s -- --yes
```
Nếu buộc phải chạy từ trong Claude Code (đang ở đúng thư mục dự án):
```
! powershell -NoProfile -ExecutionPolicy Bypass -Command "& ([scriptblock]::Create((irm https://raw.githubusercontent.com/yutobeo2024/Codding-framework/main/scripts/bootstrap.ps1))) -Yes"
```

Script làm 5 việc: cài plugin `sdlc` cho cả máy (lần sau chỉ cập nhật), `git init`, **cài lõi
repository-harness vào thư mục này** (ghim theo tag phát hành; do bạn chạy, đúng luật K4 nên agent không bao giờ
phải `curl | bash`), và **lưu mốc git** cho lõi. Toàn bộ output của trình cài lõi được ghi vào `.harness-install.log`;
khi hỏng, script in 3 dòng cuối của log và lệnh cài trực tiếp để bạn thấy đủ thông báo.
Thêm `--init` / `-Init` để mở Claude Code và chạy luôn bước 2.
Lõi phải được cài và lưu mốc **trước** bước 2: sau khi `/sdlc:init` bật ổ khóa quyền, bộ phân loại lệnh của Claude Code
có thể chặn agent commit "code ngoài" (`.harness-core/`, `harness.exe`).

### Bước 2 — Khởi tạo dự án (một lần cho mỗi dự án)
```
claude
/sdlc:init --vibe
```
Lần đầu mở Claude trong thư mục, bấm **chấp nhận trust**. Agent sẽ:
- hỏi bạn có sẵn **PRD / mô tả sản phẩm** không (dán vào là agent tự xếp cấp và lưu vào `docs/product/`); không có thì hỏi tối đa 3 câu có/không để xếp **cấp dự án** (app có gọi AI? AI có tra cứu tài liệu riêng? AI có tự làm việc như gửi mail, sửa dữ liệu?) và một câu về **dữ liệu cá nhân / sức khỏe**;
- tạo `AGENTS.md`, `CLAUDE.md`, `an-toan/`, `SECURITY-REPORT.md`, `.env.example`, `docs/`, bộ khung test tối thiểu;
- commit mốc đầu, rồi **cuối cùng** ghi ổ khóa `.claude/settings.json`.

Từ đây agent bị chặn đọc `.env`, chạy `curl`/`sudo`/`rm -rf`/force push, phải hỏi bạn trước khi cài thư viện hay
push, và không dùng được chế độ bỏ qua quyền. Sửa file thì không hỏi. **Đó là chủ ý.**

Kiểm tra nhanh (phép thử 30 giây): mở phiên mới, hỏi *"Bạn đang tuân thủ bộ luật nào? K3 nói gì?"*
→ trả lời "không chạm production" là luật đã nạp.

### Bước 3 — Làm việc: chỉ một lệnh
```
/sdlc:vibe tôi muốn một trang ghi chi tiêu hằng ngày, có tổng theo tháng
```
Mỗi tính năng là một lần `/sdlc:vibe`. Agent sẽ:
1. **Hỏi bạn từng câu một** về sản phẩm (ai dùng, "tốt hơn" trông ra sao, cái gì không làm). Không hỏi câu kỹ thuật.
2. Đưa bảng **"Khi xong bạn sẽ thấy…"** (3–7 tình huống bằng lời bạn) → bạn sửa/đồng ý. Đây là **cổng duyệt duy nhất** của bạn.
3. Nếu còn lựa chọn làm ra hành vi khác nhau (ví dụ: xóa là mất luôn hay vào thùng rác?) → dừng, đưa 2–3 lựa chọn kèm đề xuất.
   Lựa chọn lâu dài được ghi vào `docs/decisions/` nên **lần sau không hỏi lại**.
4. Tự làm trên nhánh `vibe/<tên>`, viết test trước, **lưu mốc** sau mỗi bước chạy đúng.
5. Kết thúc bằng báo cáo: tình huống nào ✅/❌ kèm ảnh, **"Bạn tự thử thế này"**, phần chưa làm. Không có bằng chứng thì không được nói "xong".
6. Hỏi "Gộp vào bản chính chưa?"

| Lệnh phụ | Khi nào |
|------|---------|
| `/sdlc:undo` | muốn quay về mốc trước (không mất gì, luôn có nhánh sao lưu) |
| `/sdlc:rule "không bao giờ được xóa việc chưa làm"` | biến một câu "cấm" thành kiểm tra tự động |
| `/sdlc:fix-done` | sau khi sửa lỗi xong, tắt chế độ bảo vệ test |
| `/sdlc:vibe sửa lỗi: bấm nút X thì …` | sửa lỗi (agent viết test tái hiện trước) |

Việc dài, bị ngắt giữa chừng: mở phiên mới, gõ lại `/sdlc:vibe <cùng chủ đề>` — agent đọc `docs/plans/active/` và làm tiếp.
Với tính năng nhạy cảm (đăng nhập, thanh toán, dữ liệu cá nhân), agent sẽ khuyên nhờ một kỹ sư xem trước khi đưa cho người dùng thật.

### Bước 4 — Trước khi cho người thật dùng
```
/sdlc:audit      # phiên mới rà từng luật, chấm ĐẠT/CHƯA ĐẠT kèm bằng chứng
/sdlc:attack     # agent đóng vai kẻ xấu thử phá bản thử nghiệm
/sdlc:launch     # đi từng mục checklist; agent chỉ bằng chứng, BẠN tick
```
Chưa qua `/sdlc:launch` → chưa có người dùng thật, chưa có dữ liệu thật. Deploy do **bạn tự bấm**, agent không làm (K3).

### Việc chỉ bạn làm được (agent không làm thay)
- Tạo khóa API riêng cho từng dự án, **bật trần chi tiêu cứng trước khi tạo khóa**.
- Không dán khóa/mật khẩu/dữ liệu khách thật vào khung chat. Điền `.env` bằng tay (agent bị chặn đọc file này).
- Bật 2FA cho GitHub/cloud/nhà cung cấp AI. Có sao lưu và đã thử khôi phục một lần.
- Đọc `an-toan/HUONG-DAN-CHU-DU-AN.md` (5 phút).

### Bảo trì
- `/sdlc:update`: cập nhật lõi Harness (merge 3 chiều, không mất phần bạn đã chỉnh).
- Chạy lại lệnh bootstrap bất kỳ lúc nào: cập nhật plugin lên bản mới nhất.
- Nghi bị tấn công: `/sdlc:incident`. Lỗi thường: `/sdlc:triage`.
- Agent cứ lặp lại cùng một kiểu sai: `/sdlc:improve <mô tả>` (dành cho người bảo trì).

Kỹ sư hoặc làm việc theo đội: dùng `/sdlc:init --engineer` và chuỗi `/sdlc:intent` → `spec` → `plan` → `build` → `review`
(xem sơ đồ bên dưới). Hai chế độ dùng chung repo được, chỉ khác nơi lưu plan.

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

## Cài đặt thủ công (không dùng bootstrap)

Dòng bootstrap ở "Hướng dẫn 5 phút" là cách khuyến nghị. Nếu muốn tự làm:

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

## Lỗi đã biết (ở phần ngoài plugin)

- **Trình cài lõi repository-harness (PowerShell)**: dòng cuối luôn in `Created: 0, updated: 0, skipped: 0` dù đã tạo hàng chục file (bộ đếm không tính file do `harness.exe` tạo). Bỏ qua dòng này; nhìn `harness status`.
- **`-RefreshAgentShim` của trình cài đó** đọc/ghi `AGENTS.md` không chỉ định encoding → trên PowerShell 5.1 làm hỏng tiếng Việt. Bootstrap và `/sdlc:init` không dùng cờ này; khối HARNESS thiếu thì `/sdlc:init` tự chèn từ `.harness-core/base/AGENTS.md`.
- **Bộ phân loại lệnh của Claude Code** (không phải `settings.json`) có thể chặn `harness.exe doctor` ("Code from External") hoặc commit `.harness-core/` ("Untrusted Code Integration") sau khi ổ khóa quyền bật. Vì vậy bootstrap lưu mốc lõi trước; nếu vẫn bị chặn, bạn gõ `! git add -A && git commit -m "chore(harness): cài lõi Harness"` trong Claude Code.

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

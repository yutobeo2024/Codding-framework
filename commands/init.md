---
description: Cài harness vào repo hiện tại (lõi repository-harness + sdlc/, .sdlc/, AGENTS.md, CLAUDE.md, REVIEW.md, runbook)
argument-hint: "[--vibe | --engineer] (mặc định: hỏi)"
---
Tham số: $ARGUMENTS

Thiết lập harness cho repo này. Gồm hai lớp:
- **Lõi Harness** (repository-harness, không phụ thuộc agent nào): `AGENTS.md`, `docs/WORKFLOW.md`, `docs/product|decisions|plans|templates`, skill `.agents/skills/*`, và file chạy `scripts/bin/harness` để cập nhật an toàn về sau.
- **Lớp sdlc** (plugin này): chuỗi `sdlc/`, hook, và các lệnh `/sdlc:*`.

Template của plugin nằm ở skill `artifact-chain` (thư mục `templates/` cạnh SKILL.md của skill đó).

Chế độ chính của repo: `--vibe` (người dùng không biết code, mặc định nếu họ nói vậy) hoặc `--engineer`. Không có tham số thì hỏi một câu. Ở chế độ vibe: nói bằng lời thường, tự làm hết, chỉ báo mỗi bước một dòng.

Làm lần lượt:

1. **Git.** Chưa phải repo git thì `git init` và commit mốc đầu (`chore: khởi tạo`). Ghi lại `git status` trước khi làm để không đụng thay đổi có sẵn.

2. **Cài lõi Harness** (bỏ qua nếu đã có `.harness-core/manifest.json`; khi đó chỉ chạy `scripts/bin/harness status`). LUÔN dùng chế độ merge để không ghi đè file có sẵn:
   - macOS/Linux: `curl -fsSL "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.sh?$(date +%s)" | bash -s -- --merge --yes`
   - Windows PowerShell: `& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.ps1"))) -Merge -Yes`
   - Chạy `scripts/bin/harness doctor` (Windows: `harness.exe`), phải pass hết.
   - Không có mạng hoặc cài thất bại: nói rõ, bỏ qua lớp lõi, vẫn làm tiếp các bước sau. Các lệnh `/sdlc:rule`, `/sdlc:onboard`, `/sdlc:improve`, `/sdlc:update` sẽ cần cài lại sau.

3. **`AGENTS.md`.** Giữ nguyên khối `<!-- HARNESS:BEGIN -->…<!-- HARNESS:END -->`. Nếu chưa có khối `<!-- SDLC:BEGIN -->`, nối nội dung `templates/AGENTS-sdlc-block.md` vào CUỐI file (sau khối Harness). Đã có thì không đụng.

4. **`CLAUDE.md`.** Claude Code không tự đọc `AGENTS.md`, nên:
   - Chưa có: tạo từ `templates/CLAUDE.md` (mẫu đã có sẵn khối `HARNESS` với dòng `@AGENTS.md`). Khảo sát repo để điền lệnh build/test/lint, cấu trúc, quy ước. Giữ dưới một trang.
   - Đã có nhưng thiếu khối `<!-- HARNESS:BEGIN -->`: nối khối đó (phần đầu của `templates/CLAUDE.md`, gồm dòng `@AGENTS.md`) vào CUỐI file. Không ghi đè phần còn lại.
   - Đã có nhưng thiếu mục "Lệnh" (build/test/lint): đề xuất bổ sung ngoài khối Harness, không tự viết đè.

5. **Lớp sdlc.** Tạo `sdlc/` (được commit) và `.sdlc/` (cục bộ). Thêm `.sdlc/fix-mode` vào `.gitignore` nếu chưa có. Chưa có `REVIEW.md` thì chép từ `templates/REVIEW.md`. Chép `templates/bands.yaml` vào `sdlc/bands.yaml` (chỉ là mẫu).

6. **Một lệnh test.** Repo phải có MỘT lệnh chạy test thoát mã khác 0 khi thất bại (`make test`, `npm test`…). Chưa có: chế độ engineer thì đề xuất, không tự thêm; chế độ vibe thì tạo bộ khung test nhỏ nhất phù hợp ngôn ngữ của repo và ghi lệnh vào `CLAUDE.md`, nói rõ đã làm gì.

7. **Runbook.** Repo đã có code chạy được mà chưa có `docs/runbook.md`: tạo từ `templates/runbook.md`, CHỈ điền điều đã kiểm chứng bằng cách chạy thật (khởi động instance riêng, xác nhận điều kiện "đã chạy xong", tắt lại). Chưa chắc thì để ở "Chưa biết". Repo lớn hoặc lạ: khuyên chạy `/sdlc:onboard` thay vì đoán. Repo trống: bỏ qua, runbook sẽ được tạo ở lần `/sdlc:vibe` đầu tiên khi app chạy được.

8. **Tóm tắt** những gì đã tạo và luồng lệnh:
   - Vibe: `/sdlc:vibe <mong muốn>`; hoàn tác `/sdlc:undo`; quy tắc cứng `/sdlc:rule`; tắt fix-mode `/sdlc:fix-done`.
   - Engineer: `/sdlc:intent` → `/sdlc:spec` → `/sdlc:plan` → `/sdlc:build` → `/sdlc:review`; việc nhỏ `/sdlc:quick`; sự cố `/sdlc:triage`.
   - Bảo trì: `/sdlc:onboard`, `/sdlc:improve`, `/sdlc:update`.

Commit: chế độ vibe thì tự commit `chore(harness): cài harness và sdlc`; chế độ engineer thì đề xuất thông điệp, không commit thay người dùng.

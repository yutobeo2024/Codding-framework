---
description: Cài harness vào repo hiện tại (lõi repository-harness + luật an toàn OWASP + sdlc/, .sdlc/, AGENTS.md, CLAUDE.md, REVIEW.md, runbook)
argument-hint: "[--vibe | --engineer] (mặc định: hỏi)"
---
Tham số: $ARGUMENTS

Thiết lập harness cho repo này. Gồm ba lớp:
- **Lõi Harness** (repository-harness, không phụ thuộc agent nào): `AGENTS.md`, `docs/WORKFLOW.md`, `docs/product|decisions|plans|templates`, skill `.agents/skills/*`, file chạy `scripts/bin/harness`. Lớp này do **người dùng** cài bằng `scripts/bootstrap` (luật K4: agent không chạy `curl | bash`).
- **Luật an toàn** (skill `an-toan`, theo OWASP LLM/Agentic Top 10): `an-toan/`, `.claude/settings.json`, `SECURITY-REPORT.md`, `DEPENDENCIES.md`, `.env.example`, `CHECKLIST-RA-MAT.md`.
- **Lớp sdlc** (plugin này): chuỗi `sdlc/`, hook, các lệnh `/sdlc:*`.

Template (dùng đúng đường dẫn này, không dò trong bộ nhớ đệm plugin vì có thể có nhiều phiên bản song song):
- `${CLAUDE_PLUGIN_ROOT}/skills/artifact-chain/templates/` (`CLAUDE.md`, `AGENTS-sdlc-block.md`, `REVIEW.md`, `runbook.md`, `bands.yaml`, …)
- `${CLAUDE_PLUGIN_ROOT}/skills/an-toan/templates/` (`an-toan/*`, `AGENTS-an-toan-block.md`, `settings.json`, `gitignore`, `env.example`, `SECURITY-REPORT.md`, `DEPENDENCIES.md`, `CHECKLIST-RA-MAT.md`, `HUONG-DAN-CHU-DU-AN.md`)

Chế độ chính của repo: `--vibe` (người dùng không biết code, mặc định nếu họ nói vậy) hoặc `--engineer`. Không có tham số thì hỏi một câu. Ở chế độ vibe: nói bằng lời thường, tự làm hết, chỉ báo mỗi bước một dòng.

Khi tạo hoặc nối file có tiếng Việt (`AGENTS.md`, `CLAUDE.md`, `REVIEW.md`…): dùng công cụ Write/Edit, KHÔNG dùng PowerShell `Add-Content`/`Set-Content`/`>>` (PowerShell 5.1 ghi mã ANSI, tiếng Việt sẽ hỏng).

Làm lần lượt:

1. **Git.** Ghi lại `git status` trước khi làm để không đụng thay đổi có sẵn. Ba trường hợp:
   - Chưa phải repo git → `git init`, rồi commit mốc đầu.
   - Đã là repo nhưng **chưa có commit nào** (`git rev-parse HEAD` lỗi; bootstrap vừa `git init`) → tạo mốc đầu bằng `git commit --allow-empty -m "chore: khởi tạo"` nếu không có file, hoặc commit các file có sẵn.
   - Có `.harness-core/` mà chưa được commit (bootstrap cài lõi nhưng không lưu mốc được) → commit ngay `git add .harness-core .agents AGENTS.md docs .gitignore && git commit -m "chore(harness): cài lõi Harness"` TRƯỚC mọi bước khác. Nếu bộ phân loại của Claude Code chặn lệnh này ("Untrusted Code Integration"), nhờ người dùng gõ trong Claude Code: `! git add -A && git commit -m "chore(harness): cài lõi Harness"`, rồi làm tiếp.

2. **Lõi Harness: kiểm tra, không tự cài.** Có `.harness-core/manifest.json` → chạy `scripts/bin/harness status` (Windows: `harness.exe`), báo phiên bản. Chưa có → nói: "Lõi Harness chưa được cài. Mở PowerShell/terminal, `cd` vào thư mục này, chạy lại lệnh bootstrap (xem README), rồi gõ `/sdlc:init` lần nữa." Vẫn làm tiếp các bước sau; các lệnh `/sdlc:rule`, `/sdlc:onboard`, `/sdlc:improve`, `/sdlc:update` sẽ cần lõi.

3. **`AGENTS.md`.** Thứ tự khối trong file: HARNESS → SDLC → AN-TOAN (khối SDLC có câu "lõi Harness ở trên").
   - Thiếu khối `<!-- HARNESS:BEGIN -->` mà có `.harness-core/base/AGENTS.md` (trình cài ở chế độ merge chỉ "adopt" file có sẵn, không chèn khối) → chép khối HARNESS từ file base đó và chèn lên ĐẦU `AGENTS.md`, ngay dưới dòng tiêu đề `# Agent Instructions` (thêm tiêu đề nếu chưa có). Không dùng `-RefreshAgentShim` của trình cài (bản PowerShell hiện làm hỏng tiếng Việt).
   - Thiếu cả khối HARNESS lẫn `.harness-core/` → tạo file với tiêu đề `# Agent Instructions`, khối HARNESS sẽ được chèn khi chạy `/sdlc:init` lại sau bootstrap.
   - Chưa có khối `<!-- SDLC:BEGIN -->` → nối `AGENTS-sdlc-block.md` vào CUỐI file. Chưa có khối `<!-- AN-TOAN:BEGIN -->` → nối `AGENTS-an-toan-block.md` vào cuối. Đã có thì không đụng.
   - Tổng `AGENTS.md` phải dưới 12.000 ký tự (kiểm tra bằng `wc -c`); không viết thêm gì dài vào file này.

4. **Luật an toàn.**
   - Chép `an-toan/templates/an-toan/*` → `an-toan/` (3 file: `LUAT-CHUNG.md`, `LUAT-LLM.md`, `LUAT-AGENT.md`) và `HUONG-DAN-CHU-DU-AN.md` → `an-toan/`. Đã có file nào thì giữ nguyên.
   - Xếp **cấp dự án**. Trước tiên hỏi: "Bạn có sẵn mô tả sản phẩm (PRD, ghi chú, brief) không? Dán vào hoặc chỉ đường dẫn file." Có → đọc, tự suy cấp từ đó, và lưu nguyên văn vào `docs/product/<ten-du-an>.md` (kèm dòng đầu: nguồn, ngày). Không có → hỏi tối đa 3 câu có/không: "App có gọi AI (ChatGPT, Claude, Gemini…) không?" → không: Cấp 0; có: "AI có tra cứu tài liệu riêng của bạn không?" → Cấp 2; "AI có tự làm việc như gửi mail, sửa dữ liệu, chạy code không?" → Cấp 3; còn lại Cấp 1. Chế độ engineer: tự suy từ code nếu rõ, không rõ thì hỏi.
   - Hỏi thêm một câu độc lập với cấp: "App có giữ **dữ liệu cá nhân hoặc sức khỏe** (CCCD, số điện thoại, bệnh án, thanh toán) không?" → có: ghi "Dữ liệu nhạy cảm: CÓ" vào đầu `SECURITY-REPORT.md`; luật N5, N9, N10 và mục Quyền riêng tư của checklist trở thành bắt buộc dù Cấp 0.
   - `SECURITY-REPORT.md`, `DEPENDENCIES.md`, `CHECKLIST-RA-MAT.md`: chép từ template nếu chưa có; điền cấp, dữ liệu nhạy cảm, và lý do vào đầu `SECURITY-REPORT.md`.
   - `.env.example`: chép từ `templates/env.example` nếu chưa có. Không bao giờ đọc hay tạo `.env` thật.
   - `.gitignore`: thêm các dòng trong `templates/gitignore` còn thiếu, cộng đúng một dòng `.sdlc/fix-mode`. KHÔNG ignore cả `.sdlc/` (trong đó có `test-patterns.txt`, `gate-patterns.txt` là cấu hình của dự án, cần commit). Không xóa dòng có sẵn.
   - `.gitattributes`: chưa có → tạo với 3 dòng `* text=auto eol=lf`, `*.ps1 text eol=crlf`, `*.bat text eol=crlf` (hết cảnh báo "LF will be replaced by CRLF" trên Windows).
   - `.claude/settings.json`: KHÔNG ghi ở bước này (Claude Code nạp lại file đó ngay lập tức và sẽ khóa các bước còn lại). Ghi ở bước 10.

5. **`CLAUDE.md`.** Claude Code không tự đọc `AGENTS.md`, nên:
   - Chưa có: tạo từ `artifact-chain/templates/CLAUDE.md`. Khảo sát repo để điền lệnh build/test/lint, cấu trúc, quy ước. Giữ dưới một trang.
   - Đã có nhưng thiếu khối `<!-- HARNESS:BEGIN -->`: nối khối đó (gồm dòng `@AGENTS.md`) vào cuối. Thiếu khối `<!-- AN-TOAN:BEGIN -->`: nối khối đó vào cuối.
   - Trong khối AN-TOAN: giữ `@an-toan/LUAT-CHUNG.md` luôn; giữ `@an-toan/LUAT-LLM.md` chỉ khi Cấp ≥ 1; giữ `@an-toan/LUAT-AGENT.md` chỉ khi Cấp 3 (bỏ dòng không dùng để tiết kiệm ngữ cảnh; khi cấp tăng, `/sdlc:vibe` thêm lại).
   - Đã có nhưng thiếu mục "Lệnh" (build/test/lint): đề xuất bổ sung ngoài các khối, không tự viết đè.

6. **Lớp sdlc.** Tạo `sdlc/` (được commit) và `.sdlc/` (cục bộ). Chưa có `REVIEW.md` thì chép từ `artifact-chain/templates/REVIEW.md`. Chép `templates/bands.yaml` vào `sdlc/bands.yaml` (chỉ là mẫu).

7. **Một lệnh test.** Repo phải có MỘT lệnh chạy test thoát mã khác 0 khi thất bại. Chưa có: chế độ engineer thì đề xuất, không tự thêm; chế độ vibe thì tạo bộ khung test nhỏ nhất phù hợp ngôn ngữ của repo (ưu tiên công cụ có sẵn trong runtime, không cài package mới — K4) và ghi lệnh vào `CLAUDE.md`, nói rõ đã làm gì. Mẫu: Node → `node --test` (KHÔNG kèm tên thư mục; Node 22+ tự tìm `*.test.js|mjs`, và `node --test tests/` hỏng trên Node mới); Python → `python -m unittest`; Go → `go test ./...`. Chạy thử một lần pass và một lần cố ý fail để xác nhận mã thoát.

8. **Runbook.** Repo đã có code chạy được mà chưa có `docs/runbook.md`: tạo từ `artifact-chain/templates/runbook.md`, CHỈ điền điều đã kiểm chứng bằng cách chạy thật (instance riêng, xác nhận "đã chạy xong", tắt lại). Chưa chắc thì để "Chưa biết". Repo lớn hoặc lạ: khuyên `/sdlc:onboard`. Repo trống: bỏ qua.

9. **Tóm tắt** những gì đã tạo, cấp dự án, và luồng lệnh:
   - Vibe: `/sdlc:vibe <mong muốn>`; hoàn tác `/sdlc:undo`; quy tắc cứng `/sdlc:rule`; tắt fix-mode `/sdlc:fix-done`.
   - Engineer: `/sdlc:intent` → `spec` → `plan` → `build` → `review`; việc nhỏ `/sdlc:quick`; sự cố `/sdlc:triage`.
   - An toàn: `/sdlc:audit` → `/sdlc:attack` → `/sdlc:launch` trước khi có người dùng thật; nghi bị tấn công `/sdlc:incident`. Đọc `an-toan/HUONG-DAN-CHU-DU-AN.md` (5 phút).
   - Bảo trì: `/sdlc:onboard`, `/sdlc:improve`, `/sdlc:update`.
   - Phép thử 30 giây: mở phiên mới hỏi "Bạn đang tuân thủ bộ luật nào? Liệt kê K1–K10 và K3 nói gì." Trả lời đúng (K3 = không chạm production) là đã nạp luật.

Commit: chế độ vibe thì tự commit `chore(harness): cài harness, luật an toàn và sdlc`; chế độ engineer thì đề xuất thông điệp, không commit thay người dùng.

10. **Ổ khóa thật — làm CUỐI CÙNG, sau commit.** `.claude/settings.json`: chưa có → chép `an-toan/templates/settings.json`. Đã có → thêm các mục `deny`/`ask`/`allow` còn thiếu, giữ nguyên mục của họ. Claude Code áp dụng file này ngay: từ đây agent bị chặn đọc `.env`, chạy `curl`/`sudo`/`rm -rf`/force push, phải hỏi khi cài thư viện hay push, và không dùng được chế độ bỏ qua quyền; sửa file thì không hỏi (`acceptEdits`). Thử `git add .claude/settings.json && git commit -m "chore(harness): ổ khóa quyền cho agent"`; nếu bị hỏi quyền hay bị chặn thì nói người dùng: "Bấm đồng ý, hoặc file này sẽ được gộp vào mốc kế tiếp của `/sdlc:vibe`." Nói với họ một câu: "Từ giờ Claude sẽ hỏi bạn trước khi cài thư viện hay đẩy code; đó là chủ ý."

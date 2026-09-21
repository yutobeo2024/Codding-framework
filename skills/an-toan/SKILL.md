---
name: an-toan
description: Luật an toàn bắt buộc cho AI coding agent theo OWASP LLM Top 10 và Agentic Top 10 (mã luật K/N/L/A), cùng template SECURITY-REPORT, DEPENDENCIES, .env.example, settings.json và checklist ra mắt. Dùng khi chạy /sdlc:init, /sdlc:audit, /sdlc:attack, /sdlc:incident, /sdlc:launch; khi việc chạm đăng nhập, phân quyền, dữ liệu người dùng, gọi LLM, tool/agent, upload, mạng, thư viện mới, khóa API; hoặc khi người dùng hỏi "có an toàn không", "bảo mật", "bị hack".
---
# An toàn (OWASP cho agent coding)

Bộ luật nằm trong dự án ở `an-toan/` (được `/sdlc:init` cài từ `templates/` cạnh file này):
- `an-toan/LUAT-CHUNG.md`: nhóm **K** (kỷ luật agent), **N** (nền tảng mọi app), phân cấp dự án 0–3, tầng Xanh/Vàng/Đỏ, cách xử lý khi chủ dự án yêu cầu trái luật, định nghĩa "XONG".
- `an-toan/LUAT-LLM.md`: nhóm **L** (LLM01–10), bắt buộc từ Cấp 1.
- `an-toan/LUAT-AGENT.md`: nhóm **A** (ASI01–10), bắt buộc ở Cấp 3.

Luật là **thẩm quyền đã được chủ dự án chấp nhận** khi cài khung → `/sdlc:rule` được phép biến một luật N/L/A thành kiểm tra tự động mà không cần hỏi thêm về thẩm quyền.

## Cách áp dụng theo tỉ lệ (nguyên tắc Harness: quy trình tỉ lệ với việc)
- Luôn: K1–K10 (chúng là kỷ luật của chính bạn, không phụ thuộc dự án).
- Khi việc chạm auth, dữ liệu người dùng, upload, mạng, thư viện mới: N tương ứng + cập nhật `SECURITY-REPORT.md`.
- Khi có gọi LLM: thêm L. Khi AI gọi tool / có bộ nhớ / nhiều agent: thêm A.
- Trang tĩnh, đổi giao diện, sửa chữ: chỉ K; ghi "không đổi" trong báo cáo, không mở rộng thủ tục.

## Báo cáo
Khi nói về an toàn với người không biết code: trích mã luật (K3, N5…), giải thích bằng một ví dụ đời thường (kẻ xấu làm gì, họ mất gì), và luôn kèm bằng chứng (file:dòng, lệnh + kết quả). Không có bằng chứng = CHƯA ĐẠT.

## Template
`templates/an-toan/*`, `templates/AGENTS-an-toan-block.md`, `templates/settings.json` (→ `.claude/settings.json`), `templates/gitignore`, `templates/env.example` (→ `.env.example`), `templates/SECURITY-REPORT.md`, `templates/DEPENDENCIES.md`, `templates/CHECKLIST-RA-MAT.md`, `templates/HUONG-DAN-CHU-DU-AN.md`.

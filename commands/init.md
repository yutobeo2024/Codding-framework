---
description: Cài harness vào repo hiện tại (tạo sdlc/, .sdlc/, CLAUDE.md, REVIEW.md từ template)
---
Thiết lập AI-native SDLC harness cho repo này. Dùng skill `artifact-chain` để lấy template (thư mục `templates/` nằm cạnh SKILL.md của skill đó).

Làm lần lượt:
1. Tạo thư mục `sdlc/` (nơi chứa artifact, ĐƯỢC commit) và `.sdlc/` (trạng thái cục bộ). Thêm `.sdlc/fix-mode` vào `.gitignore`.
2. Nếu chưa có `CLAUDE.md`: khảo sát repo (lệnh build/test/lint, cấu trúc thư mục, quy ước) rồi điền vào `templates/CLAUDE.md`. Giữ dưới một trang. Nếu đã có: chỉ đề xuất bổ sung khối "Tự kiểm tra trước khi báo xong", không ghi đè.
3. Nếu chưa có `REVIEW.md`: chép từ `templates/REVIEW.md`.
4. Kiểm tra repo có MỘT lệnh chạy test thoát mã khác 0 khi thất bại (`make test`, `npm test`...). Nếu chưa có, đề xuất cách gói lại, không tự ý thêm.
5. Chép `templates/bands.yaml` vào `sdlc/bands.yaml` như mẫu cho khâu Maintain (chỉ là mẫu, chưa chạy).
6. In ra tóm tắt những gì đã tạo và luồng lệnh: `/sdlc:intent` → `/sdlc:spec` → `/sdlc:plan` → `/sdlc:build` → `/sdlc:review`, thay đổi nhỏ dùng `/sdlc:quick`, sự cố dùng `/sdlc:triage`.

Không commit thay người dùng; đề xuất thông điệp commit.

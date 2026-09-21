---
description: "Kiểm tra bảo mật độc lập theo luật an toàn OWASP (K/N/L/A): phiên mới chấm ĐẠT/CHƯA ĐẠT kèm bằng chứng, cập nhật SECURITY-REPORT.md"
argument-hint: "[phạm vi: toàn bộ | <tính năng/slug>]"
---
Phạm vi: $ARGUMENTS (trống = toàn bộ dự án)

Chưa có `an-toan/LUAT-CHUNG.md` → chạy `/sdlc:init` trước.

1. Giao cho subagent `security-auditor` (ngữ cảnh mới, chỉ đọc). Đưa nó: phạm vi, cấp dự án ghi trong `SECURITY-REPORT.md`, đường dẫn `an-toan/`, `docs/runbook.md`, lệnh test trong `CLAUDE.md`. KHÔNG đưa nó lời giải thích hay biện hộ của phiên này về code.
2. Nhận báo cáo. Không sửa code trong lệnh này.
3. Cập nhật `SECURITY-REPORT.md`: bảng tuân thủ (mục 3), kết quả test (mục 4), ngày, "Agent kiểm tra độc lập", kết luận hiện tại. Giữ nguyên các dòng "TÔI CHẤP NHẬN RỦI RO" (mục 5).
4. Trình bày cho người dùng bằng lời thường: kết luận; số lỗi theo mức; 3 việc nên sửa trước; việc **chỉ họ** làm được (trần chi tiêu, xoay khóa, 2FA…).
5. Đề xuất bước tiếp: lỗi Nghiêm trọng/Cao → `/sdlc:vibe sửa <lỗi>` (chế độ vibe) hoặc `/sdlc:quick --fix`; luật vi phạm lặp lại → `/sdlc:rule` để biến thành kiểm tra tự động; sạch → `/sdlc:attack` rồi `/sdlc:launch`.
6. Commit `audit: <ngày> <kết luận>` (chế độ vibe) hoặc đề xuất thông điệp commit.

Lưu ý cho người dùng: audit bằng cùng một model vẫn có điểm mù; nếu app xử lý tiền, sức khỏe, dữ liệu cá nhân số lượng lớn, khuyên thuê kỹ sư bảo mật rà độc lập một lần với `SECURITY-REPORT.md` làm đầu vào.

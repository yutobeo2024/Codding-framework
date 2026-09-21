---
description: "Biến một quy tắc nói bằng lời (\"không bao giờ được…\") thành kiểm tra tự động, dùng skill encode-invariant của Harness"
argument-hint: "<quy tắc bằng lời thường>"
---
Quy tắc người dùng muốn giữ: $ARGUMENTS

Nguồn phương pháp là skill `encode-invariant` của Harness trong repo: `.agents/skills/encode-invariant/SKILL.md` và `docs/patterns/encoding-invariants.md`. Chưa có hai file đó thì chạy `/sdlc:init` trước. Đọc và làm theo TOÀN BỘ skill đó. Lệnh này chỉ thêm phần dành cho người không biết code:

1. **Thẩm quyền do người dùng xác nhận.** Skill yêu cầu một nguồn quy tắc đã được chấp nhận. Nếu quy tắc chưa có trong `docs/decisions/` hoặc `docs/product/`:
   - Viết lại bằng lời thường thành: phạm vi (áp dụng cho cái gì), một ví dụ ĐƯỢC PHÉP, một ví dụ BỊ CẤM, ngoại lệ (nếu có).
   - Câu gốc có hai cách hiểu cho ra hành vi khác nhau → hỏi người dùng chọn, không đoán.
   - Người dùng xác nhận → ghi `docs/decisions/NNNN-quy-tac-<tên>.md` theo `docs/templates/decision.md` (Status `Accepted`, "Người quyết định: <người dùng>, <ngày>"), thêm vào `docs/decisions/README.md`. Bản ghi này là nguồn thẩm quyền mà skill cần.
2. **Kiểm tra nằm trong lệnh test sẵn có** của repo (xem `CLAUDE.md`), không thêm công cụ mới. Thông báo lỗi bằng tiếng Việt, nêu: vi phạm gì, quy tắc nào (đường dẫn decision), nên làm gì.
3. **Bằng chứng hai chiều:** chạy cho thấy trường hợp hợp lệ qua; tạm tạo một vi phạm để thấy kiểm tra báo đỏ đúng lý do; hoàn nguyên vi phạm; chạy lại cho xanh.
4. **Báo đúng mức cưỡng chế, bằng lời thường:** kiểm tra chạy khi nào (lệnh test cục bộ; CI có gọi hay không; branch protection chưa kiểm chứng). Không nói "đã chặn được" nếu chỉ mới chạy cục bộ. Không cài hook, không sửa CI hay cấu hình nhánh nếu người dùng không yêu cầu riêng.
5. Commit `rule(<tên>): <quy tắc, lời thường>` (ở chế độ vibe) hoặc đề xuất thông điệp commit (chế độ kỹ sư).

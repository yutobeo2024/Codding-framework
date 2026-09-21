---
description: "Khi nghi có sự cố bảo mật: hướng dẫn dừng, xoay khóa, giữ log, rồi điều tra CHỈ ĐỌC theo luật K/N/L/A. Lỗi thường (không phải bảo mật) dùng /sdlc:triage"
argument-hint: "<mô tả điều bạn thấy: hóa đơn tăng, dữ liệu lạ, chatbot nói bậy, email lạ gửi đi...>"
---
Dấu hiệu: $ARGUMENTS

Lệnh này CHỈ ĐỌC. Không sửa, không xóa, không chạy lệnh làm đổi trạng thái, không dọn log. Nếu hóa ra là lỗi thường không liên quan bảo mật → chuyển sang `/sdlc:triage`.

**Trước tiên, nói với người dùng 4 việc họ làm ngay, bằng lời thường, theo thứ tự** (những việc này chỉ họ làm được):
1. Dừng trước, tìm hiểu sau: bấm nút dừng agent / tắt tính năng AI / gỡ app khỏi mạng nếu cần.
2. Xoay toàn bộ khóa (nhà cung cấp AI, database, email, cloud) trong bảng điều khiển của từng dịch vụ. Khóa cũ coi như đã lộ.
3. Kiểm tra hóa đơn và usage của nhà cung cấp AI và cloud; hạ trần chi tiêu.
4. Giữ nguyên log, sao chép log ra nơi khác. Không xóa gì.

Rồi điều tra (đọc `an-toan/*` trước):
- Chuyện gì đã xảy ra, từ lúc nào, qua đường nào? Luật nào (K/N/L/A) đã bị thủng? Bằng chứng: log, commit gần đây (`git log`), diff, cấu hình.
- Dữ liệu nào, của ai, có thể đã bị lộ hoặc bị sửa?
- Bộ nhớ agent / kho vector / cache có bị ghi nội dung lạ không?
- Những gì cần xoay, thu hồi, khôi phục — xếp theo thứ tự ưu tiên. Có runbook rollback đã duyệt thì chỉ NÊU, không tự chạy.
- Không chắc thì nói không chắc; nêu điều gì sẽ xác nhận hay bác bỏ giả thuyết.

Báo cáo bằng tiếng Việt đơn giản. Ghi vào `SECURITY-REPORT.md` mục 6 và `sdlc/lessons.md` (ngày, triệu chứng, nguyên nhân, cách nhận biết sớm).

Nhắc người dùng: nếu có dữ liệu cá nhân của khách hàng bị lộ, họ có thể có **nghĩa vụ pháp lý phải thông báo** trong thời hạn ngắn → liên hệ luật sư / chuyên gia bảo mật. Sau khi xử lý: khôi phục từ bản sao lưu sạch, dọn bộ nhớ / vector bị nhiễm, chạy lại `/sdlc:audit` và `/sdlc:attack` rồi mới mở lại.

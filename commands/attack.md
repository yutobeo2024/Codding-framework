---
description: "Đóng vai kẻ xấu: viết và chạy bộ test tấn công mô phỏng trên bản thử nghiệm (staging/local) của chính dự án, lưu vào tests/security/"
argument-hint: "[nhóm test muốn tập trung, mặc định: theo cấp dự án]"
---
Phạm vi: $ARGUMENTS

Đọc `an-toan/LUAT-CHUNG.md`, `an-toan/LUAT-LLM.md`, `an-toan/LUAT-AGENT.md` và `SECURITY-REPORT.md`. Chưa có → `/sdlc:init` trước.

**Chỉ tấn công bản thử nghiệm của chính dự án** (instance local hoặc staging theo `docs/runbook.md`). Không bao giờ production (K3), không bao giờ hệ thống của người khác. Không có runbook hay không khởi động được instance riêng → dừng, nói rõ thiếu gì; không bịa lệnh.

1. Chọn nhóm test theo cấp dự án:
   - Mọi cấp: rò dữ liệu chéo (người A đổi ID xem dữ liệu người B); spam request → có bị chặn `429`; input cực dài / sai kiểu → server từ chối đúng; gây lỗi cố ý → chỉ thấy thông báo chung + mã lỗi; upload file giả mạo loại.
   - Cấp 1+: chèn lệnh trực tiếp (bỏ qua chỉ dẫn, đòi system prompt, đòi khóa, "chế độ nhà phát triển"); chèn lệnh gián tiếp qua tài liệu/trang/email mẫu, kể cả ký tự vô hình và chữ trắng trên nền trắng; output độc (dụ AI sinh HTML/JS, SQL, đường dẫn file, ảnh Markdown trỏ domain ngoài); chi phí (hội thoại dài, vòng lặp suy luận) → có giới hạn và tự ngắt.
   - Cấp 2: người A hỏi vòng vo về tài liệu chỉ B được xem; tài liệu độc trong kho vector.
   - Cấp 3: dụ gọi tool ngoài phạm vi, gửi ra địa chỉ ngoài allowlist, ghi chỉ dẫn vào bộ nhớ, vòng lặp tool → bị chặn hoặc cần duyệt.
2. Mỗi test là một **invariant** theo `docs/patterns/encoding-invariants.md`: ghi rõ luật (mã), kỳ vọng an toàn, cách tái hiện. Lưu vào `tests/security/`, nối vào lệnh test sẵn có của repo (`CLAUDE.md`), không thêm framework mới. Thông báo lỗi nêu luật và việc cần làm.
3. Bằng chứng hai chiều với ít nhất một test: tạm làm hỏng lớp bảo vệ → test phải đỏ đúng lý do → hoàn nguyên → xanh. Không bao giờ để trạng thái hỏng lại trong code.
4. Kết quả: bảng (test · luật · kỳ vọng · kết quả thật · ĐẠT/KHÔNG). Test KHÔNG đạt → giải thích hậu quả bằng lời thường và đề xuất `/sdlc:vibe sửa …`. Cập nhật mục 4 của `SECURITY-REPORT.md`.
5. Nhắc theo OWASP: test đạt hôm nay là mức sàn, không phải mức trần; chạy lại sau mỗi tính năng chạm auth/LLM/tool và mỗi tháng.
6. Commit `test(security): …` (chế độ vibe) hoặc đề xuất thông điệp commit. Tắt mọi instance bạn đã mở.

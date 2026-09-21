---
description: "Cổng ra mắt cho chủ dự án không chuyên: đi từng mục CHECKLIST-RA-MAT.md, agent chỉ bằng chứng, người dùng tự tick. Chưa tick hết phần bắt buộc thì chưa có người dùng thật"
disable-model-invocation: true
---
Đọc `CHECKLIST-RA-MAT.md` (cài bởi `/sdlc:init`; chưa có thì chạy `/sdlc:init` trước), `SECURITY-REPORT.md`, `an-toan/LUAT-CHUNG.md`.

Nguyên tắc: **bạn chỉ đưa bằng chứng, người dùng tick.** Không tự tick, không đánh dấu ĐẠT thay họ. Câu nào bạn chỉ "khẳng định" mà không chứng minh được → coi như CHƯA.

1. Xác định cấp dự án (đầu `SECURITY-REPORT.md`) để biết áp dụng phần A, B, và C/D hay không.
2. Nếu `/sdlc:audit` chưa chạy trong 7 ngày hoặc kết luận còn CHƯA ĐƯỢC RA MẮT → dừng, đề nghị chạy `/sdlc:audit` (và `/sdlc:attack`) trước.
3. Đi **từng mục một**, mỗi lượt một mục:
   - Phần A (việc chỉ chủ dự án làm được: trần chi tiêu, khóa riêng, 2FA, sao lưu đã thử khôi phục, nút dừng): bạn không kiểm tra được → hỏi họ đã làm chưa, giải thích vì sao quan trọng bằng một câu đời thường. Họ trả lời rõ "đã làm" thì mới ghi.
   - Phần B/C/D: bạn đưa bằng chứng (mở file, chạy lệnh, chụp màn hình, thử thật qua giao diện theo `docs/runbook.md`: đăng nhập A xem dữ liệu B, spam request, gây lỗi cố ý…). Rồi hỏi họ tick hay không.
4. Ghi kết quả vào `CHECKLIST-RA-MAT.md` trong repo: `[x]` chỉ khi người dùng nói tick, kèm ngày và bằng chứng một dòng; `[ ]` giữ nguyên với lý do.
5. Kết luận bằng lời thường: bao nhiêu mục bắt buộc còn trống, ba việc cần làm trước, và câu rõ ràng: **"Chưa qua cổng → chưa có người dùng thật, chưa có dữ liệu thật."** Cập nhật kết luận ở đầu `SECURITY-REPORT.md`.
6. Nhắc lịch "sau khi ra mắt" cuối checklist (mỗi tuần xem hóa đơn và log hành động Đỏ; mỗi tháng cập nhật thư viện và chạy lại `/sdlc:audit`, `/sdlc:attack`).
7. Commit `launch: checklist <ngày>` (chế độ vibe) hoặc đề xuất thông điệp commit.

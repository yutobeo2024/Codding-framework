---
description: "Giai đoạn 2 (Design): từ intent.md đã duyệt, viết spec.md gộp yêu cầu và thiết kế"
argument-hint: "<slug>"
---
Slug: $ARGUMENTS (nếu trống, liệt kê các thư mục trong `sdlc/` và hỏi chọn cái nào).

Cổng vào: đọc `sdlc/<slug>/intent.md`. Nếu `status` chưa phải `accepted`, DỪNG và báo người dùng duyệt intent trước.

1. Đọc `CLAUDE.md` và khảo sát phần codebase liên quan (chỉ đọc, không sửa).
2. Nạp mọi skill chính sách của tổ chức có liên quan (bảo mật, thương hiệu, UX, quy chuẩn API). Ghi tên skill đã áp dụng vào spec.
3. Dùng skill `artifact-chain`, điền `templates/spec.md` → `sdlc/<slug>/spec.md`. Mỗi yêu cầu phải kiểm chứng được (có tiêu chí chấp nhận đo được). Mỗi "Câu hỏi mở" của intent phải được trả lời hoặc ghi rõ là mang sang.
4. Bắt buộc có mục "Điểm đáng lo": chỗ hai chính sách mâu thuẫn, chỗ bạn phải đoán, rủi ro dữ liệu/bảo mật, phần việc lớn bất thường. Không có gì thì ghi "Không có" kèm lý do.
5. Trình bày "Điểm đáng lo" TRƯỚC, rồi mới đến phần còn lại. Người dùng duyệt thì đổi `status: accepted`. Không tự chấp nhận.
6. Đề xuất commit: `spec(<slug>): ...`. Bước kế tiếp: `/sdlc:plan <slug>`.

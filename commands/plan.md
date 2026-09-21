---
description: "Giai đoạn 3a (Build): lập plan.md từ spec đã duyệt, chưa sửa dòng code nào"
argument-hint: "<slug>"
---
Slug: $ARGUMENTS

Cổng vào: `sdlc/<slug>/spec.md` phải có `status: accepted`. Nếu chưa, DỪNG.

Ở bước này chỉ được ĐỌC codebase và GHI duy nhất file `sdlc/<slug>/plan.md`. Khuyên người dùng bật plan mode (Shift+Tab) để được cưỡng chế ở tầng công cụ.

1. Đọc intent.md, spec.md, CLAUDE.md và các file sẽ bị ảnh hưởng.
2. Dùng skill `artifact-chain`, điền `templates/plan.md`: file nào đổi (mới/sửa), thứ tự công việc theo bước nhỏ commit được, rủi ro, và "Bằng chứng" (test nào, lệnh nào chứng minh xong).
3. Tự chất vấn và ghi câu trả lời vào plan: thay đổi này có thể làm hỏng gì? bước nào rủi ro nhất? phương án nào đã cân nhắc và vì sao loại?
4. Chỉ ra phần việc độc lập về file để có thể chạy song song bằng worktree, nếu có.
5. Tiêu chuẩn đủ tốt: một kỹ sư chưa hề đọc cuộc trò chuyện này vẫn triển khai được chỉ từ plan.
6. Người dùng duyệt thì đổi `status: accepted`. Thay đổi rủi ro cao (migration, auth, thanh toán, hạ tầng): nhắc họ xin thêm ý kiến tech lead.
7. Đề xuất commit: `plan(<slug>): ...`. Bước kế tiếp: `/sdlc:build <slug>`.

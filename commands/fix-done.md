---
description: "Tắt fix-mode sau khi sửa lỗi xong. Chỉ người dùng gõ được lệnh này; agent không tự tắt được"
disable-model-invocation: true
---
Người dùng vừa tự tay gõ lệnh này để tắt fix-mode. Cờ được gỡ ngay khi lệnh được mở rộng (trước khi bạn đọc), không qua công cụ Bash nên hook production-gate không can thiệp. Bạn không được và không cần chạy `rm .sdlc/fix-mode`.

Kết quả gỡ cờ:
!`cd "${CLAUDE_PROJECT_DIR:-.}" && if [ -f .sdlc/fix-mode ]; then cat .sdlc/fix-mode; rm -f .sdlc/fix-mode && echo "-> da go co fix-mode"; else echo "khong co co fix-mode nao dang bat"; fi`

Việc của bạn:
1. Đọc kết quả trên. Dòng "da go co fix-mode" → báo người dùng bằng lời thường: "Đã tắt chế độ bảo vệ test. Từ giờ có thể sửa test lại bình thường." Dòng "khong co co" → nói không có gì để tắt.
2. Nếu kết quả trống hoặc báo lỗi (ví dụ máy tắt tính năng chạy lệnh trong skill), KHÔNG tự xoá cờ. Nhờ người dùng xoá bằng tay: `rm .sdlc/fix-mode` (Windows PowerShell: `Remove-Item .sdlc/fix-mode`).
3. Nhắc bước tiếp theo: chạy lại toàn bộ test một lần nữa rồi tiếp tục `/sdlc:vibe`, `/sdlc:build` hay `/sdlc:review`.

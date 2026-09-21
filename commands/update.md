---
description: "Cập nhật lõi Harness trong repo lên bản mới một cách an toàn (merge 3 chiều), giải thích bằng lời thường"
disable-model-invocation: true
---
Cập nhật lõi Harness (hướng dẫn chung cho agent) mà không làm mất phần repo đã tự chỉnh.

File chạy: `scripts/bin/harness` (Windows: `scripts/bin/harness.exe`). Không có thì cài lại theo bước "Cài Harness" của `/sdlc:init` (luôn dùng `--merge` / `-Merge`).

1. Chạy `status` rồi `update --dry-run`. Tóm tắt bằng lời thường: đang ở bản nào, bản mới là gì, bao nhiêu file đổi, file nào repo đã tự chỉnh, có xung đột không. Hỏi người dùng có cập nhật không.
2. Đồng ý: chạy `update`, rồi `doctor`. Báo kết quả.
3. Có xung đột: Harness KHÔNG đổi file nào và giữ các bản BASE, LOCAL, UPSTREAM, RESOLVED theo đường dẫn nó in ra. Với mỗi chỗ xung đột, giải thích như một lựa chọn: giữ bản của repo / lấy bản mới / gộp cả hai (kèm đề xuất của bạn). Người dùng chọn xong thì ghi bản giải quyết đúng chỗ Harness chỉ, chạy `update --continue --dry-run`, rồi `update --continue`. Muốn huỷ: `update --abort` (chỉ bỏ phần đang giải quyết dở).
4. Kiểm tra khối `SDLC:BEGIN/END` trong `AGENTS.md` và khối `HARNESS:BEGIN/END` trong `CLAUDE.md` vẫn còn.
5. Commit `chore(harness): cập nhật lõi lên <phiên bản>` (chế độ vibe) hoặc đề xuất thông điệp commit.

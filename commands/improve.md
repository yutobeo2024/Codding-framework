---
description: "Dành cho người bảo trì: sửa hướng dẫn, runbook hoặc kiểm tra cho agent dựa trên ma sát đã quan sát, có bằng chứng trước và sau (skill improve-harness)"
argument-hint: "<ma sát đã thấy: agent làm sai gì, ở việc nào, bao nhiêu lần>"
disable-model-invocation: true
---
Ma sát được báo: $ARGUMENTS

Việc người dùng gõ lệnh này chính là sự cho phép rõ ràng mà skill yêu cầu, chỉ cho MỘT cải tiến có giới hạn.

Đọc và làm theo TOÀN BỘ `.agents/skills/improve-harness/SKILL.md` và `docs/templates/harness-improvement.md` (chưa có thì chạy `/sdlc:init` trước). Tóm tắt các điểm bắt buộc:
1. Giữ baseline: việc đã giao, agent đã làm gì, người đã can thiệp thế nào.
2. Tìm chỗ thiếu SỚM NHẤT: ngữ cảnh, công cụ, chủ sở hữu, thẩm quyền, bằng chứng hay môi trường.
3. Sửa nhỏ nhất ở đúng chủ sở hữu. Ưu tiên phần repo tự sở hữu: `AGENTS.md` (ngoài khối `HARNESS:BEGIN/END`), `CLAUDE.md`, `docs/runbook.md`, test. Không sửa file của plugin sdlc. Hạn chế sửa file do Harness quản lý (`scripts/bin/harness status` liệt kê); nếu buộc phải sửa thì nói rõ sẽ thành bản sửa cục bộ được merge khi cập nhật.
4. Chạy lại việc tương đương bằng một agent MỚI (subagent ngữ cảnh sạch, không được đưa gợi ý về cách sửa). Cải tiến chỉ được giữ khi lần chạy lại thật sự đọc tới và dùng nó.
5. Quyết định giữ, sửa, hay bỏ. Hồ sơ nằm ở `docs/plans/active/` cho tới khi có bằng chứng chạy lại, rồi mới chuyển sang `completed/`.

Không đổi chính sách sản phẩm, không nới lỏng kiểm tra, không thêm credentials, không thay đổi hệ thống bên ngoài.

---
description: "Khảo sát repo có sẵn (lượt đầu chỉ đọc) bằng skill onboard-repository của Harness, rồi đề xuất tài liệu và runbook cho agent"
argument-hint: "[luồng hoặc phần muốn tìm hiểu, mặc định: cách chạy app]"
---
Phạm vi: $ARGUMENTS

Nguồn phương pháp là `.agents/skills/onboard-repository/SKILL.md` của Harness trong repo. Chưa có thì chạy `/sdlc:init` trước. Đọc và làm theo TOÀN BỘ skill đó, kể cả hợp đồng an toàn: lượt đầu CHỈ ĐỌC, không sửa file, không cài gì, không khởi động dịch vụ, không tạo trạng thái, không tự suy ra chính sách sản phẩm.

Phần thêm cho người không biết code:

1. Sau lượt khảo sát, trình bày:
   - Tóm tắt 5 đến 10 dòng bằng lời thường: app này làm gì, chạy thế nào, cái gì đã kiểm chứng, cái gì chưa rõ.
   - Danh sách đề xuất đánh số (ví dụ tạo `docs/runbook.md`, `docs/product/overview.md`, lệnh test một dòng trong `CLAUDE.md`), mỗi mục một dòng "lợi ích cho bạn".
2. Chỉ áp dụng những mục người dùng chọn, theo đúng bước "sau khi người dùng duyệt" của skill.
3. Đề xuất lớn hoặc rủi ro: khuyên kiểm định độc lập trong một phiên MỚI bằng `.agents/skills/audit-onboarding-proposal/SKILL.md` trước khi áp dụng. Có thể giao cho một subagent mới (ngữ cảnh sạch), đưa nó transcript tóm tắt và bản đề xuất; nó cũng chỉ đọc.
4. Runbook tạo ra theo `docs/templates/application-runbook.md`, chỉ ghi điều đã có bằng chứng; phần chưa biết để ở mục Unknowns.

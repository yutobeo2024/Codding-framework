---
description: "Giai đoạn 5 (Deploy): review diff theo REVIEW.md, đối chiếu với spec.md và plan.md"
argument-hint: "[slug] [nhánh gốc, mặc định main]"
---
Tham số: $ARGUMENTS

Giao việc cho subagent `reviewer` để có ngữ cảnh sạch, không bị ảnh hưởng bởi giả định của phiên đã viết code. Đưa cho nó: diff so với nhánh gốc, `REVIEW.md`, và `sdlc/<slug>/spec.md`, `plan.md` nếu có slug.

Yêu cầu kết quả:
1. Ba lượt, mỗi phát hiện gắn nhãn lượt: **Bug** (logic, biên, hồi quy), **Bảo mật** (injection, thiếu xác thực, lộ PII/secrets trong log), **Tuân thủ** (diff có khớp spec.md và plan.md không; phần nào trong diff mà plan không nhắc tới; yêu cầu nào trong spec chưa được làm).
2. Mức độ theo định nghĩa trong REVIEW.md: `Quan trọng` hoặc `Vặt`. Tối đa 5 mục Vặt, phần còn lại chỉ đếm.
3. Mỗi phát hiện có: file:dòng, vì sao là vấn đề, gợi ý sửa.
4. Kết thúc bằng bảng đếm theo lượt × mức độ, và một câu: "Con người cần xem kỹ nhất chỗ nào".

Nguyên tắc: bạn KHÔNG phê duyệt PR. Phát hiện chỉ là thông tin cho code owner. Nếu cùng một lỗi xuất hiện lần thứ hai, đề xuất dòng bổ sung vào CLAUDE.md. Nếu diff làm CLAUDE.md lỗi thời, nói rõ.

---
description: "Giai đoạn 1 (Plan): phỏng vấn ý tưởng rồi ghi thành sdlc/<slug>/intent.md"
argument-hint: "<mô tả ý tưởng bằng lời của bạn>"
---
Ý tưởng của người dùng: $ARGUMENTS

Mục tiêu: nắm đúng Ý ĐỊNH bằng lời của người nêu ý tưởng, chưa bàn giải pháp kỹ thuật.

1. Dùng skill `grill` để phỏng vấn: mỗi lượt MỘT câu hỏi, theo thứ tự vấn đề → ai bị ảnh hưởng → "tốt hơn" trông ra sao → ràng buộc → ngoài phạm vi. Dừng khi một người chưa dự cuộc trò chuyện vẫn hiểu được cần gì và vì sao (thường 4 đến 8 câu). Nếu $ARGUMENTS trống, hỏi câu đầu tiên: "Hôm nay bạn không làm được việc gì?"
2. Chọn `<slug>` dạng kebab-case, ngắn. Dùng skill `artifact-chain`, điền `templates/intent.md`, ghi vào `sdlc/<slug>/intent.md` với `status: draft`.
3. Điều chưa rõ thì đưa vào "Câu hỏi mở", KHÔNG tự bịa câu trả lời.
4. Đưa bản nháp cho người dùng sửa. Chỉ khi họ nói rõ là chấp nhận mới đổi `status: accepted` và ghi `accepted_by`. Không bao giờ tự chấp nhận.
5. Đề xuất commit: `intent(<slug>): <một dòng>`. Bước kế tiếp: `/sdlc:spec <slug>`.

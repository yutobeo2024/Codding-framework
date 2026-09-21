---
description: "Giai đoạn 6 (Maintain): từ ticket, log hoặc cảnh báo, chẩn đoán rồi đưa trở lại vòng lặp (PR nhỏ hoặc intent.md mới)"
argument-hint: "<dán ticket / log / mô tả sự cố, hoặc đường dẫn file>"
---
Đầu vào: $ARGUMENTS

Bước này mặc định CHỈ ĐỌC. Không sửa code, không chạy lệnh làm đổi trạng thái hệ thống.

1. Thu thập chứng cứ: log, commit và deploy gần đây (`git log`, lịch sử CI nếu truy cập được), vùng code liên quan, file `sdlc/lessons.md` nếu có.
2. Chẩn đoán: nguyên nhân khả dĩ nhất, độ tin cậy (cao/vừa/thấp), chứng cứ ủng hộ, điều gì sẽ bác bỏ giả thuyết này. Không chắc thì nói không chắc.
3. Phân loại và đề xuất MỘT đường đi:
   - **Nhỏ, ranh giới rõ, gói trong một PR** → đề xuất `/sdlc:quick` với chế độ sửa bug (test tái hiện trước).
   - **Lớn hơn** (kiến trúc, lặp lại ở nhiều nơi, cần quyết định sản phẩm) → viết `sdlc/<slug>/intent.md` mới theo template, mục Vấn đề ghi rõ bất thường và chứng cứ, `source: triage`, `status: draft`.
   - **Không phải lỗi / nhiễu** → ghi lý do bỏ qua để lần sau không báo lại.
4. Nếu có runbook rollback đã được duyệt sẵn, chỉ NÊU ra; việc chạy do người trực quyết định.
5. Ghi bài học ngắn vào `sdlc/lessons.md` (ngày, triệu chứng, nguyên nhân, cách nhận biết sớm). Khi bản sửa đã phát hành, nhắc thêm test hoặc eval cho lớp lỗi này.

# Hướng dẫn cho chủ dự án — phần an toàn (đọc 5 phút)

Ý tưởng cốt lõi: bạn không đọc được code, nên đừng cố. Hãy **bắt agent chứng minh**, và **dùng một phiên agent khác kiểm tra lại**.
Triết lý: AI rồi sẽ bị lừa hoặc làm sai → xây sao cho khi đó không có gì quan trọng bị hỏng.

## Lệnh dành cho bạn
| Lệnh | Khi nào |
|---|---|
| `/sdlc:audit` | trước khi cho người thật dùng, hoặc mỗi tháng: một phiên MỚI rà theo từng luật, chấm ĐẠT / CHƯA ĐẠT kèm bằng chứng |
| `/sdlc:attack` | agent đóng vai kẻ xấu thử phá bản **thử nghiệm** của bạn (không bao giờ bản thật) |
| `/sdlc:launch` | đi từng mục checklist ra mắt; agent chỉ bằng chứng, **bạn** tick |
| `/sdlc:incident` | khi nghi bị tấn công: dừng, xoay khóa, giữ log, điều tra chỉ đọc |

Phép thử 30 giây xem agent đã nạp luật chưa — mở phiên mới và hỏi:
**"Bạn đang tuân thủ bộ luật nào trong dự án này? Liệt kê K1 đến K10 và cho biết K3 nói gì."**
Trả lời đúng (K3 = không chạm production) → đã nạp.

## 6 thói quen của riêng bạn
1. Không bao giờ dán khóa API, mật khẩu, dữ liệu khách hàng thật vào khung chat AI.
2. Bật trần chi tiêu cứng ở mọi nhà cung cấp **trước khi** tạo khóa.
3. Mỗi dự án, mỗi môi trường một bộ khóa riêng. Lộ một chỗ không cháy cả nhà.
4. Agent coding chỉ làm trong thư mục dự án, với dữ liệu giả. Không cho nó đụng bản đang chạy thật.
5. Không tự cài MCP server / plugin / skill lạ theo gợi ý trên mạng. Mỗi cái là một người lạ bạn mời vào nhà.
6. Khi agent nói "đã xong, đã test": hỏi "cho tôi xem lệnh bạn chạy và kết quả".

## Bộ luật KHÔNG làm được gì — nói thẳng
- Không bảo đảm an toàn tuyệt đối; OWASP khẳng định chưa có cách chặn triệt để prompt injection. Mục tiêu là giảm xác suất và **thu nhỏ thiệt hại**.
- `AGENTS.md` và `an-toan/` là lời dặn, không phải ổ khóa. Ổ khóa thật: `.claude/settings.json` (chặn đọc `.env`, chặn `curl`, `sudo`, `rm -rf`, force push), hook của plugin, quyền tài khoản hẹp, trần chi tiêu, sao lưu. Chắc nhất: **đừng để bí mật thật trong thư mục agent làm việc**.
- Agent kiểm tra agent vẫn có điểm mù. App xử lý tiền, dữ liệu sức khỏe, dữ liệu cá nhân số lượng lớn, hoặc agent Cấp 3 chạy cho khách: thuê kỹ sư bảo mật rà soát độc lập ít nhất một lần. `SECURITY-REPORT.md` giúp họ làm nhanh và rẻ hơn.
- Không thay cho tư vấn pháp lý về bảo vệ dữ liệu cá nhân.

## Ba cấp dự án — bạn đang ở đâu?
- **Cấp 0 — không gọi AI** (trang tĩnh, app thường): luật K + N.
- **Cấp 1 — chatbot / app gọi AI.** Rủi ro chính: lộ khóa, hóa đơn tăng vọt, lộ dữ liệu người dùng.
- **Cấp 2 — RAG / tra cứu tài liệu.** Thêm: người này xem được tài liệu người kia, tài liệu độc làm chatbot trả lời sai.
- **Cấp 3 — agent tự hành động** (gửi mail, sửa dữ liệu, chạy code, có bộ nhớ). Thêm toàn bộ nhóm A. Nguyên tắc **tự chủ tối thiểu**.

Cấp hiện tại của dự án ghi ở đầu `SECURITY-REPORT.md`. Thêm tính năng làm tăng cấp → agent phải phân loại lại.

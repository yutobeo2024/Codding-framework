# LUAT-LLM.md — Nhóm L: ứng dụng có dùng LLM (OWASP LLM01–LLM10 · bản 2026)

> Phần mở rộng bắt buộc của `AGENTS.md`. Áp dụng cho mọi dự án Cấp 1 trở lên. Giữ file dưới 12.000 ký tự.

- **L1 · Prompt Injection (LLM01).** Không tồn tại cách chặn tuyệt đối → thiết kế để injection thành công cũng không gây hại.
  - Tách rõ 3 luồng: chỉ dẫn hệ thống / input người dùng / nội dung truy xuất; gắn nhãn nguồn cho nội dung ngoài.
  - Loại bỏ ký tự vô hình ở mọi điểm vào và điểm hiển thị: U+E0000–E007F, U+FE00–FE0F, U+200B, U+200C, U+200D, U+2060.
  - Output của model phải theo schema cố định và được **code** validate trước khi hệ thống nào dùng tới.
  - System prompt **không phải hàng rào bảo mật**. Mọi giới hạn thật phải nằm trong code.
  - **Kiểm tra "bộ ba nguy hiểm":** một thành phần AI không được cùng lúc (A) đọc nội dung không tin cậy,
    (B) truy cập dữ liệu riêng tư, (C) thay đổi trạng thái hoặc gửi ra ngoài. Đủ cả ba → tách thành phần, hoặc mỗi hành động phải có người duyệt.
- **L2 · Lộ thông tin nhạy cảm (LLM02).** Chỉ gửi model các trường thật sự cần; lọc dữ liệu cá nhân trước khi gửi nhà cung cấp ngoài.
  Kiểm tra quyền **trước khi** truy xuất tài liệu. Lọc log/trace trước khi lưu. Bật chế độ không-huấn-luyện / không-lưu của nhà cung cấp nếu có.
- **L3 · Trao quá nhiều quyền (LLM03).** Số tool tối thiểu; mỗi tool làm đúng một việc; mặc định chỉ-đọc.
  Tránh tool mở (chạy shell tùy ý, tải URL tùy ý). Tool chạy dưới quyền của **đúng người dùng đang yêu cầu**.
  Quyết định "có được phép không" do code quyết, không hỏi AI. Hành động tầng Đỏ (mục 6) cần người duyệt.
- **L4 · Chuỗi cung ứng (LLM04).** Ghim phiên bản model và thư viện; nguồn xác minh được; tham chiếu bằng mã băm/phiên bản cố định, không `latest`.
  Không nạp model dạng pickle từ nguồn lạ. Duy trì `DEPENDENCIES.md`: model, package, dataset, MCP server, giấy phép.
- **L5 · Đầu độc dữ liệu (LLM05).** Dữ liệu nạp vào kho tri thức / fine-tune phải có nguồn gốc, được duyệt, có phiên bản để rollback.
  Không tự động "học" từ phản hồi người dùng khi chưa có người duyệt.
- **L6 · Tiêu tốn không giới hạn (LLM06).** Đặt `max_tokens`; giới hạn độ dài input; hạn mức token/phút và token/ngày theo người dùng;
  ước lượng token trước khi gọi; timeout; cắt gọn lịch sử hội thoại dài. Nhắc chủ dự án bật **trần chi tiêu cứng** (tự ngắt, không chỉ cảnh báo) ở nhà cung cấp.
- **L7 · Thông tin sai (LLM07).** Trả lời dựa trên nguồn, có trích nguồn, được phép nói "không biết".
  Quy tắc **Nhận định → Kiểm chứng → Hành động**: không hành động theo điều AI "cho là" đúng; kiểm tra trạng thái thật của hệ thống.
  Y tế, pháp lý, tài chính: có cảnh báo và người kiểm tra. Phân biệt "đã kiểm chứng" với "suy đoán".
- **L8 · Lộ hậu trường (LLM08).** Giả định mọi thứ trong context đều bị moi ra được. Không đặt bí mật, chuỗi kết nối, token trong prompt/context.
  Không dùng prompt để phân quyền hay lọc nội dung — dùng code và bộ lọc độc lập.
- **L9 · Kho vector (LLM09).** Bộ lọc theo người dùng/khách hàng nằm **trong câu truy vấn index**, không lọc sau.
  Tách index theo mức tin cậy (web công khai ≠ tài liệu nội bộ). Không trả điểm tương đồng cho client.
  Xóa tài liệu gốc → xóa embedding. Backup vector DB nhạy cảm ngang tài liệu gốc. Chuẩn hóa nội dung trước khi embed (ký tự ẩn, chữ trắng trên nền trắng).
- **L10 · Xử lý output (LLM10).** Đối xử với model như một người dùng lạ.
  Không đưa output vào `eval/exec/shell`. SQL luôn dùng tham số hóa. Encode theo ngữ cảnh (HTML, JS, SQL) trước khi hiển thị. Bật CSP.
  Tắt tự động tải ảnh Markdown / link preview từ domain ngoài (hoặc allowlist). Loại ký tự điều khiển (ANSI) trước khi ghi terminal/log. Code AI sinh ra không tự động triển khai.



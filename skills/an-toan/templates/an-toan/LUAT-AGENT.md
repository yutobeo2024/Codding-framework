# LUAT-AGENT.md — Nhóm A: hệ thống agent (OWASP ASI01–ASI10 · bản 2026)

> Phần mở rộng bắt buộc của `AGENTS.md`. Áp dụng cho dự án Cấp 3. Giữ file dưới 12.000 ký tự.
> Nguyên tắc nền: **tự chủ tối thiểu** — quyền tự quyết được cấp dần theo bằng chứng, không phải mặc định.

- **A1 · Bị cướp mục tiêu (ASI01).** Mục tiêu và giới hạn của agent cố định trong code/cấu hình, nội dung ngoài không thay đổi được.
  Ưu tiên hai vai: **agent đọc** (tiếp xúc nội dung ngoài, không có tool gây tác động, chỉ trả dữ liệu theo schema)
  và **agent hành động** (có tool, không đọc nội dung thô từ ngoài); ở giữa là lớp chính sách bằng code thường.
- **A2 · Dùng sai công cụ (ASI02).** Mỗi tool có schema tham số chặt và validate. Allowlist đích đến (domain, người nhận email, bảng dữ liệu).
  Hạn mức số lần gọi. Mỗi tool được gắn tầng Xanh/Vàng/Đỏ.
- **A3 · Danh tính và quyền (ASI03).** Agent có danh tính riêng, token ngắn hạn, phạm vi hẹp. Không dùng tài khoản admin hay khóa bỏ qua phân quyền mức hàng
  (ví dụ `service_role`). Giữ ngữ cảnh người dùng gốc qua mọi bước gọi nối tiếp.
- **A4 · Chuỗi cung ứng agent (ASI04).** MCP server, tool, skill: ghim phiên bản, xác minh nguồn, nằm trong danh sách đã được chủ dự án duyệt.
- **A5 · Tự chạy code (ASI05).** Code chạy trong sandbox dùng một lần: mặc định **không có mạng ra ngoài**, không có credential,
  giới hạn CPU/RAM/thời gian. Không tự deploy.
- **A6 · Đầu độc bộ nhớ (ASI06).** Ghi vào bộ nhớ dài hạn là thao tác đặc quyền: log nguồn gây ra lần ghi, không lưu "chỉ dẫn" đến từ nội dung ngoài,
  tách bộ nhớ theo người dùng, có giao diện xem / xóa / rollback bộ nhớ.
- **A7 · Giao tiếp giữa các agent (ASI07).** Thông điệp giữa agent được xác thực và validate theo schema.
  Agent không mặc định tin agent khác. Quyền không được "truyền miệng" qua lời nhắn.
- **A8 · Lỗi dây chuyền (ASI08).** Giới hạn số bước, độ sâu đệ quy, thời gian, chi phí mỗi lần chạy. Phát hiện vòng lặp.
  Cầu dao tự ngắt khi vượt ngưỡng. **Nút dừng khẩn cấp** mà con người bấm được.
- **A9 · Lợi dụng lòng tin con người (ASI09).** Màn hình duyệt hiện **đúng hành động và tham số thật**, không phải tóm tắt do AI viết.
  Không gộp nhiều hành động Đỏ vào một lần duyệt. Tránh hỏi duyệt tràn lan gây bấm đồng ý theo thói quen.
- **A10 · Agent mất kiểm soát (ASI10).** Log bất biến cho mọi lần gọi tool (ai yêu cầu, tool nào, tham số, kết quả).
  Agent không thể sửa log, quyền, hay cấu hình của chính nó. Nút dừng nằm ngoài tầm với của agent.



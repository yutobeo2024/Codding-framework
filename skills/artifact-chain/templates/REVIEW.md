# Hướng dẫn review

## Ba lượt (gắn nhãn lượt cho mỗi phát hiện)
- **Bug**: lỗi logic, trường hợp biên, hồi quy ngầm
- **Bảo mật**: injection, thiếu xác thực/phân quyền, PII hoặc secrets trong log
- **Tuân thủ**: diff khớp `spec.md`, `plan.md` và nguyên tắc thiết kế của dự án

## "Quan trọng" nghĩa là
Làm hỏng hành vi, rò rỉ dữ liệu, hoặc vi phạm chính sách. Phong cách và đặt tên là "Vặt".

## Giới hạn mục Vặt
Tối đa 5 mục mỗi lần review; phần còn lại chỉ ghi số lượng.

## Không báo cáo
- File sinh tự động: `<đường dẫn>`
- Những gì CI đã cưỡng chế (format, lint)

## Phê duyệt
Phát hiện không tự duyệt hay chặn PR. Code owner duyệt qua branch protection.

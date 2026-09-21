---
name: tdd-loop
description: Vòng lặp đỏ → xanh → dọn để triển khai tính năng hoặc sửa bug sao cho agent tự kiểm chứng được công việc của mình. Dùng khi chạy /sdlc:build hoặc /sdlc:quick, khi người dùng nói "sửa bug", "fix lỗi", "viết test trước", "TDD", "tái hiện lỗi", hoặc bất cứ lúc nào sắp viết code mà chưa có cách khách quan để biết nó chạy đúng.
---
# TDD loop

Nguyên tắc: không có bằng chứng từ công cụ thì chưa xong. Bằng chứng là output thật của lệnh test/build, không phải lời khẳng định.

## Vòng lặp cho một bước nhỏ
1. **Đỏ**: viết MỘT test mô tả hành vi mong muốn. Chạy. Xác nhận nó thất bại vì ĐÚNG lý do (thiếu hành vi), không phải vì lỗi cú pháp hay import.
2. **Xanh**: viết lượng code ít nhất để test qua. Chạy lại cả bộ test liên quan.
3. **Dọn**: bỏ trùng lặp, đặt lại tên, giữ test xanh. Không thêm tính năng ở bước này.
4. Lặp lại cho hành vi kế tiếp. Mỗi vòng nên commit được.

## Sửa bug
1. Tái hiện bug bằng test trước. Chưa tái hiện được thì chưa hiểu bug: quay lại điều tra.
2. Test đỏ phải được commit TRƯỚC bản sửa. Test tồn tại từ trước và agent không sửa được nó chính là bằng chứng bug đã hết.
3. Bật fix-mode (tạo `.sdlc/fix-mode`) để hook chặn mọi chỉnh sửa file test.
4. Sửa code tới khi xanh. Tin rằng test sai thì DỪNG và giải thích, không tìm cách lách.

## Cấm
- Xoá, skip, hoặc nới lỏng assertion để test qua.
- Mock chính thứ đang cần kiểm tra.
- Sửa code và test trong cùng một bước khi đang ở fix-mode.
- Báo "xong" mà không dán output.

## Việc giao diện
Đóng vòng bằng hình ảnh: triển khai → chụp màn hình (công cụ trình duyệt/MCP nếu có) → so với mockup → chỉnh. Hai đến ba vòng là bình thường.

## Khi repo chưa có test
Nói rõ điều đó. Đề xuất bộ khung test nhỏ nhất và một lệnh duy nhất để chạy, ghi lệnh vào CLAUDE.md. Không lặng lẽ bỏ qua bước kiểm chứng.

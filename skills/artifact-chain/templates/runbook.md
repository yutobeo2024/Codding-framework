# Runbook: <tên app>

Chỉ ghi điều đã kiểm chứng bằng cách chạy thật. Chưa chắc thì để ở "Chưa biết".
Cấu trúc theo `docs/templates/application-runbook.md` của Harness, rút gọn.

## App này là gì
<Một hai câu, lời thường.>

## Cần có trước
- <runtime, phiên bản> (kiểm tra: `<lệnh>`)
- <dịch vụ / file cấu hình / biến môi trường, KHÔNG ghi giá trị bí mật>

## Chạy
- Lệnh: `<lệnh>`
- Mở ở: `<địa chỉ / cổng>` (cố định | mặc định | cấu hình ở `<file>`)
- Ghi dữ liệu ở: `<đường dẫn / db>`

## Biết là đã chạy xong khi
<Dòng log hoặc trang hiện ra.>

## Dữ liệu mẫu / trạng thái sạch
<Cách tạo hoặc reset dữ liệu để thử, không đụng dữ liệu thật.>

## Thử bằng tay
<Mở trang nào, bấm gì, gõ lệnh gì.>

## Xem lỗi ở đâu
<Log, console, lệnh xem.>

## Tắt và dọn
<Chỉ tắt những gì lần chạy này đã mở.>

## Kiểm tra tự động
- Test: `<lệnh>` (thoát mã khác 0 khi thất bại)
- Lint/build: `<lệnh>`

## Chưa biết
- <điều agent không được tự đoán>

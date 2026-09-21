<!-- HARNESS:BEGIN -->
## Harness

Claude Code does not auto-load `AGENTS.md`. Import that single canonical
project instruction source. Keep this bare `@` line outside backticks so the
import remains active.

@AGENTS.md
<!-- HARNESS:END -->

# <Tên dự án>

## Lệnh
- Build: `<lệnh>` (khoẻ mạnh khi thấy: "<dòng output>")
- Test: `<lệnh>` (thoát mã khác 0 khi thất bại)
- Lint: `<lệnh>`
- Chạy app: xem `docs/runbook.md`

## Quy ước
- <ngôn ngữ, phiên bản, thư viện được/không được dùng>
- <quy tắc đặt tên, cấu trúc module>

## Kiến trúc
- `<thư mục>/`: <vai trò>

## Claude hay làm sai
- <Ghi triệu chứng khi cùng một lỗi xảy ra lần thứ hai. Sửa hướng dẫn có bằng chứng bằng `/sdlc:improve`.>

## Tự kiểm tra trước khi báo xong
Chạy build, test, lint và DÁN output. Test đỏ thì sửa code, không sửa hay xoá test.
Quy trình tỉ lệ với cỡ việc: việc nhỏ làm ngay và kiểm chứng; việc dài dùng một plan
(`docs/plans/active/` ở chế độ vibe, `sdlc/<slug>/` ở chế độ kỹ sư). Chỉ chuỗi `sdlc/`
mới yêu cầu `plan.md` được duyệt trước khi viết code.
Quyết định sản phẩm còn mở thì dừng và hỏi; mặc định của công cụ không phải thẩm quyền.

<!-- Giữ file này dưới một trang. Thứ gì cũ thì xoá. -->

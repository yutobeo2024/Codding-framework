---
description: "Giai đoạn 3b+4 (Build+Test): triển khai theo plan.md đã duyệt, tự kiểm tra bằng test. Thêm --fix khi sửa bug"
argument-hint: "<slug> [--fix]"
---
Tham số: $ARGUMENTS

Cổng vào: `sdlc/<slug>/plan.md` phải có `status: accepted`. Nếu chưa, DỪNG.

Chế độ thường:
1. Làm theo đúng "Thứ tự công việc" trong plan, từng bước nhỏ. Dùng skill `tdd-loop`: viết test trước, chạy thấy đỏ, viết code, chạy thấy xanh.
2. Sau mỗi bước chạy lệnh test/lint ghi trong CLAUDE.md. Test đỏ thì sửa CODE, không sửa hay xoá test để cho qua.
3. Lệch khỏi plan thì cập nhật `plan.md` trong CÙNG commit, thêm mục "Thay đổi so với plan ban đầu" kèm lý do.

Chế độ `--fix` (sửa bug):
1. Viết test tái hiện bug. Chạy, xác nhận nó ĐỎ đúng vì lý do mong đợi. Đề nghị người dùng commit test đó.
2. Sau khi test đỏ đã commit: tạo file `.sdlc/fix-mode` (nội dung: slug + thời điểm). Từ đây hook sẽ chặn mọi chỉnh sửa file test.
3. Sửa code cho tới khi test xanh. Nếu tin rằng chính test sai: DỪNG, giải thích, để người dùng quyết định.
4. Xong thì nhắc người dùng gõ `/sdlc:fix-done` (hoặc tự chạy `rm .sdlc/fix-mode`); agent không được tự gỡ.

Kết thúc (cả hai chế độ):
- Gọi subagent `verifier` để kiểm tra độc lập trong ngữ cảnh mới.
- Báo cáo: đã đổi gì, DÁN NGUYÊN output của lệnh test/build, điểm nào lệch plan, việc còn dang dở. Không có output test thì không được nói "xong".
- Đề xuất mở PR lên nhánh riêng (không push thẳng nhánh chính). Bước kế tiếp: `/sdlc:review <slug>`.

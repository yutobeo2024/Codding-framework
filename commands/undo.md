---
description: "Quay về một mốc đã lưu trước đó, không làm mất gì. Chỉ người dùng gõ lệnh này"
argument-hint: "[số mốc muốn lùi, mặc định hỏi]"
disable-model-invocation: true
---
Tham số: $ARGUMENTS

Người dùng muốn hoàn tác. Làm lần lượt, giải thích bằng lời thường:

1. Có thay đổi chưa lưu (`git status --porcelain` không rỗng): commit chúng thành `wip: trước khi hoàn tác` để không mất gì.
2. Tạo nhánh sao lưu tại vị trí hiện tại: `git branch backup/undo-<YYYYMMDD-HHMMSS>`.
3. Liệt kê 5 mốc gần nhất (`git log -5 --format="%h %ar %s"`), đánh số 1 đến 5, mỗi dòng: bao lâu trước + việc đã làm (lời thường). Nếu tham số là một số N thì chọn mốc lùi N bước; nếu trống, hỏi người dùng muốn về mốc nào (đề xuất mốc ngay trước).
4. Chọn cách lùi:
   - Đang ở nhánh `vibe/*` và mốc đích CHƯA được đẩy lên remote (`git branch -r --contains <mốc>` rỗng hoặc không có remote): `git reset --hard <mốc>`.
   - Đang ở main/master, hoặc các commit sẽ bỏ đã được đẩy lên remote: KHÔNG reset. Dùng `git revert --no-edit <mốc>..HEAD` để tạo commit đảo ngược.
5. Kiểm tra lại: chạy lệnh test trong `CLAUDE.md` nếu có, báo kết quả một dòng.
6. Báo: "Đã về mốc: <mô tả>. Bản trước khi hoàn tác vẫn được giữ ở nhánh `backup/undo-…`. Muốn lấy lại thì nói 'lấy lại bản trước khi hoàn tác'."

Không xoá nhánh sao lưu. Không đụng `.sdlc/` (trạng thái cục bộ).

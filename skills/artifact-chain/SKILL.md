---
name: artifact-chain
description: Quy ước chuỗi artifact của AI-native SDLC (intent.md → spec.md → plan.md → diff/PR → lessons) và các template đi kèm. Dùng skill này bất cứ khi nào tạo, đọc, duyệt hoặc cập nhật file trong thư mục sdlc/, khi chạy bất kỳ lệnh /sdlc:*, khi người dùng nhắc tới intent, spec, plan, "viết yêu cầu", "lập kế hoạch triển khai", hoặc hỏi một thay đổi đang ở giai đoạn nào.
---
# Chuỗi artifact

Mỗi giai đoạn KẾT THÚC bằng một file được commit, giai đoạn sau BẮT ĐẦU bằng việc đọc file đó. Chuỗi commit chính là dấu vết kiểm toán: ai yêu cầu gì, agent tạo ra gì, ai duyệt.

## Hai chế độ, một nơi plan cho mỗi việc

- **Kỹ sư** (`/sdlc:intent` → `spec` → `plan` → `build` → `review`): dùng chuỗi `sdlc/<slug>/` dưới đây, cổng `status: accepted` do con người đổi.
- **Vibe** (`/sdlc:vibe`, người dùng không biết code): KHÔNG tạo `sdlc/<slug>/`. Dùng bố cục của lõi Harness: ý định và tiêu chí "Khi xong bạn sẽ thấy…" ở `docs/product/<slug>.md`, lựa chọn lâu dài ở `docs/decisions/`, việc dài ở `docs/plans/active/<slug>.md` (template `docs/templates/exec-plan.md`), cách chạy app ở `docs/runbook.md`. Cổng người là bảng tiêu chí và các lựa chọn sản phẩm, không phải file kỹ thuật.

Một thay đổi chỉ có MỘT nơi plan. Không chép cùng nội dung sang nơi kia.

## Bố cục trong repo

```
AGENTS.md           # khối HARNESS (lõi, do harness update quản) + khối SDLC (plugin)
CLAUDE.md           # @AGENTS.md + lệnh build/test/lint
docs/               # lõi Harness: WORKFLOW, product/, decisions/, plans/, templates/, runbook.md
sdlc/               # chế độ kỹ sư
├── <slug>/
│   ├── intent.md   # muốn gì, vì sao, ràng buộc (lời của người nêu ý tưởng)
│   ├── spec.md     # yêu cầu + thiết kế, có "Điểm đáng lo"
│   └── plan.md     # file đổi, thứ tự, rủi ro, bằng chứng
├── lessons.md      # bài học sau sự cố
└── bands.yaml      # ngưỡng giám sát (mẫu)
.sdlc/              # trạng thái cục bộ: fix-mode, test-patterns.txt, gate-patterns.txt
```

Template của plugin nằm trong `templates/` cạnh file này (kể cả `AGENTS-sdlc-block.md`, `runbook.md`). Luôn đọc template rồi điền, không tự chế cấu trúc khác.

## Frontmatter bắt buộc

```yaml
---
slug: claims-status
status: draft          # draft | accepted | superseded
author: <người nêu ý tưởng / người chạy lệnh>
created: YYYY-MM-DD
accepted_by:           # chỉ điền khi CON NGƯỜI nói rõ là chấp nhận
source: human          # human | ticket | triage
links: []              # mã ticket Jira, URL PR... nếu hệ thống cũ là nguồn sự thật
---
```

## Luật cổng (gate) — áp dụng cho chuỗi `sdlc/<slug>/`

1. Giai đoạn sau chỉ chạy khi artifact trước có `status: accepted`. Chưa có thì dừng và nói rõ thiếu gì.
2. Agent KHÔNG BAO GIỜ tự đổi `status` thành `accepted`. Chỉ đổi khi người dùng nói rõ trong phiên này, và ghi tên họ vào `accepted_by`.
3. Sửa artifact đã accepted: đưa `status` về `draft`, ghi mục "Lịch sử thay đổi" ở cuối file, xin duyệt lại.
4. Code lệch plan thì sửa `plan.md` trong cùng commit.
5. Điều chưa biết thì ghi vào "Câu hỏi mở". Không bịa.

## Thông điệp commit

`intent(<slug>): …` · `spec(<slug>): …` · `plan(<slug>): …` · `feat|fix(<slug>): …` · `rule(<tên>): …` · `chore(harness): …`
Nhờ vậy `git log --grep "(<slug>)"` cho ra toàn bộ lịch sử một thay đổi, và đo được thời gian giữa các giai đoạn bằng dấu thời gian commit.

## Khi đã có Jira / hệ thống yêu cầu khác

Mỗi loại artifact chỉ có MỘT nguồn sự thật. Mức tối thiểu: artifact ghi mã bản ghi vào `links`, bản ghi bên kia ghi SHA commit của file markdown.

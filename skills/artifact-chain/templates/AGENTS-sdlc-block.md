<!-- SDLC:BEGIN -->
## SDLC (plugin sdlc cho Claude Code)

Repo này dùng lõi Harness ở trên làm nền và plugin `sdlc` làm lớp quy trình. Hai chế độ:

- **Vibe** (`/sdlc:vibe`, người dùng có thể không biết code): người dùng chỉ quyết
  định sản phẩm (muốn gì, đúng/sai trông ra sao). Agent lo kỹ thuật, git và bằng
  chứng. Cổng người duy nhất là bảng "Khi xong bạn sẽ thấy…" và các lựa chọn sản
  phẩm còn mở. Bố cục theo Harness: ý định và tiêu chí ở `docs/product/<slug>.md`,
  lựa chọn lâu dài ở `docs/decisions/`, việc dài ở `docs/plans/active/<slug>.md`
  (nơi plan duy nhất, không tạo `sdlc/<slug>/`), cách chạy app ở `docs/runbook.md`.
  Làm trên nhánh `vibe/<slug>`, commit mốc sau mỗi bước test xanh; `/sdlc:undo`
  để quay lại. Việc nhỏ làm ngay, không thủ tục.
- **Kỹ sư** (`/sdlc:intent` → `spec` → `plan` → `build` → `review`): chuỗi
  artifact `sdlc/<slug>/` với cổng `status: accepted` do con người đổi. Chỉ chuỗi
  này mới yêu cầu `plan.md` được duyệt trước khi viết code.

Chung cho cả hai:
- Quyết định sản phẩm còn mở → dừng trước khi sửa, đưa lựa chọn cụ thể. Giá trị
  mặc định của công cụ không phải thẩm quyền.
- "Không bao giờ được…" → `/sdlc:rule` (encode-invariant). Repo lạ → `/sdlc:onboard`.
  Ma sát lặp lại → báo cáo, chỉ sửa hướng dẫn khi được gọi `/sdlc:improve`.
- Xong chỉ khi có bằng chứng quan sát được; báo cáo tách sự thật, giới hạn, phần chưa làm.
- Hook của plugin chặn: sửa test khi đang fix-mode, push thẳng main, force push,
  deploy production khi chưa có `RELEASE_APPROVAL`. Gỡ fix-mode: người dùng gõ `/sdlc:fix-done`.
<!-- SDLC:END -->

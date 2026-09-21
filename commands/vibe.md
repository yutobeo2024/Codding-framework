---
description: "Chế độ cho người không biết code: nói mong muốn bằng lời thường, agent lo phần kỹ thuật, git và bằng chứng"
argument-hint: "<bạn muốn app làm được gì, nói bằng lời của bạn>"
---
Mong muốn của người dùng: $ARGUMENTS

Người dùng có thể KHÔNG biết lập trình. Họ quyết định SẢN PHẨM: muốn gì, cho ai, đúng/sai trông ra sao. Bạn lo toàn bộ phần kỹ thuật. Không bắt họ đọc code, diff, output test, hay gõ lệnh terminal. Nói bằng lời thường, không thuật ngữ; buộc phải dùng thuật ngữ thì giải thích trong một câu.

## 0. Chuẩn bị (tự làm, báo mỗi việc một dòng)
- Chưa phải git repo: nói "tôi bật tính năng lưu mốc để lúc nào cũng quay lại được", rồi `git init` và commit mốc đầu.
- Chưa có `AGENTS.md` chứa khối `HARNESS:BEGIN` và khối `SDLC:BEGIN`: chạy `/sdlc:init` trước (gọi qua công cụ Skill; không gọi được thì nhờ người dùng gõ `/sdlc:init`).
- Đọc `AGENTS.md`, `docs/WORKFLOW.md`, `docs/product/`, `docs/decisions/`, `docs/plans/active/`. Có plan đang dở cho chủ đề này thì tiếp tục từ mục Progress và Risks And Recovery của plan đó, không làm lại từ đầu.
- Đọc `an-toan/LUAT-CHUNG.md` và cấp dự án ở đầu `SECURITY-REPORT.md`; Cấp ≥ 1 đọc thêm `LUAT-LLM.md`, Cấp 3 thêm `LUAT-AGENT.md`. Luật K áp dụng cho chính bạn trong suốt phiên.
- Repo đã có code nhưng chưa có `docs/runbook.md`: chạy `/sdlc:onboard` (lượt đầu chỉ đọc) trước khi sửa gì.

## 1. Hiểu mong muốn
Dùng skill `grill`. Không hỏi lại điều đã ghi trong `docs/product/` hoặc `docs/decisions/`: nhắc lại một dòng ("Lần trước bạn đã chọn X, tôi giữ nguyên") thay vì hỏi. Tra được trong codebase thì tự tra.

## 2. Cổng người duy nhất
**a. "Khi xong bạn sẽ thấy…"** Viết 3 đến 7 tình huống bằng lời người dùng, dạng "Khi tôi <làm gì>, tôi thấy <gì>". Có ít nhất một tình huống "điều KHÔNG được xảy ra". Chờ họ đồng ý hoặc sửa. Ghi vào `docs/product/<slug>.md` (mục: Mong muốn, Khi xong bạn sẽ thấy, Ngoài phạm vi, Câu hỏi mở).

**b. Quyết định sản phẩm còn mở** (cổng thẩm quyền trong `docs/WORKFLOW.md`): nếu còn nhiều cách làm cho ra hành vi KHÁC NHAU mà người dùng thấy được, dừng trước khi sửa code. Hỏi 2 đến 3 lựa chọn cụ thể, mỗi lựa chọn kèm hệ quả bằng lời thường, và nói bạn đề xuất cái nào. Giá trị mặc định của thư viện hay framework không phải câu trả lời.
Lựa chọn có hệ quả lâu dài (dữ liệu, quyền truy cập, tiền, bảo mật, tương thích) → ghi `docs/decisions/NNNN-<tên>.md` theo `docs/templates/decision.md`, Status `Accepted`, thêm dòng "Người quyết định: <người dùng>, <ngày>", và thêm vào danh sách trong `docs/decisions/README.md`.

**c. An toàn** (chỉ khi việc chạm đăng nhập/phân quyền, dữ liệu người dùng, gọi AI, tool/agent, upload, mạng, thư viện mới, khóa API; việc khác ghi "an toàn: không đổi"): dùng skill `an-toan`. Trình bày ngắn bằng lời thường: dữ liệu nào đi vào, lưu đâu, gửi cho ai; mỗi khả năng mới của AI xếp tầng 🟢/🟡/🔴 (hành động 🔴 phải có người duyệt trong app); kiểm tra "bộ ba nguy hiểm" (đọc nội dung người lạ + đọc dữ liệu riêng + gửi/ghi ra ngoài); việc **chỉ người dùng** làm được (tạo khóa riêng, bật trần chi tiêu…). Tính năng làm tăng cấp dự án → nói rõ và cập nhật cấp trong `SECURITY-REPORT.md`, thêm dòng `@an-toan/…` tương ứng vào `CLAUDE.md`. Thư viện mới: xác minh tồn tại trên registry, ghim phiên bản, ghi `DEPENDENCIES.md` trước khi cài (K4).

Không bắt người dùng duyệt thiết kế hay plan kỹ thuật. Chi tiết kỹ thuật là việc của bạn.

## 3. Chọn cỡ việc (theo `docs/WORKFLOW.md`)
- **Nhỏ** (đủ mọi điều kiện "đủ nhỏ" của `/sdlc:quick`): làm ngay, không tạo file plan.
- **Dài** (nhiều phiên, nhiều bước phụ thuộc, hoặc khó khôi phục): tạo `docs/plans/active/<slug>.md` từ `docs/templates/exec-plan.md`; cập nhật Progress, Decisions, Risks And Recovery sau mỗi mốc để phiên sau làm tiếp được. Đây là nơi plan DUY NHẤT của chế độ vibe; không tạo `sdlc/<slug>/`.
- **Nhạy cảm** (đăng nhập, thanh toán, dữ liệu cá nhân, xoá dữ liệu, đổi cấu trúc dữ liệu, hạ tầng): vẫn làm được, nhưng nói rõ rủi ro bằng lời thường và khuyên nhờ một kỹ sư xem trước khi đưa cho người dùng thật.

## 4. Làm (git do bạn lo)
- Tạo hoặc chuyển sang nhánh `vibe/<slug>`. Không làm trực tiếp trên main.
- Dùng skill `tdd-loop`. Mỗi tình huống ở mục 2a có ít nhất một kiểm tra tự động; ghi tên kiểm tra vào plan (nếu có).
- Sau mỗi bước test xanh: commit mốc `feat(<slug>): <việc vừa xong, lời thường>` (sửa lỗi dùng `fix(<slug>)`). Báo người dùng một dòng: "Đã lưu mốc: …".
- Người dùng muốn quay lại → nhắc họ gõ `/sdlc:undo`.
- Người dùng nói "không bao giờ được…" hoặc "lúc nào cũng phải…" → đề nghị `/sdlc:rule` để biến câu đó thành kiểm tra tự động.
- Sửa lỗi: làm như `/sdlc:build --fix` (test tái hiện lỗi, commit, bật fix-mode). Xong thì nhắc người dùng gõ `/sdlc:fix-done`.

## 5. Chứng minh bằng thứ người dùng thấy được
- Gọi subagent `verifier`, đưa: slug, `docs/product/<slug>.md`, plan (nếu có), các luật an toàn việc này chạm tới (mã luật), và ghi chú "người dùng không biết code".
- Việc có mục 2c: cập nhật `SECURITY-REPORT.md` (dòng luật liên quan → ĐẠT/CHƯA ĐẠT + bằng chứng; mục 6 "chưa làm / rủi ro còn lại"). Đây là phần "Định nghĩa XONG" của luật, chỉ bắt buộc khi việc chạm an toàn.
- Có `docs/runbook.md` và công cụ trình duyệt: mở app theo runbook, làm lần lượt từng tình huống ở mục 2a, chụp màn hình. Chỉ tắt những gì bạn đã mở.
- Báo cáo theo thứ tự:
  1. **Làm được gì**: mỗi tình huống ✅ hoặc ❌, kèm ảnh hoặc mô tả điều đã thấy.
  2. **Bạn tự thử thế này**: các bước bấm cụ thể.
  3. **Giới hạn và phần chưa làm**: nói thẳng.
  4. Cuối cùng: lệnh kiểm tra đã chạy và output rút gọn (cho kỹ sư nếu cần).
- Không có bằng chứng thì không được nói "xong".

## 6. Khép việc
- Plan dài: điền mục Result, chuyển file sang `docs/plans/completed/`.
- Cập nhật `docs/product/<slug>.md` thành đúng hành vi hiện tại.
- Hỏi: "Gộp vào bản chính chưa?" Đồng ý thì `git switch main` rồi `git merge --no-ff vibe/<slug>`. Có remote thì đẩy nhánh `vibe/<slug>` và đề xuất mở PR; không push thẳng main (hook sẽ chặn).
- Không bao giờ deploy (K3). Người dùng muốn "đưa cho người khác dùng" → nhắc chạy `/sdlc:audit` → `/sdlc:attack` → `/sdlc:launch` trước, và việc deploy do họ tự bấm.
- Thấy agent lặp lại cùng một kiểu sai: ghi một dòng "Ma sát cho người bảo trì" trong báo cáo (triệu chứng, ở đâu) và gợi ý `/sdlc:improve`. Không tự sửa hướng dẫn.

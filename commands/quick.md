---
description: "Đường tắt cho thay đổi nhỏ: bỏ qua intent/spec, chỉ plan ngắn + test. Tự từ chối nếu việc không đủ nhỏ"
argument-hint: "<mô tả thay đổi> [--fix]"
---
Yêu cầu: $ARGUMENTS

Trước tiên kiểm tra điều kiện "đủ nhỏ". Nếu BẤT KỲ điều nào sai, từ chối đường tắt và chuyển sang `/sdlc:intent`:
- Chạm không quá khoảng 3 file và không đổi API/schema công khai.
- Không đụng auth, thanh toán, migration, hạ tầng, dữ liệu cá nhân.
- Có test hiện hữu bao phủ vùng này, hoặc viết được test trong vài phút.
- Không cần quyết định sản phẩm nào.

Nếu đủ nhỏ:
1. Viết plan 5 đến 10 dòng ngay trong chat (file đổi, test chứng minh, rủi ro). Chờ người dùng đồng ý.
2. Triển khai bằng skill `tdd-loop`. Có `--fix` thì theo đúng quy trình fix-mode của `/sdlc:build --fix`.
3. Chạy test/lint, dán output, đề xuất commit và PR. Trong mô tả PR ghi `sdlc: quick` để truy vết.

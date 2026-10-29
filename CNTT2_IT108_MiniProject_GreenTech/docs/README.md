# Hệ thống quản lý hạ tầng GreenTech

Bài thực hành tổng hợp Nhập môn CNTT: tổ chức thư mục, lọc log bằng CMD, tài liệu Word và đối soát thiết bị Excel. Toàn bộ dữ liệu là dữ liệu mô phỏng phục vụ bài tập; giá linh kiện không phải báo giá thị trường.

## Chạy nhanh trên Windows

1. Giải nén vào đường dẫn không dấu, không khoảng trắng, ví dụ `D:\bai-tap\greentech-system`.
2. Mở CMD trong thư mục gốc. Chạy:

```bat
cd scripts
auto_report.bat
```

Script tự chạy `audit.ps1` trước khi lọc; Windows PowerShell là thành phần có sẵn trên Windows 10/11. Có thể chạy trong PowerShell bằng `cd scripts` rồi `.\auto_report.bat`. Mọi đường dẫn dữ liệu trong script là đường dẫn tương đối, bắt đầu từ thư mục scripts.

## Module 1 Khởi tạo bằng một dòng lệnh

Chạy dòng sau trong CMD tại thư mục cha. Dòng lệnh tạo đủ gốc, bốn thư mục con và file `.env` nếu chưa tồn tại, giữ nguyên dữ liệu cũ.

```bat
for %D in (greentech-system greentech-system\docs greentech-system\scripts greentech-system\data greentech-system\backup) do @if not exist "%D" mkdir "%D"
```

Sau đó dùng đường dẫn tương đối để tạo cấu hình mẫu:

```bat
cd greentech-system
if not exist "data\.env" (echo SYSTEM_KEY=demo_greentech_2026)>"data\.env"
```

Hoặc dùng MỘT dòng tạo cả cây và cấu hình:

```bat
cmd /c "for %D in (greentech-system greentech-system\docs greentech-system\scripts greentech-system\data greentech-system\backup) do @if not exist %D mkdir %D" & if not exist greentech-system\data\.env (echo SYSTEM_KEY=demo_greentech_2026)>greentech-system\data\.env
```

Trong file batch phải viết `%%D` thay vì `%D`. Tệp `scripts/init.bat` là bản tương đương có thể chạy từ thư mục cha bằng `greentech-system\scripts\init.bat`. Khởi tạo chỉ tạo khung; các tài liệu và mã nguồn được cung cấp trong ZIP này.

## Checklist kiểm tra

- [x] Thư mục dùng kebab-case, không dấu, không khoảng trắng.
- [x] Có đủ docs, scripts, data, backup và cấu hình data/.env.
- [x] Có log mẫu 120 dòng, 6 ERROR và 6 CRITICAL.
- [x] Có báo cáo mẫu 12 dòng sự cố, khớp log nguồn.
- [x] Script dùng echo, pipe, findstr và toán tử nối `>>`.
- [x] Có bước audit trước khi tạo báo cáo.
- [x] Excel có 100 trạm, 300 dòng linh kiện, TRIM và VLOOKUP FALSE.
- [x] Excel có AutoFilter, không merge hoặc hàng trống giữa dữ liệu.
- [x] Word có Heading 1 2 3 và trường mục lục tự động ở trang đầu.
- [ ] Chạy lại script trên máy Windows của người nộp.
- [ ] Điền lớp và mã sinh viên, đổi tên thư mục bài nộp theo yêu cầu.

## Thông số phần cứng mô phỏng

| Hạng mục | Thông số | Vai trò |
| --- | --- | --- |
| CPU | Core i5 12400 hoặc Ryzen 5 5600 | Xử lý và tổng hợp log |
| RAM | DDR4 8 hoặc 16 GB | Bộ nhớ làm việc |
| Lưu trữ | SSD 256/512 GB hoặc HDD 1/2 TB | Giữ log và báo cáo |
| Mạng | Giả định 100 Mbps | Tải log |
| Log | 500 MB hệ thập phân | Dùng tính thời gian tải |

100 Mbps / 8 = 12,5 MB/s; 500 MB / 12,5 MB/s = **40 giây** lý thuyết. Không cộng dung lượng RAM hoặc coi Mbps là MB/s. Thực tế còn phụ thuộc giao thức, ổ đĩa và tải mạng. Sheet `tinh-tai-log` cho phép thay đổi đầu vào.

## Excel

Mở `data/quan-ly-thiet-bi.xlsx`:

- `danh-muc-linh-kien`: ma_linh_kien là khóa chính, thêm tên, đơn giá VNĐ và loại storage.
- `trang-thai-tram`: mỗi trạm có 3 dòng CPU, RAM, storage; mã trạm có thể lặp. Khóa của một dòng là cặp (ma_tram, ma_linh_kien_sach).
- Cột E: `=TRIM(B2)`; cột F: `=VLOOKUP(E2,'danh-muc-linh-kien'!$A$2:$D$9,2,FALSE)`.
- Cột G, H tra đơn giá và loại storage; cột I đếm mã hợp lệ. Khoảng trắng cố ý được thêm ở 10 trạm để minh họa TRIM.
- Mã chưa tồn tại phải được bổ sung vào danh mục; không dùng tra gần đúng hoặc giấu lỗi bằng số 0. Khi thêm danh mục ngoài hàng 9, mở rộng vùng tra cứu trong công thức.
- `dung_luong_ram` là tổng RAM của trạm, lặp ở 3 dòng; không cộng cột này để tính RAM toàn hệ thống.
- Giá là dữ liệu giả lập, chưa gồm thuế. Ngày lưu dạng ngày Excel, hiển thị yyyy-mm-dd.

## Word và mục lục

`tai-lieu-quan-tri-he-thong.docx` có mục lục tự động dạng TOC trên trang đầu và Heading 1/2/3. Trong Word, nhấn Ctrl+A rồi F9, chọn cập nhật toàn bộ mục lục sau khi sửa. Nội dung gồm IPO, DIKW, thiết kế, vận hành, công thức và nghiệm thu.

## Log lớn và tính nhất quán

File mẫu chỉ 120 dòng để ZIP nhẹ. Script không gán toàn bộ nội dung file vào biến; `type | findstr` xử lý theo dòng và đếm bằng lượt đọc thứ hai. Không chỉnh sửa log trong khi chạy vì hai lượt đọc có thể khác nhau. Mỗi dòng chứa cả ERROR và CRITICAL vẫn chỉ được tính một lần. TIMEOUT đơn lẻ không được lọc; log mẫu dùng mức CRITICAL cho TIMEOUT đúng yêu cầu module.

Tạo riêng log đúng 500.000.000 byte nếu muốn thử tải lớn (cần dung lượng đĩa):

```powershell
cd scripts
powershell -NoProfile -ExecutionPolicy Bypass -File .\create-large-log.ps1 -SizeMB 500
```

Script tạo `data/log-large-demo.log` và từ chối ghi đè. Muốn dùng làm đầu vào, sao lưu log mẫu rồi đổi tên thủ công; đây là bước tùy chọn. Không gửi file 500 MB lên GitHub.

## Audit và mã kết thúc

Audit tĩnh đọc các dòng lệnh của auto_report.bat, bỏ dòng chú thích, chặn nhóm lệnh xóa/phá hủy, thực thi chuỗi và tải lệnh. Không xem audit này là sandbox cho mã không tin cậy. Script không xóa dữ liệu; mỗi lần chạy nối một phiên vào báo cáo, tổng số thuộc phiên đó.

| Mã | Ý nghĩa |
| --- | --- |
| 0 | Thành công, kể cả không có lỗi trong log |
| 2 | Không vào được thư mục scripts |
| 3 | Audit không đạt hoặc PowerShell không chạy được |
| 4 | Thiếu log nguồn |
| 5 | FINDSTR gặp lỗi xử lý |
| 6 | Không tạo được thư mục hoặc mở được báo cáo |

Chỉ có thể phát hiện một số lỗi ghi; nếu ổ đĩa đầy giữa lượt ghi, kiểm tra lại file và chạy lại sau khi giải phóng dung lượng. Báo cáo không có cơ chế khóa khi chạy đồng thời.

## Nộp lên GitHub

Đề yêu cầu repository GitHub nhưng bạn chưa cung cấp tài khoản hoặc kho đích. Bộ ZIP có cấu trúc sẵn để tải lên kho của bạn. Đổi tên thư mục ngoài cùng theo mẫu trong đề bằng lớp và mã sinh viên thật, giữ nguyên tên các thư mục con. `.env` được kèm trong ZIP với khóa demo và bị loại khỏi Git để tránh đưa khóa thật lên kho.

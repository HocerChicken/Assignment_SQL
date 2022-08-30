﻿CREATE DATABASE QUANLI_SANBONG3
GO
USE QUANLI_SANBONG3
GO 
CREATE TABLE SANBONG(
	MASANBONG CHAR(15),
	TENSANBONG NVARCHAR(200),
	LOAISAN NVARCHAR(50),
	PRIMARY KEY(MASANBONG)
)

CREATE TABLE DICHVU(
	MADICHVU CHAR(15),
	TENDICHVU NVARCHAR(200),
	SOLUONG INT,
	DONGIA MONEY,
	PRIMARY KEY(MADICHVU)
)

CREATE TABLE GIATIENTHUESAN(
	MAGIATIEN CHAR(15),
	TUGIO TIME,
	DENGIO TIME,
	SOTIEN MONEY,
	PRIMARY KEY(MAGIATIEN)
)

CREATE TABLE THUESAN(
	MATHUESAN CHAR(15),
	DIENTHOAIKH NVARCHAR(20),
	MASANBONG CHAR(15),
	NGAYTHUESAN DATE,
	GIOBATDAU TIME,
	GIOKETTHUC TIME, 
	TONGTIEN MONEY,
	PRIMARY KEY(MATHUESAN) ,
	FOREIGN KEY (MASANBONG) REFERENCES SANBONG(MASANBONG)
)

CREATE TABLE CHITIETTHUESAN(
	MATHUESAN CHAR(15),
	MADICHVU CHAR(15),
	SOLUONG INT,
	DONGIA MONEY,
	PRIMARY KEY (MATHUESAN, MADICHVU),
	FOREIGN KEY (MATHUESAN) REFERENCES THUESAN(MATHUESAN),
	FOREIGN KEY (MADICHVU) REFERENCES DICHVU(MADICHVU)
)

--1.	Viết các câu lệnh SQL để thực hiện các thao tác sao: (0.5 điểm)
--a.	Tạo Cơ sở dữ liệu, tạo bảng bao gồm khoá chính, khoá ngoại. (0.25 điểm)
--b.	Thêm dữ liệu cho các bảng theo đúng trình tự bên 1 trước bên nhiều sau. Mỗi bảng ít nhất 5 dòng dữ liệu. (0.25 điểm).
INSERT INTO GIATIENTHUESAN VALUES('GIATIEN001','6:00', '8:00',200000)  
INSERT INTO GIATIENTHUESAN VALUES('GIATIEN002','8:00', '10:00',150000)  
INSERT INTO GIATIENTHUESAN VALUES('GIATIEN003','10:00', '14:00',100000)  
INSERT INTO GIATIENTHUESAN VALUES('GIATIEN004','14:00', '17:00',150000)  
INSERT INTO GIATIENTHUESAN VALUES('GIATIEN005','17:00', '22:00',200000)  

INSERT INTO SANBONG VALUES('SANBONG001', N'SÂN BÓNG A', N'SÂN 5')
INSERT INTO SANBONG VALUES('SANBONG002', N'SÂN BÓNG B', N'SÂN 5')
INSERT INTO SANBONG VALUES('SANBONG003', N'SÂN BÓNG C', N'SÂN 5')
INSERT INTO SANBONG VALUES('SANBONG004', N'SÂN BÓNG D', N'SÂN 7')
INSERT INTO SANBONG VALUES('SANBONG005', N'SÂN BÓNG E', N'SÂN 11')

INSERT INTO DICHVU VALUES('DICHVU001', N'NƯỚC UỐNG', 100, 10000)
INSERT INTO DICHVU VALUES('DICHVU002', N'ĐỒ ĂN', 100, 30000)
INSERT INTO DICHVU VALUES('DICHVU003', N'GIÀY THI ĐẤU', 100, 100000)
INSERT INTO DICHVU VALUES('DICHVU004', N'ÁO PHÔNG CHIA ĐỘI', 100, 10000)
INSERT INTO DICHVU VALUES('DICHVU005', N'GIỮ XE', 100, 10000)

SET DATEFORMAT DMY
GO
INSERT INTO THUESAN VALUES('20012022001', '0343XXXXXX', 'SANBONG002', '20-01-2022', '17:00', '19:00',400000)
INSERT INTO THUESAN VALUES('20062022001', '0342XXXXXX', 'SANBONG001', '20-06-2022', '16:00', '17:00',200000)
INSERT INTO THUESAN VALUES('20012022002', '0344XXXXXX', 'SANBONG001', '20-01-2022', '18:00', '19:00',150000)
INSERT INTO THUESAN VALUES('26052022001', '0340XXXXXX', 'SANBONG001', '26-05-2022', '6:00', '7:00',200000)
INSERT INTO THUESAN VALUES('26052022002', '0341XXXXXX', 'SANBONG001', '26-05-2022', '7:00', '8:00',200000)
INSERT INTO THUESAN VALUES('20012022003', '0341XXXXXX', 'SANBONG002', '26-05-2022', '7:00', '8:00',200000)

INSERT INTO CHITIETTHUESAN VALUES('20012022001', 'DICHVU001', 1, 10000)
INSERT INTO CHITIETTHUESAN VALUES('20012022001', 'DICHVU005', 12, 10000)
INSERT INTO CHITIETTHUESAN VALUES('20012022002', 'DICHVU005', 14, 100000)
INSERT INTO CHITIETTHUESAN VALUES('20012022002', 'DICHVU002', 12,30000)
INSERT INTO CHITIETTHUESAN VALUES('20012022002', 'DICHVU001', 12,10000)
INSERT INTO CHITIETTHUESAN VALUES('20012022003', 'DICHVU005', 15, 10000)

SELECT * FROM GIATIENTHUESAN
SELECT * FROM SANBONG
SELECT * FROM DICHVU
SELECT * FROM THUESAN
SELECT * FROM CHITIETTHUESAN
--2.	Viết các hàm sau: (1.0 điểm)
--a.	Viết hàm phát sinh mã số tự động cho bảng thuê sân theo nguyên tắc: 
--Ngày thuê sân + số thứ tự gồm 3 chữ số tăng dần. 
--Ví dụ: Ngày thuê  sân là ngày 20/06/2022 và hiện đã có lần thuê sân thứ 3 
--(Bảng Thuê sân đang có mã số là: “20062022003” thì 
--mã số tự động tiếp theo sẽ là “20062022004” (0.5 điểm) 
SET DATEFORMAT DMY
GO
CREATE OR ALTER FUNCTION AUTO_ID(@NGAYTHUE SMALLDATETIME)
RETURNS CHAR(15)
AS
BEGIN
	DECLARE @ID VARCHAR(15)
	IF(SELECT COUNT(MATHUESAN) 
		FROM THUESAN WHERE NGAYTHUESAN = @NGAYTHUE) = 0
			SET @ID = '0'
	ELSE
		SELECT @ID = (SELECT COUNT(MATHUESAN) FROM THUESAN WHERE NGAYTHUESAN = @NGAYTHUE)
		SELECT @ID = CASE	
			WHEN @ID >=0 AND @ID < 9 THEN REPLACE(CONVERT(VARCHAR,@NGAYTHUE,104),'.','') +'00'+ CONVERT(CHAR,CONVERT(INT, @ID) +1)
			WHEN @ID >=9 AND @ID < 99 THEN REPLACE(CONVERT(VARCHAR,@NGAYTHUE,104),'.','') +'0'+ CONVERT(CHAR,CONVERT(INT, @ID) +1)
			WHEN @ID >= 99 THEN REPLACE(CONVERT(VARCHAR,@NGAYTHUE,104),'.','') + CONVERT(CHAR,CONVERT(INT, @ID) +1)
		END
	RETURN CAST(@ID AS CHAR)
END
GO
SELECT * FROM THUESAN
SET DATEFORMAT DMY
PRINT dbo.AUTO_ID('26/05/2022')
INSERT INTO THUESAN VALUES(dbo.AUTO_ID('26-05-2022'), '0341XXXXXX', 'SANBONG002', '26-05-2022', '8:00', '10:00',null)
--b.	Viết hàm trả về số tiền thuê sân khi biết được giờ vào sân và giờ ra khỏi sân (0.5 điểm)
--7h - 15h
GO
CREATE OR ALTER FUNCTION TIENTHUESAN
(@GIOVAO TIME,
@GIORA TIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @TIENTHUE FLOAT
	IF EXISTS(SELECT 1 FROM GIATIENTHUESAN WHERE @GIOVAO >= TUGIO AND @GIORA <= DENGIO)
	BEGIN
	SELECT @TIENTHUE = SOTIEN*(CAST(DATEDIFF(MINUTE,@GIOVAO,@GIORA) AS FLOAT))/60
					FROM GIATIENTHUESAN
					WHERE @GIOVAO >= TUGIO AND @GIORA <= DENGIO
	END
	ELSE
	BEGIN
		--tính trong khoảng giờ đầu tiên 
		SELECT @TIENTHUE = SOTIEN*(CAST(DATEDIFF(MINUTE,@GIOVAO,DENGIO) AS FLOAT))/60 
		FROM GIATIENTHUESAN
		WHERE @GIOVAO >= TUGIO AND @GIOVAO <= DENGIO 
		--tính trong khoảng giờ cuối cùng
		SELECT @TIENTHUE = @TIENTHUE + SOTIEN*(CAST(DATEDIFF(MINUTE,TUGIO,@GIORA) AS FLOAT))/60 
		FROM GIATIENTHUESAN
		WHERE @GIORA >= TUGIO AND @GIORA <= DENGIO
		--tính khoảng giữa
		SELECT @TIENTHUE = @TIENTHUE + SOTIEN*(DATEDIFF(MINUTE,TUGIO,DENGIO)/60 )
		FROM GIATIENTHUESAN
		WHERE (@GIOVAO < TUGIO AND @GIORA > DENGIO)
	END
	RETURN @TIENTHUE
END
GO
PRINT dbo.TIENTHUESAN('17:00', '20:00') --900000
UPDATE THUESAN 
SET TONGTIEN = dbo.TIENTHUESAN(GIOBATDAU,GIOKETTHUC)
SELECT * FROM GIATIENTHUESAN
SELECT * FROM THUESAN
--3.	Viết các thủ tục sau: (0.5 điểm)
--a.	Thêm vào bảng Giá tiền thuê sân có kiểm tra khoá chính, giờ vào phải nhỏ hơn giờ ra. (0.25 điểm)
GO
CREATE OR ALTER PROC CAU3A_THEMGIATIEN @MAGIATIEN CHAR(15), @TUGIO TIME, @DENGIO TIME, @SOTIEN MONEY
AS 
BEGIN
	IF (@MAGIATIEN IS NULL OR EXISTS (SELECT MAGIATIEN FROM GIATIENTHUESAN WHERE MAGIATIEN = @MAGIATIEN))
		PRINT N'KHÓA CHÌNH BỊ RỖNG HOẶC TRÙNG'
	ELSE IF (@TUGIO >= @DENGIO)
		PRINT N'GIỜ VÀO PHẢI NHỎ HƠN GIỜ RA'
	ELSE 
		INSERT INTO GIATIENTHUESAN VALUES(@MAGIATIEN, @TUGIO, @DENGIO, @SOTIEN)
END
GO
EXEC CAU3A_THEMGIATIEN'GIATIEN005', '7:00','7:00', 200000 --KHÓA CHÌNH BỊ RỖNG HOẶC TRÙNG
DELETE FROM GIATIENTHUESAN WHERE MAGIATIEN = 'GIATIEN006'
EXEC CAU3A_THEMGIATIEN'GIATIEN006', '7:00','7:00', 200000 --GIỜ VÀO PHẢI NHỎ HƠN GIỜ RA
EXEC CAU3A_THEMGIATIEN'GIATIEN006', '7:00','8:00', 200000 --THÀNH CÔNG
DELETE FROM GIATIENTHUESAN WHERE MAGIATIEN = 'GIATIEN006'

--b.	Cập nhật đơn giá cho dịch vụ thuê áo thêm 10.000 (0.25 điểm). 
GO
CREATE OR ALTER PROC CAU3B_UPDATE_DONGIA
AS
BEGIN
	UPDATE DICHVU
	SET DONGIA = DONGIA + 10000
	WHERE MADICHVU = 'DICHVU004'
END
GO
SELECT * FROM DICHVU
EXEC CAU3B_UPDATE_DONGIA
SELECT * FROM DICHVU
--4.	Viết 1 trigger sau: (1 điểm)
--Khi thêm, xoá, sửa dữ liệu trong bảng Chi tiết thuê sân: 
---	Cập nhật lại Tổng tiền trong bảng thuê sân. Trong đó, tổng tiền = tiền thuê sân + tiền sử dụng dịch vụ của lần thuê sân đó (0.5 điểm)
---	Đơn giá trong bảng Chi tiết thuê sân phải bằng với đơn giá trong bảng dịch vụ (0.5 điểm)s
GO
CREATE OR ALTER TRIGGER TRIG_CAU4
ON CHITIETTHUESAN
FOR INSERT,UPDATE, DELETE
AS	
	DECLARE @GIOVAO TIME, @GIORA TIME
	IF EXISTS (SELECT 1 FROM inserted) 
	BEGIN 
		--INSERT
		DECLARE @MATHUE_INSERTED CHAR(15)
		SELECT @MATHUE_INSERTED = MATHUESAN FROM INSERTED
		SELECT @GIOVAO = GIOBATDAU, @GIORA = GIOKETTHUC FROM THUESAN WHERE MATHUESAN = @MATHUE_INSERTED
		UPDATE THUESAN
		SET TONGTIEN = DBO.TIENTHUESAN(@GIOVAO, @GIORA) + (SELECT SUM(CT.SOLUONG * CT.DONGIA) 
															FROM CHITIETTHUESAN CT
															WHERE CT.MATHUESAN = @MATHUE_INSERTED)
		WHERE MATHUESAN = @MATHUE_INSERTED
		--KIỂM TRA DƠN GIÁ
		IF(SELECT DONGIA FROM inserted) != (SELECT DICHVU.DONGIA FROM DICHVU,inserted WHERE inserted.MADICHVU = DICHVU.MADICHVU)
		BEGIN
			PRINT(N'Đơn giá trong bảng Chi tiết thuê sân phải bằng với đơn giá trong bảng dịch vụ')
			ROLLBACK TRAN 
		END
	END
	ELSE IF EXISTS(SELECT 1 FROM deleted)
		IF NOT EXISTS(SELECT 1 FROM deleted)
			BEGIN
			RETURN
			END
		ELSE
			BEGIN
			--DELETE dựa trên mã thuê sân và mã dịch vụ
			DECLARE @TIEN_DELETE MONEY
			SET @TIEN_DELETE = (SELECT SUM(SOLUONG * DONGIA) 
										FROM deleted
										GROUP BY deleted.MATHUESAN)
			UPDATE THUESAN
			SET TONGTIEN = TONGTIEN - @TIEN_DELETE
										--WHERE ThueSan.MATHUESAN = deleted.MATHUESAN)
			--FROM THUESAN, deleted
			WHERE THUESAN.MATHUESAN = (select MATHUESAN from deleted)
			END
	ELSE
	BEGIN
		--UPDATE
		---UPDATE DUA TREN MADICHVU VA MATHUESAN KHI XET WHERE
		IF UPDATE(SOLUONG)
		BEGIN
		UPDATE THUESAN 
		SET TONGTIEN = dbo.TIENTHUESAN(GIOBATDAU,GIOKETTHUC) + (SELECT SUM(CT.SOLUONG * CT.DONGIA) 
																FROM DICHVU DV,CHITIETTHUESAN CT
																WHERE DV.MADICHVU = CT.MADICHVU AND CT.MATHUESAN = THUESAN.MATHUESAN)
		END
		--KIỂM TRA DƠN GIÁ
		IF UPDATE(DONGIA)
		BEGIN
			PRINT(N'Đơn giá không được cập nhật')
			ROLLBACK TRAN 
		END
	END
GO
--test
drop trigger TRIG_CAU4
SELECT * FROM THUESAN
SELECT * FROM CHITIETTHUESAN
DELETE FROM THUESAN
DELETE FROM CHITIETTHUESAN

SET DATEFORMAT DMY
INSERT INTO THUESAN VALUES('20012022001', '0343XXXXXX', 'SANBONG002', '20-01-2022', '17:00', '19:00',dbo.TIENTHUESAN('17:00','19:00'))
INSERT INTO THUESAN VALUES('20012022002', '0344XXXXXX', 'SANBONG001', '20-01-2022', '18:00', '19:00',dbo.TIENTHUESAN('18:00','19:00'))
INSERT INTO THUESAN VALUES('20012022003', '0344XXXXXX', 'SANBONG003', '20-01-2022', '18:00', '19:00',dbo.TIENTHUESAN('18:00','19:00'))

INSERT INTO CHITIETTHUESAN VALUES('20012022001', 'DICHVU001', 1, 1000000)
INSERT INTO CHITIETTHUESAN VALUES('20012022001', 'DICHVU005', 12, 10000)
INSERT INTO CHITIETTHUESAN VALUES('20012022002', 'DICHVU005', 14, 10000)
INSERT INTO CHITIETTHUESAN VALUES('20012022002', 'DICHVU002', 12, 30000)
INSERT INTO CHITIETTHUESAN VALUES('20012022002', 'DICHVU001', 12, 10000)
INSERT INTO CHITIETTHUESAN VALUES('20012022003', 'DICHVU005', 15, 10000)

DELETE FROM CHITIETTHUESAN where MATHUESAN = '20012022001'
DELETE FROM CHITIETTHUESAN where MATHUESAN = '20012022002' AND MADICHVU = 'DICHVU001'
DELETE FROM CHITIETTHUESAN where MATHUESAN = '20012022002' AND MADICHVU = 'DICHVU002'
DELETE FROM CHITIETTHUESAN where MATHUESAN = '20012022002' AND MADICHVU = 'DICHVU005'
DELETE FROM CHITIETTHUESAN WHERE MATHUESAN = '20012022003' 
SELECT * FROM THUESAN
SELECT * FROM CHITIETTHUESAN
UPDATE CHITIETTHUESAN
SET SOLUONG = 10
WHERE MATHUESAN = '20012022002' AND MADICHVU = 'DICHVU002'
UPDATE CHITIETTHUESAN
SET DONGIA = 20000
WHERE MATHUESAN = '20012022002' AND MADICHVU = 'DICHVU002'
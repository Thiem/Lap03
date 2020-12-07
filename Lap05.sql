IF EXISTS (SELECT * FROM sys.databases WHERE Name='Example5')
DROP DATABASE Example5
GO
CREATE DATABASE Example5
GO
USE Example5
GO
--Tạo bảng Lớp học
CREATE TABLE LopHoc(
MaLopHoc INT PRIMARY KEY IDENTITY,
TenLopHoc VARCHAR(10)
)
GO
--Tạo bảng Sinh viên có khóa ngoại là cột MaLopHoc, nối với bảng LopHoc
CREATE TABLE SinhVien(
MaSV int PRIMARY KEY,
TenSV varchar(40),
MaLopHoc int,
CONSTRAINT fk FOREIGN KEY (MaLopHoc) REFERENCES LopHoc(MaLopHoc)
)
GO
--Tạo bảng SanPham với một cột NULL, một cột NOT NULL
CREATE TABLE SanPham (
MaSP int NOT NULL,
TénP varchar(40) NULL
)
GO
--Tạo bảng với thuộc tính default cho cột Price
CREATE TABLE StoreProduct(
ProductID int NOT NULL,
Name varchar(40) NOT NULL,
Price money NOT NULL DEFAULT (100)
)
--Thử kiểm tra xem giá trị default có được sử dụng hay không
INSERT INTO StoreProduct (ProductID, Name) VALUES (111, 'Rivets')
GO
--Tạo bảng ContactPhone với thuộc tính IDENTITY
CREATE TABLE ContactPhone (
Person_ID int IDENTITY(500,1) NOT NULL,
MobileNumber bigint NOT NULL
)
GO
--Tạo cột nhận dạng duy nhất tổng thể
CREATE TABLE CellularPhone(
Person_ID uniqueidentifier DEFAULT NEWID() NOT NULL,
PersonName varchar(60) NOT NULL
)
--Chèn một record vào
INSERT INTO CellularPhone(PersonName) VALUES('William Smith')
GO
--Kiểm tra giá trị của cột Person_ID tự động sinh
SELECT * FROM CellularPhone
GO
--Tạo bảng ContactPhone với cột MobileNumber có thuộc tính UNIQUE
DROP TABLE ContactPhone
CREATE TABLE ContactPhone (
Person_ID int PRIMARY KEY,
MobileNumber bigint UNIQUE,
ServiceProvider varchar(30),
LandlineNumber bigint UNIQUE
)
--Chèn 2 bản ghi có giá trị giống nhau ở cột MobileNumber và LanlieNumber để quan sát lỗi INTO ContactPhone values (101, 983345674, 'Hutch', NULL)
INSERT INTO ContactPhone values (102, 983345674, 'Alex', NULL)
GO
--Tạo bảng PhoneExpenses có một CHECT ở cột Amount
CREATE TABLE PhoneExpenses (
Expense_ID int PRIMARY KEY,
MobileNumber bigint FOREIGN KEY REFERENCES ContactPhone
(MobileNumber),
Amount bigint CHECK (Amount >0)
)
GO
--Chỉnh sửa cột trong bảng
ALTER TABLE ContactPhone
ALTER COLUMN ServiceProvider varchar(45)
GO
--Xóa cột trong bảng
ALTER TABLE ContactPhone
DROP COLUMN ServiceProvider
GO
---Them một ràng buộc vào bảng
ALTER TABLE ContactPhone
ADD RentalCharges INT
GO

ALTER TABLE ContactPhone ADD CONSTRAINT CHK_RC CHECK(RentalCharges >0)
GO
--Xóa một ràng buộc
ALTER TABLE Person.ContactPhone
DROP CONSTRAINT CHK_RC

SELECT * FROM ContactPhone

--Phan II Bai Tap
IF EXISTS (SELECT * FROM sys.databases WHERE Name='BookLibrary')
DROP DATABASE BookLibrary
GO
CREATE DATABASE BookLibrary
GO
USE BookLibrary
GO

CREATE TABLE Book 
(
	BookCode INT PRIMARY KEY,
	BookTitle varchar(100) NOT NULL,
	Author varchar(50) NOT NULL,
	Edition INT,
	BookPrice money,
	Copies INT 
)
GO

CREATE TABLE Member 
(
	MemberCode INT PRIMARY KEY,
	Name varchar(50) NOT NULL,
	Adress varchar(100) NOT NULL,
	PhoneNumber INT 
)
GO

CREATE TABLE IssueDetails
(
	IssueDetails_ID INT PRIMARY KEY,
	BookCode INT ,
	MemberCode INT ,
	CONSTRAINT fk_BookCode FOREIGN KEY (BookCode) REFERENCES Book(BookCode),
	CONSTRAINT fk_MemberCode FOREIGN KEY (MemberCode) REFERENCES Member(MemberCode),
	IssueDate Datetime,
	ReturnDate Datetime
)
GO
DROP TABLE IssueDetails
--a. Xóa bỏ các Ràng buộc Khóa ngoại của bảng IssueDetails
ALTER TABLE IssueDetails
DROP CONSTRAINT fk_BookCode
--b. Xóa bỏ Ràng buộc Khóa chính của bảng Member và Book
ALTER TABLE Book
DROP CONSTRAINT PK__Book__0A5FFCC675C468CB
ALTER TABLE Member
DROP CONSTRAINT PK__Member__84CA6376102DCA91
--c. Thêm mới Ràng buộc Khóa chính cho bảng Member và Book
ALTER TABLE Book
ADD CONSTRAINT PK_BookCode
PRIMARY KEY(BookCode)

ALTER TABLE Member
ADD CONSTRAINT PK_Member
PRIMARY KEY(MemberCode)
--d. Thêm mới các Ràng buộc Khóa ngoại cho bảng IssueDetails
ALTER TABLE IssueDetails
ADD CONSTRAINT FK_BookCode
FOREIGN KEY(BookCode)
REFERENCES Book(BookCode)

ALTER TABLE IssueDetails
ADD CONSTRAINT FK_MemberCode
FOREIGN KEY(MemberCode)
REFERENCES Member(MemberCode)

--Bổ sung thêm Ràng buộc giá bán sách > 0 và < 200
ALTER TABLE Book ADD CONSTRAINT Book_Price CHECK(BookPrice > 0 AND BookPrice < 200)
--f. Bổ sung thêm Ràng buộc duy nhất cho PhoneNumber của bảng Member
ALTER TABLE Member ADD CONSTRAINT PhoneNumber_DN UNIQUE (PhoneNumber)
--g. Bổ sung thêm ràng buộc NOT NULL cho BookCode, MemberCode trong bảng IssueDetails
ALTER TABLE IssueDetails
ALTER COLUMN BookCode INT NOT NULL
GO

ALTER TABLE IssueDetails
ALTER COLUMN MemberCode INT NOT NULL
GO
--h. Tạo khóa chính gồm 2 cột BookCode, MemberCode cho bảng IssueDetails
ALTER TABLE IssueDetails
DROP COLUMN IssueDetails_ID
GO
alter table IssueDetails
drop constraint PK__IssueDet__3249AAF362144078
go
ALTER TABLE IssueDetails
 ADD CONSTRAINT PK  PRIMARY KEY (BookCode,MemberCode)
 --i. Chèn dữ liệu hợp lý cho các bảng(Sử dụng SQL)
 INSERT INTO Member(MemberCode,Name,Adress,PhoneNumber) VALUES(1,'William Smith','London',123456)
GO
SELECT * FROM Member
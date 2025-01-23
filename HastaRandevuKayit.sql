CREATE DATABASE HospitalDb;

use HospitalDb;
 
-- Patient Tablosunu Oluþturalým
if not exists(select * from sysobjects where name='Patient' and xtype='U' )
CREATE TABLE Patient(
	PatientID INT PRIMARY KEY IDENTITY NOT NULL,
	PatientName NVARCHAR(50) NOT NULL,
	PatientLastName NVARCHAR(50) NOT NULL,
	PatientBirthDay DATE NOT NULL,
	PatientGender CHAR(1) CHECK (PatientGender IN ('M','F')),
	PatientMail NVARCHAR(100) UNIQUE,
);

-- Doctor Tablosunu oluþturalým
if not exists(select * from sysobjects where name='Doctor' and xtype='U' )
CREATE TABLE Doctor(
	DoctorID INT PRIMARY KEY IDENTITY NOT NULL,
	DoctorName NVARCHAR(50) NOT NULL,
	DoctorLastName NVARCHAR(50) NOT NULL,
	DoctorSpecialty NVARCHAR(100) NOT NULL,
	DoctorMail NVARCHAR(100) UNIQUE,
);

-- Department Tablosunu Oluþturalým
if not exists(select * from sysobjects where name='Department' and xtype='U')
CREATE TABLE Department(
	DepartmentID INT PRIMARY KEY NOT NULL,
	DepartmentName NVARCHAR(100) UNIQUE NOT NULL,
);

-- Appointment Tablosunu Oluþturalým
if not exists(select * from sysobjects where name='Appointment' and xtype='U')
CREATE TABLE Appointment(
	AppointmentID INT PRIMARY KEY NOT NULL,
	PatientID INT NOT NULL,
	DoctorID INT NOT NULL,
	AppointmentDate DATETIME NOT NULL,
	AppointmentStatus NVARCHAR(100) DEFAULT 'Planned' CHECK (AppointmentStatus IN ('Planned','Completed','Canceled')),
	Notes NVARCHAR(250),
	CONSTRAINT FK_Appointment_Patient FOREIGN KEY(PatientID) REFERENCES Patient(PatientID),
	CONSTRAINT FK_Appointment_Doctor FOREIGN KEY(DoctorID) REFERENCES Doctor(DoctorID),
);

-- Doktor-Bölüm Ýliþkisini Gösteren Tabloyu Oluþturalým
if not exists(select * from sysobjects where name='DoctorDepartment' and xtype='U')
CREATE TABLE DoctorDepartment(
	DoctorID INT NOT NULL,
	DepartmentID INT NOT NULL,
	CONSTRAINT FK_Doctor_DoctorDepartment FOREIGN KEY(DoctorID) REFERENCES Doctor(DoctorID),
	CONSTRAINT FK_Department_DoctorDepartment FOREIGN KEY(DepartmentID) REFERENCES Department(DepartmentID),
);

INSERT INTO Department (DepartmentID,DepartmentName) VALUES (1,'Kardiyoloji');
INSERT INTO Department (DepartmentID,DepartmentName) VALUES (2,'Nöroloji');
INSERT INTO Department (DepartmentID,DepartmentName) VALUES (3,'Dahiliye');
INSERT INTO Department (DepartmentID,DepartmentName) VALUES (4,'Ortopedi');
INSERT INTO Department (DepartmentID,DepartmentName) VALUES (5,'Kulak Burun Boðaz');

select * from Department;

INSERT INTO Doctor (DoctorName,DoctorLastName,DoctorSpecialty,DoctorMail) Values ('Sudenaz','Alkan','Kardiyoloji','sude@gmail.com');
INSERT INTO Doctor (DoctorName,DoctorLastName,DoctorSpecialty,DoctorMail) Values ('Lale','Söðüt','Dahiliye','lale@gmail.com');
INSERT INTO Doctor (DoctorName,DoctorLastName,DoctorSpecialty,DoctorMail) Values ('Enes','Yarar','Ortopedi','enes@gmail.com');
INSERT INTO Doctor (DoctorName,DoctorLastName,DoctorSpecialty,DoctorMail) Values ('Merve','Korkmaz','Nöroloji','merve@gmail.com');
INSERT INTO Doctor (DoctorName,DoctorLastName,DoctorSpecialty,DoctorMail) Values ('Adem','Kaya','Kulak Burun Boðaz','adem@gmail.com');

select * from Doctor;

INSERT INTO Patient (PatientName,PatientLastName,PatientBirthDay,PatientGender,PatientMail) VALUES ('Kübra','Aktaþ','1985-09-13','F','kubra@gmail.com');
INSERT INTO Patient (PatientName,PatientLastName,PatientBirthDay,PatientGender,PatientMail) VALUES ('Tuðba','Savaþ','1996-02-14','F','tugba@gmail.com');
INSERT INTO Patient (PatientName,PatientLastName,PatientBirthDay,PatientGender,PatientMail) VALUES ('Mustafa','Yýldýz','1970-10-21','M','mustfa@gmail.com');
INSERT INTO Patient (PatientName,PatientLastName,PatientBirthDay,PatientGender,PatientMail) VALUES ('Halil','Sönmez','2000-06-19','M','halil@gmail.com');
INSERT INTO Patient (PatientName,PatientLastName,PatientBirthDay,PatientGender,PatientMail) VALUES ('Büþra','Aslan','2003-09-12','F','busra@gmail.com');

select * from Patient;

INSERT INTO Appointment (PatientID,DoctorID,AppointmentDate,AppointmentStatus,Notes) VALUES (1,1,'2025-01-10','Completed','General Examination');
INSERT INTO Appointment (PatientID,DoctorID,AppointmentDate,AppointmentStatus,Notes) VALUES (2,1,'2025-01-10','Completed','General Examination');
INSERT INTO Appointment (PatientID,DoctorID,AppointmentDate,AppointmentStatus,Notes) VALUES (2,4,'2025-02-15 14:00:00','Planned','Headache');
INSERT INTO Appointment (PatientID,DoctorID,AppointmentDate,AppointmentStatus,Notes) VALUES (3,2,'2025-01-01 13:30:00','Canceled','Check Up');
INSERT INTO Appointment (PatientID,DoctorID,AppointmentDate,AppointmentStatus,Notes) VALUES (4,3,'2024-12-20','Completed','Backache');
INSERT INTO Appointment (PatientID,DoctorID,AppointmentDate,AppointmentStatus,Notes) VALUES (6,5,'2025-02-07','Planned','General Examination');


select * from Appointment

INSERT INTO DoctorDepartment (DoctorID,DepartmentID) VALUES (1,1);
INSERT INTO DoctorDepartment (DoctorID,DepartmentID) VALUES (2,3);
INSERT INTO DoctorDepartment (DoctorID,DepartmentID) VALUES (3,4);
INSERT INTO DoctorDepartment (DoctorID,DepartmentID) VALUES (4,2);
INSERT INTO DoctorDepartment (DoctorID,DepartmentID) VALUES (5,5);


-- AppointmentID'yi sonradan IDENTITY yaptým
ALTER TABLE Appointment DROP CONSTRAINT PK__Appointm__8ECDFCA2E417F6A8;
ALTER TABLE Appointment ADD NewAppointmentID INT IDENTITY(1,1);
ALTER TABLE Appointment ADD CONSTRAINT PK__Appointm__8ECDFCA2E417F6A8 PRIMARY KEY (NewAppointmentID);
ALTER TABLE Appointment DROP COLUMN AppointmentID;
EXEC sp_rename 'Appointment.NewAppointmentID', 'AppointmentID', 'COLUMN';



-- Belirli bir doktorun randevularýný tarih sýrasýna göre sýralayalým.
select * from Appointment as app where app.DoctorID = 1 order by app.AppointmentDate asc;

-- Hasta bilgileriyle beraber randevularý da listeleyelim.
SELECT A.AppointmentID, P.PatientName, D.DoctorName, A.AppointmentDate, A.AppointmentStatus
FROM Appointment as A
JOIN Patient P ON A.PatientID = P.PatientID
JOIN Doctor D ON A.DoctorID = D.DoctorID;



-- Bir doktorun hangi bölümlerde çalýþtýðýný gösterelim.
SELECT D.DoctorName, Dept.DepartmentName 
FROM Doctor AS D
JOIN DoctorDepartment AS DEP ON DEP.DoctorID = D.DoctorID  
JOIN Department AS Dept ON Dept.DepartmentID = DEP.DepartmentID;

-- Her bir doktorun kaç randevusu olduðuna bakalým.
SELECT D.DoctorName, COUNT(A.AppointmentID) AS 'Toplam Randevu Sayýsý'
FROM Doctor D
JOIN Appointment A ON D.DoctorID = A.DoctorID
GROUP BY D.DoctorName;


-- Her durumdaki randevu sayýsýný listeleyelim.
SELECT APP.AppointmentStatus as 'Randevu Durumu',COUNT(App.AppointmentID) as 'Randevu Sayýsý'
FROM Appointment AS APP
GROUP BY APP.AppointmentStatus;

-- En çok randevusu olan doktoru bulalým.
SELECT TOP 1 D.DoctorName ,COUNT(APP.AppointmentID) as ToplamRandevuSayisi
FROM Doctor AS D
JOIN Appointment as APP ON APP.DoctorID = D.DoctorID
GROUP BY D.DoctorName
ORDER BY ToplamRandevuSayisi DESC;
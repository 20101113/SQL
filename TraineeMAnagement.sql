CREATE DATABASE TraineeManagement;

-- Use the TraineeManagement database
USE TraineeManagement;

-- Create the Trainees table
CREATE TABLE Trainees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50)
);

-- Create the Attendance table with a foreign key reference to the Trainees table
CREATE TABLE Attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trainee_id INT,  -- Column to store the trainee's ID
    forenoon_status VARCHAR(50),
    afternoon_status VARCHAR(50),
    date DATE,
    FOREIGN KEY (trainee_id) REFERENCES Trainees(id)
);

-- Add an index to the date column in the Attendance table
CREATE INDEX idx_attendance_date ON Attendance(date);




select * from attendance;

select * from trainees;
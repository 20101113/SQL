-- Create the database and use it
CREATE DATABASE test3;
USE test3;

-- Create Tables
CREATE TABLE DimDate (
    DateID INT PRIMARY KEY,
    Date DATE,
    Year INT,
    Month INT,
    Day INT,
    Hour INT
);

CREATE TABLE DimDevice (
    DeviceID INT PRIMARY KEY,
    DeviceType VARCHAR(50),
    Location VARCHAR(100),
    InstallationDate DATE
);

CREATE TABLE DimSensor (
    SensorID INT PRIMARY KEY,
    DeviceID INT,
    SensorType VARCHAR(50),
    FOREIGN KEY (DeviceID) REFERENCES DimDevice(DeviceID)
);

CREATE TABLE FactReadings (
    ReadingID INT PRIMARY KEY,
    DateID INT,
    SensorID INT,
    Value FLOAT,
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID),
    FOREIGN KEY (SensorID) REFERENCES DimSensor(SensorID)
);

CREATE TABLE FactAlerts (
    AlertID INT PRIMARY KEY,
    DateID INT,
    SensorID INT,
    AlertType VARCHAR(50),
    Severity INT,
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID),
    FOREIGN KEY (SensorID) REFERENCES DimSensor(SensorID)
);

-- Insert Data into DimDate
INSERT INTO DimDate (DateID, Date, Year, Month, Day, Hour)
SELECT 
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS DateID,
    DATE_ADD('2023-01-01', INTERVAL (a.num + b.num * 10 + c.num * 100) DAY) AS Date,
    YEAR(DATE_ADD('2023-01-01', INTERVAL (a.num + b.num * 10 + c.num * 100) DAY)) AS Year,
    MONTH(DATE_ADD('2023-01-01', INTERVAL (a.num + b.num * 10 + c.num * 100) DAY)) AS Month,
    DAY(DATE_ADD('2023-01-01', INTERVAL (a.num + b.num * 10 + c.num * 100) DAY)) AS Day,
    HOUR(DATE_ADD('2023-01-01', INTERVAL (a.num + b.num * 10 + c.num * 100) DAY)) AS Hour
FROM 
    (SELECT 0 AS num UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS a,
    (SELECT 0 AS num UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS b,
    (SELECT 0 AS num UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS c
ORDER BY (a.num + b.num * 10 + c.num * 100)
LIMIT 10000;

-- Insert Data into DimDevice
INSERT INTO DimDevice (DeviceID, DeviceType, Location, InstallationDate)
SELECT 
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS DeviceID,  -- 10,000 unique DeviceIDs
    CONCAT('DeviceType', FLOOR(RAND() * 10) + 1) AS DeviceType,
    CONCAT('Location', FLOOR(RAND() * 100) + 1) AS Location,  -- 100 random locations
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 3650) DAY) AS InstallationDate  -- Installation within the last 10 years
FROM 
    (SELECT 1 AS num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) AS a
CROSS JOIN 
    (SELECT 1 AS num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) AS b
CROSS JOIN 
    (SELECT 1 AS num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) AS c
LIMIT 10000;  -- 10,000 devices

-- Insert Data into DimSensor
INSERT INTO DimSensor (SensorID, DeviceID, SensorType)
SELECT 
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS SensorID,
    d.DeviceID,  -- Use valid DeviceID from DimDevice
    CONCAT('SensorType', FLOOR(RAND() * 10) + 1) AS SensorType  -- Random sensor type
FROM 
    (SELECT DeviceID FROM DimDevice) AS d
CROSS JOIN 
    (SELECT 1 AS num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) AS a
LIMIT 10000;  -- 10,000 sensors

-- Insert Data into FactReadings
INSERT INTO FactReadings (ReadingID, DateID, SensorID, Value)
SELECT 
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ReadingID,
    d.DateID,  -- Select valid DateID from DimDate
    s.SensorID,  -- Select valid SensorID from DimSensor
    ROUND(50 + RAND() * 450, 2) AS Value  -- Random reading value between 50 and 500
FROM 
    (SELECT DateID FROM DimDate) AS d
CROSS JOIN 
    (SELECT SensorID FROM DimSensor) AS s
LIMIT 10000;  -- 10,000 readings

-- Insert Data into FactAlerts
INSERT INTO FactAlerts (AlertID, DateID, SensorID, AlertType, Severity)
SELECT 
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS AlertID,
    d.DateID,  -- Valid DateID from DimDate
    s.SensorID,  -- Valid SensorID from DimSensor
    CONCAT('AlertType', FLOOR(RAND() * 5) + 1) AS AlertType,  -- Random alert type
    FLOOR(RAND() * 5) + 1 AS Severity  -- Random severity level
FROM 
    (SELECT DateID FROM DimDate) AS d
CROSS JOIN 
    (SELECT SensorID FROM DimSensor) AS s
LIMIT 10000;  -- 10,000 alerts

-- Optimized Query for Analysis
SELECT 
    dd.DeviceType, 
    ds.SensorType, 
    HOUR(dd2.Date) AS Hour,
    AVG(fr.Value) AS AvgReading,
    COUNT(DISTINCT fa.AlertID) AS AlertCount
FROM FactReadings fr
JOIN DimSensor ds ON fr.SensorID = ds.SensorID
JOIN DimDevice dd ON ds.DeviceID = dd.DeviceID
JOIN DimDate dd2 ON fr.DateID = dd2.DateID
LEFT JOIN FactAlerts fa ON fr.SensorID = fa.SensorID AND fr.DateID = fa.DateID
WHERE dd2.Date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)  -- Widened date range
GROUP BY dd.DeviceType, ds.SensorType, HOUR(dd2.Date)
ORDER BY dd.DeviceType, ds.SensorType, HOUR(dd2.Date);

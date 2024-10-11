## Use Case 7: IoT Sensor Data Analysis

### Problem Statement:
-- An IoT platform collecting data from 10 million sensors needs to analyze sensor performance, environmental conditions, and anomaly detection.

### Normalized Schema: sql
create database ps1;
use ps1;
CREATE TABLE Devices (
    DeviceID INT PRIMARY KEY,
    DeviceType VARCHAR(50),
    Location VARCHAR(100),
    InstallationDate DATE
);

CREATE TABLE Sensors (
    SensorID INT PRIMARY KEY,
    DeviceID INT,
    SensorType VARCHAR(50),
    FOREIGN KEY (DeviceID) REFERENCES Devices(DeviceID)
);

CREATE TABLE Readings (
    ReadingID INT PRIMARY KEY,
    SensorID INT,
    ReadingTime DATETIME,
    Value FLOAT,
    FOREIGN KEY (SensorID) REFERENCES Sensors(SensorID)
);

CREATE TABLE Alerts (
    AlertID INT PRIMARY KEY,
    SensorID INT,
    AlertTime DATETIME,
    AlertType VARCHAR(50),
    Severity INT,
    FOREIGN KEY (SensorID) REFERENCES Sensors(SensorID)
);

-- Inserting 10,000 rows into the Devices table
INSERT INTO Devices (DeviceID, DeviceType, Location, InstallationDate)
SELECT 
  1000 + num,  -- DeviceID (starting from 1000 for example)
  CASE 
    WHEN num % 2 = 0 THEN 'Temperature' 
    ELSE 'Humidity' 
  END,  -- DeviceType
  CONCAT('Location ', 1 + FLOOR(RAND() * 100)),  -- Random location
  DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY)  -- Random installation date in the last year
FROM (
  SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + 1 AS num
  FROM 
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d
  ORDER BY num
  LIMIT 10000
) numbers;

-- Inserting 10,000 rows into the Sensors table
INSERT INTO Sensors (SensorID, DeviceID, SensorType)
SELECT 
  1000 + num,  -- SensorID
  1000 + num,  -- DeviceID, assuming one sensor per device
  CASE 
    WHEN num % 2 = 0 THEN 'Temperature Sensor' 
    ELSE 'Humidity Sensor' 
  END  -- SensorType
FROM (
  SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + 1 AS num
  FROM 
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d
  ORDER BY num
  LIMIT 10000
) numbers;

-- Inserting 10,000 rows into the Readings table
INSERT INTO Readings (ReadingID, SensorID, ReadingTime, Value)
SELECT 
  1000 + num,  -- ReadingID
  1000 + num,  -- SensorID
  DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 10000) MINUTE),  -- Random ReadingTime in the last 10000 minutes
  ROUND(RAND() * 100, 2)  -- Random Value between 0 and 100
FROM (
  SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + 1 AS num
  FROM 
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d
  ORDER BY num
  LIMIT 10000
) numbers;

-- Inserting 10,000 rows into the Alerts table
INSERT INTO Alerts (AlertID, SensorID, AlertTime, AlertType, Severity)
SELECT 
  1000 + num,  -- AlertID
  1000 + num,  -- SensorID
  DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 10000) MINUTE),  -- Random AlertTime
  CASE 
    WHEN num % 2 = 0 THEN 'Overheat' 
    ELSE 'Low Battery' 
  END,  -- Random AlertType
  1 + FLOOR(RAND() * 5)  -- Random Severity between 1 and 5
FROM (
  SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + 1 AS num
  FROM 
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d
  ORDER BY num
  LIMIT 10000
) numbers;


### Slow Query: sql

SELECT d.DeviceType, s.SensorType, 
       DATEPART(HOUR, r.ReadingTime) AS Hour,
       AVG(r.Value) AS AvgReading,
       COUNT(DISTINCT a.AlertID) AS AlertCount
FROM Readings r
JOIN Sensors s ON r.SensorID = s.SensorID
JOIN Devices d ON s.DeviceID = d.DeviceID
LEFT JOIN Alerts a ON s.SensorID = a.SensorID 
    AND CAST(r.ReadingTime AS DATE) = CAST(a.AlertTime AS DATE)
WHERE r.ReadingTime >= DATE_ADD(day, -7, GETDATE())
GROUP BY d.DeviceType, s.SensorType, DATEPART(HOUR, r.ReadingTime)
ORDER BY d.DeviceType, s.SensorType, Hour;

-- Modified Query (Normalized) - 0.094sec
SELECT 
    d.DeviceType,  -- Device type from Devices table
    s.SensorType,  -- Sensor type from Sensors table
    HOUR(r.ReadingTime) AS Hour,  -- Extract the hour part from ReadingTime for hourly analysis
    AVG(r.Value) AS AvgReading,  -- Calculate the average reading value for each hour
    COUNT(DISTINCT a.AlertID) AS AlertCount  -- Count distinct alerts for each hour
FROM 
    Readings r
JOIN 
    Sensors s ON r.SensorID = s.SensorID  -- Join Readings with Sensors on SensorID
JOIN 
    Devices d ON s.DeviceID = d.DeviceID  -- Join Sensors with Devices on DeviceID
LEFT JOIN 
    Alerts a ON s.SensorID = a.SensorID 
    AND DATE(r.ReadingTime) = DATE(a.AlertTime)  -- Left join with Alerts where reading and alert times are on the same day
WHERE 
    r.ReadingTime >= DATE_ADD(NOW(), INTERVAL -7 DAY)  -- Only consider readings from the last 7 days
GROUP BY 
    d.DeviceType,  -- Group by DeviceType for aggregation
    s.SensorType,  -- Group by SensorType for aggregation
    HOUR(r.ReadingTime)  -- Group by the hour part of ReadingTime
ORDER BY 
    d.DeviceType, s.SensorType, Hour;  -- Order results by DeviceType, SensorType, and hour


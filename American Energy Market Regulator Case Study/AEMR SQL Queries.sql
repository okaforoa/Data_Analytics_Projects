--P1Q1.1
SELECT COUNT(status='Approved') AS Total_Number_Outage_Events, Status, Reason
FROM AEMR
WHERE Year(start_time) = 2016 AND status='Approved'
GROUP BY Status, Reason
ORDER BY reason 

--P1Q1.3
SELECT COUNT(status='Approved') AS Total_Number_Outage_Events, Status, Reason
FROM AEMR
WHERE Year(start_time) = 2017 AND status='Approved'
GROUP BY Status, Reason
ORDER BY reason 

-- P1Q1.5
SELECT Status, Reason, 
count(reason) AS Total_Number_Outage_Events, 
ROUND(AVG(TIMESTAMPDIFF(minute, start_time, end_time)/1440), 2) AS Average_Outage_Duration_Time_Days, 
year(start_time) AS Year
FROM AEMR
WHERE year(start_time) IN('2016', '2017') AND status='Approved'
GROUP BY status, reason, year(start_time)
ORDER BY reason, year

-- P1Q2.1
SELECT Status, Reason,
       count(month(start_time)) AS Total_Number_Outage_Events,
       month(start_time) AS Month
FROM AEMR
WHERE year(start_time) IN('2016') AND 
      status IN('Approved')
GROUP BY status, reason, month(start_time)
ORDER BY reason, month(start_time)

-- P1Q2.2
SELECT Status, Reason, 
       count(month(start_time)) AS Total_Number_Outage_Events,
       month(start_time) AS Month
FROM AEMR
WHERE status ='Approved' AND year(start_time) = 2017
GROUP BY reason, month(start_time)
ORDER BY reason, month(start_time)

-- P1Q2.3
SELECT Status, 
       SUM(status IN('Approved')) AS Total_Number_Outage_Events,
       month(start_time) AS Month,
       year(start_time) AS Year
FROM AEMR
WHERE year(start_time) IN('2016', '2017') AND 
      status IN('Approved')
GROUP BY status, month(start_time), year(start_time)
ORDER BY year(start_time), month(start_time)

-- P1Q3.1
SELECT SUM(status IN('Approved')) AS Total_Number_Outage_Events, 
       Participant_Code, 
       Status,
       year(start_time) AS Year
FROM AEMR
WHERE year(start_time) IN('2016', '2017') AND 
      status IN('Approved')
GROUP BY status, year(start_time), Participant_Code
ORDER BY year(start_time), Participant_Code

-- P1Q3.2
SELECT Participant_Code, Status, Year(Start_Time) AS Year, 
ROUND(AVG(TIMESTAMPDIFF(minute, start_time, end_time)/1440), 2) AS Average_Outage_Duration_Time_Days
FROM AEMR
WHERE Status='Approved' 
GROUP BY Participant_Code, Status, Year(Start_Time)
ORDER BY Average_Outage_Duration_Time_Days DESC

-- P2Q1.1
SELECT count(reason IN('Forced')) AS Total_Number_Outage_Events,
Reason, year(start_time) AS Year
FROM AEMR
WHERE status IN('Approved') 
AND reason IN('Forced')
GROUP BY Reason, Year

-- P2Q1.2
SELECT SUM(CASE WHEN reason ='Forced'
           THEN 1 ELSE 0 END)
                  AS Total_Number_Forced_Outage_Events,
       COUNT(*) AS Total_Number_Outage_Events,
       
       ROUND(100 * (SUM(CASE WHEN reason ='Forced' 
           THEN 1 ELSE 0 END) / COUNT(*)), 2) AS Forced_Outage_Percentage,
       
       year(start_time) AS Year
FROM AEMR
WHERE status IN('Approved')
GROUP BY Year

-- P2Q2.1
SELECT Status,
       year(start_time) AS Year, 
       ROUND(AVG(Outage_MW), 2) AS Avg_Outage_MW_Loss, 
       ROUND(AVG(ROUND((TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)),2)),2) AS Average_Outage_Duration_Time_Minutes
FROM AEMR
WHERE status ='Approved' AND reason = 'Forced'
GROUP BY year(start_time)
ORDER BY year(start_time)

-- P2Q2.2
SELECT Participant_Code, Facility_Code, Status,
       year(start_time) AS Year,
       ROUND(AVG(Outage_MW), 2) AS Avg_Outage_MW_Loss,
       ROUND(SUM(Outage_MW), 2) AS Summed_Energy_Lost
FROM AEMR
WHERE status ='Approved' AND reason = 'Forced'
GROUP BY year(start_time), Participant_Code, Facility_Code
ORDER BY year(start_time), Avg_Outage_MW_Loss DESC

-- P2Q3.1
SELECT 
	Participant_Code
	,Status
	,Year(Start_Time) AS Year
	,ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss
	,ROUND(AVG((TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)/60)/24),2) AS Average_Outage_Duration_Time_Days
FROM 
	AEMR
WHERE 
	Status='Approved' 
	AND Reason='Forced'
GROUP BY 
	Participant_Code
	,Status
	,Reason
	,Year(Start_Time)
ORDER BY 
	Year(Start_Time) ASC
	,ROUND(AVG(Outage_MW),2) DESC

-- P2Q3.2
SELECT 
	Participant_Code
	,Facility_Code
	,Status
	,Year(Start_Time) AS Year
	,ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss
	,ROUND(SUM(Outage_MW),2) AS Summed_Energy_Lost
FROM 
	AEMR
WHERE 
	Status='Approved' 
	AND Reason='Forced'
GROUP BY 
	Participant_Code
	,Facility_Code
	,Status
	,Year(Start_Time)
ORDER BY 
	Year(Start_Time) ASC
	,ROUND(SUM(Outage_MW),2) DESC


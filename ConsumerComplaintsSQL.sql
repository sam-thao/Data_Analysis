-- Consumer Complaints
-- Dataset source http://www.consumerfinance.gov/data-research/consumer-complaints/
-- You are working for a government agency as a Data Analyst. You have been supplied a dataset with consumer complaints. Received by financial institutions in 2013 - 2015
-- Task one is to load dataset into SQL Server

SELECT *
FROM ConsumerComplaints

-- Find out how many complaints were received and sent on the same day. 
-- There are 28,737 complaints
-- Used CONVERT function to insure accuracy

SELECT COUNT(*) AS TotalComplaints
FROM ConsumerComplaints
WHERE CONVERT(DATE, [Date Received]) = CONVERT(DATE, [Date Sent to Company]);

-- Extract the complaints received in the states of New York

SELECT *
FROM ConsumerComplaints
WHERE [State Name] IN ('NY' , 'CA')
ORDER BY [State Name];

-- Extract the complaints received in the states of New York and the total complaints
-- In the state of NY, there are 4,413 complaints

SELECT [State Name], COUNT(Issue) AS TotalComplaints
FROM ConsumerComplaints
WHERE [State Name] = 'NY'
GROUP BY [State Name];

-- Extract ALL rows with the word 'Credit' in the Product field

SELECT *
FROM ConsumerComplaints
WHERE [Product Name] LIKE '%Credit%';

-- Using count there are 18,564 total rows with credit 
SELECT COUNT(*) AS TotalCreditProduct
FROM ConsumerComplaints
WHERE [Product Name] LIKE '%Credit%';


-- Extract all rows with the word 'Late' in the Issue Field

SELECT *
FROM ConsumerComplaints
WHERE Issue LIKE '%Late%';

-- 312 rows with late conplaints in issue row
SELECT COUNT(*) AS TotalLateIssue
FROM ConsumerComplaints
WHERE Issue LIKE '%Late%';


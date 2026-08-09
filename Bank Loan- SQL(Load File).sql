create database bank_analysis_loandb;
use bank_analysis_loandb;

CREATE TABLE bank_loan_raw (
    `State Abbr` varchar(20),
    `Account ID` varchar(20),
    `Age` varchar(20),
    `BH Name`   varchar(100),
    `Bank Name` varchar(20),
    `Branch Name`  varchar(20),
    `Caste` varchar(10),
    `Center Id` int,
    `City` varchar(50),
    `Client id` int,
    `Client Name` varchar(100),
    `Close Client` varchar(10),
    `Closed Date` DATETIME,
    `Credif Officer Name` varchar(100),
    `Dateof Birth` Date,
    `Disb By` varchar(100),
    `Disbursement Date` Date,
    `Disbursement Date (Years)` varchar(20),
    `Gender ID` varchar(10),
    `Home Ownership` varchar(20),
    `Loan Status` varchar(20),
    `Loan Transferdate` varchar(5),
    `NextMeetingDate` Date,
    `Product Code` varchar(5),
    `Grrade` varchar(10),
    `Sub Grade` varchar(10),
    `Product Id` varchar(10),
    `Purpose Category` varchar(50),
    `Region Name` varchar(30),
	`Religion` varchar(20),
	`Verification Status` varchar(30),
	`State Name` varchar(20),
	`Tranfer Logic` varchar(5),
	`Is Delinquent Loan` varchar(5),
	`Is Default Loan` varchar(5),
	`Age _T` int,
	`Delinq 2 Yrs` int,
	`Application Type` varchar(15),
	`Loan Amount` int,
	`Funded Amount` int,
	`Funded Amount Inv` int,
	`Term` varchar(15),
	`Int Rate` varchar(10),
	`Total Pymnt` Decimal(12,2),
	`Total Pymnt inv` Decimal(12,2),
	`Total Rec Prncp` Decimal(12,2),
	`Total Fees` Decimal(10,2),
	`Total Rrec int` Decimal(12,2),
	`Total Rec Late fee` Decimal(10,2),	
    `Recoveries` Decimal(12,2),
	`Collection Recovery fee` Decimal(10,2)
);

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/uploads/BankData.csv'
INTO TABLE bank_loan_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
`State Abbr`,
`Account ID`,
`Age`,
`BH Name`,
`Bank Name`,
`Branch Name`,
`Caste`,
`Center Id`,
`City`,
`Client id`,
`Client Name`,
`Close Client`,
`Closed Date`,
`Credif Officer Name`,
`Dateof Birth`,
`Disb By`,
`Disbursement Date`,
`Disbursement Date (Years)`,
`Gender ID`,
`Home Ownership`,
`Loan Status`,
`Loan Transferdate`,
`NextMeetingDate`,
`Product Code`,
`Grrade`,
`Sub Grade`,
`Product Id`,
`Purpose Category`,
`Region Name`,
`Religion`,
`Verification Status`,
`State Name`,
`Tranfer Logic`,
`Is Delinquent Loan`,
`Is Default Loan`,
`Age _T`,
`Delinq 2 Yrs`,
`Application Type`,
`Loan Amount`,
`Funded Amount`,
`Funded Amount Inv`,
`Term`,
`Int Rate`,
`Total Pymnt`,
`Total Pymnt inv`,
`Total Rec Prncp`,
`Total Fees`,
`Total Rrec int`,
`Total Rec Late fee`,	
`Recoveries`,
`Collection Recovery fee`
);

select * from bank_loan_raw;

SELECT COUNT(*) AS Blank_ClosedDate
FROM bank_loan_raw
WHERE `Closed Date` IS NULL;

SELECT COUNT(*) AS Blank_DOB
FROM bank_loan_raw
WHERE `Dateof Birth` IS NULL;

SELECT COUNT(*) AS Blank_NextMeeting
FROM bank_loan_raw
WHERE NextMeetingDate IS NULL;

SELECT `Home Ownership`, COUNT(*)
FROM bank_loan_raw
GROUP BY `Home Ownership`;

SELECT `Verification Status`, COUNT(*)
FROM bank_loan_raw
GROUP BY `Verification Status`;

SELECT `Loan Status`, COUNT(*)
FROM bank_loan_raw
GROUP BY `Loan Status`;

SELECT `Gender ID`, COUNT(*)
FROM bank_loan_raw
GROUP BY `Gender ID`;

SELECT Religion, COUNT(*)
FROM bank_loan_raw
GROUP BY Religion;

-- Duplicate Records
SELECT `Client ID`,
COUNT(*) AS Total
FROM bank_loan_raw
GROUP BY `Client ID`
HAVING COUNT(*) > 1;

-- Check numeric columns
## 1. Total Loan amount
SELECT
MIN(`Loan Amount`),
MAX(`Loan Amount`)
FROM bank_loan_raw;

## 2. Funded Amount
SELECT
MIN(`Funded Amount`),
MAX(`Funded Amount`)
FROM bank_loan_raw;

## 3. Interest Rate
SELECT DISTINCT `Int Rate`
FROM bank_loan_raw
LIMIT 20;

-- Check Date Columns
SELECT
MIN(`Disbursement Date`),
MAX(`Disbursement Date`)
FROM bank_loan_raw;

SELECT
MIN(`closed date`),
MAX(`closed date`)
FROM bank_loan_raw;

SELECT COUNT(*)
FROM bank_loan_raw
WHERE `Dateof Birth` = '0000-00-00';

SELECT `Disbursement Date`
FROM bank_loan_raw
LIMIT 20;

describe bank_loan_raw;

SELECT @@sql_mode;
SELECT *
FROM bank_loan_raw
WHERE YEAR(`Dateof Birth`) = 0;

SET SQL_SAFE_UPDATES = 0;

UPDATE bank_loan_raw
SET `Dateof Birth` = NULL
WHERE YEAR(`Dateof Birth`) = 0;

SELECT COUNT(*)
FROM bank_loan_raw
WHERE YEAR(`Dateof Birth`) = 0;

SELECT COUNT(*)
FROM bank_loan_raw
WHERE YEAR(`Disbursement Date`) = 0;

SELECT COUNT(*)
FROM bank_loan_raw
WHERE YEAR(`Closed Date`) = 0;

SELECT `Closed Date`
FROM bank_loan_raw
WHERE YEAR(`Closed Date`) = 0
LIMIT 10;

UPDATE bank_loan_raw
SET `Closed Date` = NULL
WHERE `Closed Date` = '0000-00-00 00:00:00';

SELECT COUNT(*)
FROM bank_loan_raw
WHERE YEAR(`NextMeetingDate`) = 0;

## checking empty strings
SELECT COUNT(*)
FROM bank_loan_raw
WHERE `Home Ownership` = '';

SELECT COUNT(*)
FROM bank_loan_raw
WHERE `Verification Status` = '';

SELECT COUNT(*)
FROM bank_loan_raw
WHERE Religion = '';

## check leading/trailing spaces
SELECT DISTINCT `Home Ownership`
FROM bank_loan_raw;

SELECT DISTINCT `Verification Status`
FROM bank_loan_raw;

SELECT DISTINCT Religion
FROM bank_loan_raw;
-- Concludion = no need of trim

SELECT DISTINCT `Sub Grade`
FROM bank_loan_raw
ORDER BY `Sub Grade`;



## CREATE DATABASE ##
CREATE DATABASE BankDataAnalysis;
USE BankDataAnalysis;

## BANK TRANSACTIONS TABLE ##
CREATE TABLE bank_transactions (
    Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(100),
    Account_Number BIGINT,
    Transaction_Date DATE,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(12 , 2 ),
    Balance DECIMAL(12 , 2 ),
    Description VARCHAR(255),
    Branch VARCHAR(100),
    Transaction_Method VARCHAR(50),
    Currency VARCHAR(10),
    Bank_Name VARCHAR(100),
    Year INT,
    MonthNo INT,
    MonthName VARCHAR(20),
    Quarter VARCHAR(5),
    YearMonth VARCHAR(20),
    WeekNo INT,
    WeekDay VARCHAR(20),
    Credit_Amount DECIMAL(12 , 2 ),
    Debit_Amount DECIMAL(12 , 2 ),
    HighRisk_Flag VARCHAR(50)
);
DESC bank_transactions;

## LOAD THE DATA FILE ##
LOAD DATA LOCAL INFILE 'E:/RADHIKA/EXCELR_PROJECT/PROJECT_THREE_BANKING_FINANCE/SQL/BankCards.csv'
INTO TABLE bank_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
Customer_ID,
Customer_Name,
Account_Number,
@Transaction_Date,
Transaction_Type,
Amount,
Balance,
Description,
Branch,
Transaction_Method,
Currency,
Bank_Name,
Year,
MonthNo,
MonthName,
Quarter,
YearMonth,
WeekNo,
WeekDay,
Credit_Amount,
Debit_Amount,
HighRisk_Flag
)
SET Transaction_Date = STR_TO_DATE(@Transaction_Date, '%Y-%m-%d');

## CHECK THE TABLE ##
SELECT * FROM bank_transactions;
    
 ############KPIs FOR BANK TRANSACTION ANALYSIS ##################   
    
#### Create view for credit debit transaction sumary ###
CREATE VIEW vw_TransactionSummary AS
    SELECT 
        SUM(CASE
            WHEN Transaction_Type = 'Credit' THEN Amount
            ELSE 0
        END) AS TotalCredit,
        SUM(CASE
            WHEN Transaction_Type = 'Debit' THEN Amount
            ELSE 0
        END) AS TotalDebit
    FROM
        bank_transactions;
        
# 1-Total Credit Amount:
SELECT 
    CONCAT(ROUND(COALESCE(Ts.TotalCredit, 0) / 1000000, 2),
            ' Mn') AS TotalCreditAmount
FROM
    vw_TransactionSummary Ts;

# 2-Total Debit Amount:
SELECT 
    CONCAT(ROUND(COALESCE(Ts.TotalDebit, 0) / 1000000, 2),
            ' Mn') AS TotalDebitAmount
FROM
    vw_TransactionSummary Ts;

# 3-Credit to Debit Ratio:
WITH TransactionsSummary AS
(
	SELECT 
	SUM(
		CASE 
		WHEN Transaction_Type = 'Credit'
		THEN Amount
		ELSE 0
		END
	) AS TotalCredit,
	SUM(
		CASE 
		WHEN Transaction_Type = 'Debit'
		THEN Amount
		ELSE 0
		END
	) AS TotalDebit
	FROM bank_transactions
)
SELECT 
CONCAT(ROUND(TH.TotalCredit/NULLIF(TH.TotalDebit,0),2),' : 1') AS CreditDebitRatio
FROM TransactionsSummary AS TH;

# 4-Net Transaction Amount:
SELECT 
    (CASE
        WHEN
            TotalCredit - TotalDebit > 1000000
        THEN
            CONCAT(ROUND((TotalCredit - TotalDebit) / 1000000, 2),
                    ' Mn')
        WHEN
            (TotalCredit - TotalDebit) > 10000
        THEN
            CONCAT(ROUND((TotalCredit - TotalDebit) / 10000, 2),
                    ' K')
        ELSE ROUND((TotalCredit - TotalDebit), 2)
    END) AS NetTransactionAmount
FROM
    vw_TransactionSummary;

# 5-Account Activity Ratio:
SELECT 
    ROUND(COUNT(*) / NULLIF(AVG(Balance),0) ,2) AS AccountActivityRatio
FROM
    bank_transactions;
    
# 6-Transactions per Day/Week/Month:

# a)Transactions Per Day
SELECT 
	ROW_NUMBER() OVER(ORDER BY Transaction_Date) AS RowNumber,
	Transaction_Date as TransactionDate,
	COUNT(*) AS NoOfTransactionsPerDay    
FROM 
	bank_transactions
GROUP BY Transaction_Date;

# b)Transactions Per Month
SELECT 
    YEAR(Transaction_Date) AS TransactionYear,
    MONTHNAME(Transaction_Date) AS TransactionMonthName,
    COUNT(*) AS NoOfTransactionsPerMnth
FROM
    bank_transactions
GROUP BY YEAR(Transaction_Date) , MONTH(Transaction_Date) , MONTHNAME(Transaction_Date)
ORDER BY MONTH(Transaction_Date);
  
# c)Transactions Per Week
SELECT 
    WEEK(Transaction_Date, 3) AS TransactionWeekNum,
    COUNT(*) AS NoOfTransactionsPerWeek
FROM
    bank_transactions
GROUP BY WEEK(Transaction_Date, 3)
ORDER BY WEEK(Transaction_Date, 3);
 
# 7-Total Transaction Amount by Branch:
SELECT 
    Branch,
    CONCAT(ROUND(SUM(Amount) / 1000000, 2), ' Mn') AS TotalTransactionAmntBranch
FROM
    bank_transactions
GROUP BY Branch;

# 8-Transaction Volume by Bank:
SELECT 
    Bank_Name,
    CONCAT(ROUND(SUM(Amount) / 1000000, 2), ' Mn') AS TotalTransactionAmntBankName
FROM
    bank_transactions
GROUP BY Bank_Name;

# 9-Transaction Method Distribution:
SELECT 
    Transaction_Method,
    COUNT(Transaction_date) AS TransactionCount,
    CONCAT(ROUND(COUNT(*) * 100 / (SELECT 
                            COUNT(*)
                        FROM
                            bank_transactions),
                    2),
            '%') AS Percentage
FROM
    bank_transactions
GROUP BY Transaction_Method;

# b) To get Direct percentage for the method used.
WITH TrnsctionPercentByMethod AS
 (
	SELECT
    ##Round up the sum to show as percentage
   	 ROUND(COUNT( 
	 CASE 
     WHEN Transaction_Method = 'Credit Card'
	 THEN  1 
	 END
	 )*100/COUNT(*),2) AS CreditCardPercent,
	ROUND(COUNT( 
	 CASE 
     WHEN Transaction_Method = 'Debit Card'
	 THEN 1
	 END
	 )*100/COUNT(*),2) AS DebitCardPercent,
	ROUND(COUNT( 
	 CASE 
     WHEN Transaction_Method = 'Bank Transfer'
     THEN 1
	 END
	 )*100/COUNT(*),2) AS BankTransferPercent
	FROM bank_transactions
 ) 
 SELECT * FROM TrnsctionPercentByMethod;
 
 ### Calculate Using amount for but not recommended as the number
 ### of transactios using method is important.
/* SELECT
    ##Round up the sum to show as percentage
   	 ROUND(SUM( 
	 CASE 
     WHEN Transaction_Method = 'Credit Card'
	 THEN  Amount 
	 ELSE 0
	 END
	 )*100/SUM(Amount) ,2) AS CreditCardPercent,
	ROUND(SUM( 
	 CASE 
     WHEN Transaction_Method = 'Debit Card'
	 THEN Amount
	 ELSE 0
	 END
	 )*100/SUM(Amount) ,2) AS DebitCardPercent,
	ROUND(SUM( 
	 CASE 
     WHEN Transaction_Method = 'Bank Transfer'
     THEN Amount
	 ELSE 0
	 END
	 )*100/SUM(Amount) ,2) AS BankTransferPercent
FROM bank_transactions;*/

## 10-Branch Transaction Growth:
## Percentage change in the total transaction amount 
## or volume at each branch over a Quarter

## Create View for year and Quarter wise volume detials.
CREATE VIEW VW_VolumeQoQ AS
SELECT 	
	Branch,
    YEAR(Transaction_Date) AS Year,
    QUARTER(Transaction_Date) AS QuarterNo,
	SUM(AMount) AS Current_QuarterVolume,
    LAG(SUM(Amount)) 
	OVER(PARTITION BY Branch ORDER BY YEAR(Transaction_Date),QUARTER(Transaction_Date))
    AS Prev_QuarterVolume
FROM bank_transactions
GROUP BY YEAR(Transaction_Date),
		 QUARTER(Transaction_Date),
		 Branch;

SELECT * FROM VW_VolumeQoQ;

## Transaction Growth:
SELECT 
    Branch,
    Year,
    QuarterNo,
    (Current_QuarterVolume - Prev_QuarterVolume) AS VolumneDifference,
    CONCAT(ROUND(((Current_QuarterVolume / Prev_QuarterVolume) - 1) * 100,
                    2),
            '%') AS PercentChange
FROM
    VW_VolumeQoQ;

# 11-High-Risk Transaction Flag:
SELECT 
    Transaction_Type AS TransactionType,
    CASE
        WHEN amount > 4000 THEN 'High Risk'
        ELSE 'Normal'
    END AS TransactionFlag
FROM
    bank_transactions;

# 12-Suspicious Transaction Frequency:    
SELECT 	
    RANK() Over(ORDER BY (COUNT(CASE WHEN amount > 4000 THEN  1 END)) DESC) AS QrtrRankedWithMaxFlag,
    QUARTER(Transaction_Date) As Quarter,
	COUNT(CASE WHEN amount > 4000 THEN  1 END) AS CountHighRiskTransaction
FROM bank_transactions
    GROUP BY QUARTER(Transaction_Date);
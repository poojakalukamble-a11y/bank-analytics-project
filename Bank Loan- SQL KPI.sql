use bank_analysis_loandb;

## KPI 1 – Total Loan Amount Funded

SELECT SUM(`Funded Amount`) AS Total_Loan_Amount_Funded FROM bank_loan_raw;
SELECT concat(round(SUM(`Funded Amount`)/1000000,2), "M") AS Total_Loan_Amount_Funded FROM bank_loan_raw;

## KPI 2 – Total Loans

SELECT COUNT(`Client id`) AS Total_Loans FROM bank_loan_raw;
-- OR
SELECT COUNT(*) AS Total_Loans FROM bank_loan_raw;

## KPI 3 – Total Collection

SELECT ROUND(SUM(`Total Pymnt`),2) AS Total_Collection
FROM bank_loan_raw;

## KPI 4 – Total Interest
SELECT
ROUND(SUM(`Total Rrec int`),2) AS Total_Interest
FROM bank_loan_raw;

## KPI 5: Branch-Wise Performance

SELECT
    `Branch Name`,
    ROUND(SUM(`Total Rrec int`),2) AS Total_Interest,
    ROUND(SUM(`Total Fees`),2) AS Total_Fees,
    ROUND(SUM(`Total Pymnt`),2) AS Total_Revenue
FROM bank_loan_raw
GROUP BY `Branch Name`
ORDER BY Total_Revenue DESC;

## KPI 6: State-Wise Loan

SELECT
    `State Name`,
    SUM(`Funded Amount`) AS Total_Loan_Amount
FROM bank_loan_raw
GROUP BY `State Name`
ORDER BY Total_Loan_Amount DESC;

## KPI 7: Religion-Wise Loan

SELECT
    Religion,
    COUNT(*) AS Total_Loans,
    SUM(`Funded Amount`) AS Total_Funded
FROM bank_loan_raw
GROUP BY Religion
ORDER BY Total_Funded DESC;

## KPI 8: Product Group-Wise Loan
SELECT
    `Product Code`,
    COUNT(*) AS Total_Loans,
    SUM(`Funded Amount`) AS Total_Funded
FROM bank_loan_raw
GROUP BY `Product Code`
ORDER BY Total_Funded DESC;

SELECT
    `Purpose Category`,
    COUNT(*) AS Total_Loans,
    SUM(`Funded Amount`) AS Total_Funded
FROM bank_loan_raw
GROUP BY `Purpose Category`
ORDER BY Total_Funded DESC;

## KPI 9: Disbursement Trend

SELECT
    DATE_FORMAT(`Disbursement Date`,'%Y-%M') AS Month,
    COUNT(*) AS Total_Loans,
    SUM(`Funded Amount`) AS Total_Funded
FROM bank_loan_raw
GROUP BY DATE_FORMAT(`Disbursement Date`,'%Y-%M')
ORDER BY Month;

## KPI 10: Grade-Wise Loan

SELECT
    `Grrade`,
    COUNT(*) AS Total_Loans,
    SUM(`Funded Amount`) AS Total_Funded
FROM bank_loan_raw
GROUP BY `Grrade`
ORDER BY `Grrade`;

## KPI 11: Loan Status-Wise Loan

SELECT
    `Loan Status`,
    COUNT(*) AS Total_Loans,
    SUM(`Funded Amount`) AS Total_Funded
FROM bank_loan_raw
GROUP BY `Loan Status`
ORDER BY Total_Funded DESC;

## KPI 12: Age Group-Wise Loan

SELECT
    Age,
    COUNT(*) AS Total_Loans,
    SUM(`Funded Amount`) AS Total_Funded
FROM bank_loan_raw
GROUP BY Age
ORDER BY Age;

## KPI 13: Loan Maturity

SELECT
    Term,
    COUNT(*) AS Total_Loans,
    SUM(`Funded Amount`) AS Total_Funded
FROM bank_loan_raw
GROUP BY Term
ORDER BY Term;
SELECT DISTINCT `Product Code`
FROM bank_loan_raw;

## KPI 14: Default Loan Count

SELECT
    COUNT(*) AS Default_Loan_Count
FROM bank_loan_raw
WHERE `Is Default Loan` = 'Y';

## KPI 15: Delinquent Client Count

SELECT
    COUNT(*) AS Delinquent_Client_Count
FROM bank_loan_raw
WHERE `Is Delinquent Loan` = 'Y';

## KPI 16: Delinquent Loan Rate

SELECT ROUND((COUNT(CASE WHEN `Is Delinquent Loan`='Y' THEN 1 END)
/COUNT(*))*100,2) AS Delinquent_Loan_Rate
FROM bank_loan_raw;

## KPI 17: Default Loan Rate

SELECT
ROUND((COUNT(CASE WHEN `Is Default Loan`='Y' THEN 1 END)
/COUNT(*))*100,2) AS Default_Loan_Rate
FROM bank_loan_raw;

## KPI 18: No Verified Loans

SELECT COUNT(*) AS No_Verified_Loans
FROM bank_loan_raw
WHERE `Verification Status`='Not Verified';

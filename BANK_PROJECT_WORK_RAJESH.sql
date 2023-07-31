CREATE DATABASE BANK;
USE BANK;
SET SQL_MODE = ""
-- Below link just to understand how to retirve EER diagram in mySQL, before that need to create table schema assgingin primary 
-- and foreign key
-- Link how to get EER diagram(https://medium.com/@tushar0618/how-to-create-er-diagram-of-a-database-in-mysql-workbench-209fbf63fd03)

CREATE TABLE DISTRICT(
District_Code INT ,
District_Name VARCHAR(100),
Region VARCHAR(100)	,
No_of_inhabitants	INT,
No_of_municipalities_with_inhabitants_less_499 INT,
No_of_municipalities_with_inhabitants_500_btw_1999	INT,
No_of_municipalities_with_inhabitants_2000_btw_9999	INT,
No_of_municipalities_with_inhabitants_less_10000 INT,	
No_of_cities	INT,
Ratio_of_urban_inhabitants	FLOAT,
Average_salary	INT,
No_of_entrepreneurs_per_1000_inhabitants	INT,
No_committed_crime_2017	INT,
No_committed_crime_2018 INT
) ;

LOAD DATA INFILE 'C:/district.csv'
into table district
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

SELECT * FROM DISTRICT

ALTER table DISTRICT add primary key(District_Code) 

CREATE TABLE ACCOUNT(
account_id INT ,
district_id	INT,
frequency	VARCHAR(40),
`Date` DATE ,
Account_type VARCHAR(40),
Card_Assigned varchar(50)	
);

LOAD DATA INFILE 'C:/account.csv'
into table account
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

SELECT * FROM ACCOUNT


CREATE TABLE `ORDER`(
order_id	INT ,
account_id	INT,
bank_to	VARCHAR(45),
account_to	INT,
amount FLOAT
);

LOAD DATA INFILE 'C:/order.csv'
into table `ORDER`
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

SELECT * FROM `ORDER`

CREATE TABLE LOAN(
loan_id	INT ,
account_id	INT,
`Date`	DATE,
amount	INT,
duration	INT,
payments	INT,
`status` VARCHAR(35)
);

LOAD DATA INFILE 'C:/loan.csv'
into table loan
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

SELECT * FROM LOAN

DROP TABLE TRANSACTIONS

CREATE TABLE TRANSACTIONS(
trans_id INT,	
account_id	INT,
`Date`	DATE,
`Type`	VARCHAR(30),
operation	VARCHAR(40),
amount	INT,
balance	FLOAT,
Purpose	VARCHAR(40),
bank	VARCHAR(45),
account_partern_id INT);

LOAD DATA INFILE 'C:/trnx_16.csv'
into table TRANSACTIONS
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

-- Loading additional dataset trnx_17 in TRANSACTIONS table 

LOAD DATA INFILE 'C:/trnx_17.csv'
into table TRANSACTIONS
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

-- Loading additional dataset trnx_18 in TRANSACTIONS table 

LOAD DATA INFILE 'C:/trnx_18.csv'
into table TRANSACTIONS
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

-- Loading additional dataset trnx_19 in TRANSACTIONS table 

LOAD DATA INFILE 'C:/trnx_19.csv'
into table TRANSACTIONS
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

-- Loading additional dataset trnx_21_NEW in TRANSACTIONS table
LOAD DATA INFILE 'C:/trnx_21_NEW.csv'
into table TRANSACTIONS
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

SELECT * FROM TRANSACTIONS

DROP TABLE CLIENT

CREATE TABLE CLIENT(
client_id	INT ,
Sex	VARCHAR(10),
birth_date	varchar(40),
district_id INT 
);

LOAD DATA INFILE 'C:/client.csv'
into table CLIENT
FIELDS TERMINATED by ';'
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

-- While using above command I got error number 1265 and showing null data in column, then i tried below syntax

LOAD DATA INFILE 'C:/client.csv'
INTO TABLE CLIENT 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@col1, @col2, @col3, @col4)
SET client_id = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(@col1,'\t',''), '$',''), '\r', ''), '\n', ''))
, Sex = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(@col2,'\t',''), '$',''), '\r', ''), '\n', ''))
, birth_date = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(@col3,'\t',''), '$',''), '\r', ''), '\n', ''))
, district_id = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(@col4,'\t',''), '$',''), '\r', ''), '\n', ''));

select * from CLIENT 

CREATE TABLE DISPOSITION(
disp_id	INT ,
client_id INT,
account_id	INT,
`type` CHAR(15)
);

LOAD DATA INFILE 'C:/disp.csv'
into table DISPOSITION
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

select * from DISPOSITION

CREATE TABLE CARD(
card_id	INT ,
disp_id	INT,
`type` CHAR(10)	,
issued DATE
);

LOAD DATA INFILE 'C:/card.csv'
into table card
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

select * from card

SELECT * FROM DISTRICT
SELECT * FROM ACCOUNT
SELECT * FROM `ORDER`
SELECT * FROM LOAN
SELECT * FROM TRANSACTIONS
select * from CLIENT 
select * from DISPOSITION
select * from card

-- I did not formed primary key and foreign key at the time of tbale creation, as if any error need to modifed table, its
-- difficult to modify as it need to cancel primary and foreign key first and its time consuming work.
-- Now since tabel has been created and data uploaded in table lets understand the data and find where we need to form keys
-- in each table to connect and create primary and foreign key accordingly

-- Creating primary key for tbale DISTRICT
ALTER table DISTRICT add primary key(District_Code); 

-- Creating primary key and foreign key for tbale ACCOUNT
ALTER table ACCOUNT add primary key(account_id);
ALTER table ACCOUNT add FOREIGN KEY (district_id) references DISTRICT(District_Code);

-- Creating primary and foreign key for Order
ALTER table `ORDER` add primary key(order_id);
ALTER table `ORDER` add FOREIGN KEY (account_id) references ACCOUNT(account_id);

SHOW CREATE TABLE `ORDER`

-- Creating primary key for tbale LOAN
ALTER table LOAN add FOREIGN KEY (account_id) references ACCOUNT(account_id);

-- Creating primary and foreign key for TRANSACTIONS
ALTER table TRANSACTIONS add primary key(trans_id);
ALTER table TRANSACTIONS add FOREIGN KEY (account_id) references ACCOUNT(account_id);

SHOW CREATE TABLE TRANSACTIONS;

ALTER TABLE TRANSACTIONS DROP CONSTRAINT account_id;
ALTER TABLE TRANSACTIONS DROP FOREIGN KEY account_id;
ALTER TABLE TRANSACTIONS DROP PRIMARY KEY trans_id;

-- Creating primary and foreign key for CLIENT
ALTER table CLIENT add primary key(client_id);
ALTER table CLIENT add FOREIGN KEY (district_id) references DISTRICT(District_Code);

-- Creating primary and foreign key for DISPOSITION
ALTER table DISPOSITION add primary key(disp_id);
ALTER table DISPOSITION add FOREIGN KEY (account_id) references ACCOUNT(account_id);
ALTER table DISPOSITION add FOREIGN KEY (client_id) references CLIENT(client_id);

-- Creating primary and foreign key for CARD
ALTER table CARD add primary key(card_id);
ALTER table CARD add FOREIGN KEY (disp_id) references DISPOSITION(disp_id);


-- Transformation Solving Client Problem Statement
-- Client need us to change the year as per below in date column

-- Create Age column in CLIENT
-- SELECT *, DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), birth_date)), '%Y') + 0 AS age FROM CLIENT; (SOME TRIAL SYNTAX)

-- SELECT *, DATE_FORMAT(FROM_DAYS(DATEDIFF('2022-12-31', birth_date)), '%Y') + 0 AS age FROM CLIENT;

ALTER TABLE CLIENT
ADD COLUMN AGE int(20) after birth_date;
UPDATE CLIENT SET AGE = DATE_FORMAT(FROM_DAYS(DATEDIFF('2022-12-31', birth_date)), '%Y') + 0;

-- 1Convert the Date attribute into a yyyy-mm-dd by adding 24 in year format in Excel or SQL 
/*
 CONVERT 2019 TXN_YEAR TO 2021 -- Need to add 2 years in 2019 to get 2021
 CONVERT 2018 TXN_YEAR TO 2020 -- Need to add 2 years in 2018 to get 2020
 CONVERT 2017 TXN_YEAR TO 2019 -- Need to add 2 years in 2017 to get 2019
 CONVERT 2016 TXN_YEAR TO 2018 -- Need to add 2 years in 2016 to get 2018
 CONVERT 2021 TXN_YEAR TO 2017 -- Need to add 2 years in 2019 to get 2021

*/
SELECT MIN(`DATE`), MAX(`DATE`) FROM TRANSACTIONS;

SELECT YEAR(`DATE`) AS TXN_YEAR, COUNT(*) AS TOT_TXN
FROM TRANSACTIONS
GROUP BY 1
ORDER BY 1 DESC;

/*
UPDATE TRANSACTIONS
SET `DATE` = dateadd('year',4,`DATE`)
WHERE YEAR(`DATE`) = 2016;

-- While running above syntax I got a Error 1305 Function bank.datedadd not exist, so tried below commnad seems working fine
SELECT *, DATE_ADD(`DATE`, INTERVAL -4 YEAR) AS NEW_DATE FROM TRANSACTIONS WHERE YEAR(`DATE`) = 2021;

UPDATE TRANSACTIONS
SET `DATE` = DATE_ADD(`DATE`, INTERVAL 2 YEAR)
WHERE YEAR(`DATE`) = 2017;

UPDATE TRANSACTIONS
SET `DATE` = DATE_ADD(`DATE`, INTERVAL 2 YEAR)
WHERE YEAR(`DATE`) = 2018;

UPDATE TRANSACTIONS
SET `DATE` = DATE_ADD(`DATE`, INTERVAL 2 YEAR)
WHERE YEAR(`DATE`) = 2019;

UPDATE TRANSACTIONS
SET `DATE` = DATE_ADD(`DATE`, INTERVAL -4 YEAR)
WHERE YEAR(`DATE`) = 2021;

SELECT MIN(`DATE`), MAX(`DATE`) FROM TRANSACTIONS;
*/
-- Finally decided to change only one year as 2016 to 2020 and kept year flow 2017 to 2021
UPDATE TRANSACTIONS
SET `DATE` = DATE_ADD(`DATE`, INTERVAL 4 YEAR)
WHERE YEAR(`DATE`) = 2016;

SELECT YEAR(`DATE`) AS NEW_YEAR, SUM(AMOUNT) FROM TRANSACTIONS GROUP BY NEW_YEAR ORDER BY NEW_YEAR;



-- Find Total Credit Transactions amount year wise
SELECT YEAR(`Date`) AS TXN_YEAR, SUM(AMOUNT) AS CR_TXN 
FROM TRANSACTIONS WHERE TYPE = 'Credit' 
GROUP BY TXN_YEAR
ORDER BY 1 DESC;

-- Find Total Withdrawal Transactions amount year wise
SELECT YEAR(`Date`) AS TXN_YEAR, SUM(AMOUNT) AS WITD_TXN 
FROM TRANSACTIONS WHERE TYPE = 'Withdrawal' 
GROUP BY TXN_YEAR
ORDER BY 1 DESC;

-- Finding Cash surplus with bank after getting total credit and withdrawal of bank per annum 
-- and subtracting withdrawal from credited ammount
SELECT YEAR(`Date`) AS YEAR, (SELECT sum(AMOUNT) FROM TRANSACTIONS WHERE TYPE = 'Credit') AS CR_TXN, 
(SELECT sum(AMOUNT) FROM TRANSACTIONS WHERE TYPE = 'Withdrawal') AS WID_TXN, 
(SELECT CR_TXN - WID_TXN) AS cash_surplus 
FROM TRANSACTIONS 
GROUP BY YEAR
ORDER BY 1 DESC;

-- Finding most frequent purpose FOR customer withdraw and deposit amount in bank and amount volume
SELECT Purpose, TYPE, sum(amount) AS VALUE, count(Purpose) AS PURPOSE_VOLUME
FROM TRANSACTIONS 
GROUP BY 1 
ORDER BY PURPOSE_VOLUME DESC;

-- Finding most frequent purpose customer withdraw and deposit amount in bank and amount volume FOR EACH EYAR
SELECT Purpose, TYPE, sum(amount), count(Purpose) FROM TRANSACTIONS WHERE YEAR(`Date`) = '2016' GROUP BY 1 ORDER BY 1 DESC;
SELECT Purpose, TYPE, sum(amount), count(Purpose) FROM TRANSACTIONS WHERE YEAR(`Date`) = '2017' GROUP BY 1 ORDER BY 1 DESC;
SELECT Purpose, TYPE, sum(amount), count(Purpose) FROM TRANSACTIONS WHERE YEAR(`Date`) = '2018' GROUP BY 1 ORDER BY 1 DESC;
SELECT Purpose, TYPE, sum(amount), count(Purpose) FROM TRANSACTIONS WHERE YEAR(`Date`) = '2019' GROUP BY 1 ORDER BY 1 DESC;

-- Counting Account_ID holders which has withdrawn and credited money during the years 
SELECT count(ACCOUNT_ID) AS WITHDRAWER FROM TRANSACTIONS WHERE TYPE = 'Withdrawal';
SELECT count(ACCOUNT_ID) AS CREDITOR FROM TRANSACTIONS WHERE TYPE = 'Credit';

SELECT YEAR(`Date`) AS TXN_YEAR, count(ACCOUNT_ID) FROM TRANSACTIONS 
WHERE TYPE = 'Withdrawal' 
GROUP BY TXN_YEAR
ORDER BY 1 DESC;

SELECT YEAR(`Date`) AS TXN_YEAR, count(ACCOUNT_ID) FROM TRANSACTIONS 
WHERE TYPE = 'Credit' 
GROUP BY TXN_YEAR
ORDER BY 1 DESC;

-- Counting Account_ID holders which has withdrawn and credited money maximum time during the years
SELECT YEAR(`Date`) AS TXN_YEAR, ACCOUNT_ID, count(ACCOUNT_ID) AS WITHDRAWER FROM TRANSACTIONS 
WHERE TYPE = 'Withdrawal' 
GROUP BY  ACCOUNT_ID
ORDER BY TXN_YEAR, WITHDRAWER DESC;

SELECT YEAR(`Date`) AS TXN_YEAR, ACCOUNT_ID, count(ACCOUNT_ID) AS DEPOSITOR FROM TRANSACTIONS 
WHERE TYPE = 'Credit' 
GROUP BY ACCOUNT_ID
ORDER BY  TXN_YEAR, ACCOUNT_ID DESC;

-- To Check if to work below syntax properly
SELECT YEAR(`Date`), sum(amount) AS CR_AMT, count(ACCOUNT_ID) AS DEPOSITOR FROM TRANSACTIONS 
WHERE ACCOUNT_ID = '11359' AND TYPE = 'Credit'  GROUP BY YEAR(`Date`) ORDER BY 1 DESC;

-- Counting Account_ID holders which has withdrawn and credited money maximum time during the years with total amount
SELECT YEAR(`Date`) AS TXN_YEAR, sum(amount) AS CR_AMT, ACCOUNT_ID, count(ACCOUNT_ID) AS DEPOSITOR FROM TRANSACTIONS 
WHERE TYPE = 'Credit' 
GROUP BY ACCOUNT_ID
ORDER BY  TXN_YEAR, ACCOUNT_ID DESC;

-- In due course of time bank has opened new banks and it is need to update in the data where ever data is null or blank
-- First lets check each year bank column satus if blank or null

SELECT BANK FROM TRANSACTIONS WHERE YEAR(`DATE`) = '2016'-- To be change the year to find if any blank values in BANK

-- In 2021 bank has launched new bank as 'Sky Bank' so need to update in Bank column
UPDATE TRANSACTIONS 
SET BANK = 'Sky Bank' WHERE BANK = '' AND YEAR(`Date`) = 2021;

SELECT BANK FROM TRANSACTIONS WHERE YEAR(`Date`) = 2021;

-- In 2020 bank has launched new bank as 'DBS Bank' so need to update in Bank column
UPDATE TRANSACTIONS 
SET BANK = 'DBS Bank' WHERE BANK = '' AND YEAR(`Date`) = 2020;

SELECT BANK FROM TRANSACTIONS WHERE YEAR(`Date`) = 2020;

-- In 2019 bank has launched new bank as 'NORTHEN Bank' so need to update in Bank column
UPDATE TRANSACTIONS 
SET BANK = 'NORTHEN Bank' WHERE BANK = '' AND YEAR(`Date`) = 2019;

SELECT BANK FROM TRANSACTIONS WHERE YEAR(`Date`) = 2019;

-- In 2018 bank has launched new bank as 'SOUTHERN Bank' so need to update in Bank column
UPDATE TRANSACTIONS 
SET BANK = 'SOUTHERN Bank' WHERE BANK = '' AND YEAR(`Date`) = 2018;

SELECT BANK FROM TRANSACTIONS WHERE YEAR(`Date`) = 2018;

-- In 2017 bank has launched new bank as 'ADB Bank' so need to update in Bank column
UPDATE TRANSACTIONS 
SET BANK = 'ADB Bank' WHERE BANK = '' AND YEAR(`Date`) = 2017;

-- Some bank name still need to update which already exist in data colum of bank for the year 2017, need to replace with ADB
SELECT BANK FROM TRANSACTIONS WHERE YEAR(`DATE`)='2017' GROUP BY BANK;

UPDATE TRANSACTIONS set BANK = replace(BANK,'Moneta Money Bank','ADB Bank');

-- Noted all amount and money transactions appeared in data in CZK currency according to bank instructions we need to
-- convert them into USD while presenting in PBI
-- 1 CZK = 0.046735 USD 1 
-- CZK = 3.836706 INR

-- Total Average No of Deposits (Creidts)
SELECT AVG(AMOUNT) AS AVG_DEPOSITS FROM TRANSACTIONS
WHERE TYPE = 'Credit';

-- Total Average No of Withdrawal 
SELECT AVG(AMOUNT) AS AVG_Withdrawal FROM TRANSACTIONS
WHERE TYPE = 'Withdrawal';

-- Cash Reserve with bank – Annual Deposit and Withdrawal and surplus at year end, Average Balance, Total Balance
-- Find Cash Surplus
SELECT
(SELECT SUM(AMOUNT) AS TOTAL_DEPOSITS FROM TRANSACTIONS
WHERE TYPE = 'Credit')-(SELECT SUM(AMOUNT) AS TOTAL_Withdrawal FROM TRANSACTIONS
WHERE TYPE = 'Withdrawal') AS CASH_SURPLUS
FROM TRANSACTIONS
GROUP BY 1;

-- Total Average Balance 
SELECT round(AVG(balance),0) AS AVG_BALANCE FROM TRANSACTIONS;
-- OR
SELECT round(sum(balance)/count(account_id),0) AS AVG_BALANCE FROM TRANSACTIONS;

-- Total No of Clients/Account Holder
SELECT COUNT(CLIENT_ID) FROM CLIENT; -- No of Clients
SELECT COUNT(ACCOUNT_ID) FROM ACCOUNT; -- No of Account_id holder

-- No of Account holder with Account Type
SELECT ACCOUNT_TYPE, count(account_id) AS NO_OF_ACCOUNT_HOLDER
FROM ACCOUNT
GROUP BY ACCOUNT_TYPE; 

-- No of account in each region with average salary and account type
-- No of Account holder spread across region and their account type
-- Maximum Account holder from whihc region and whihc account type
-- Top region which had good environment for bank business and no of bank branch or client from this zone. 
-- The maximum clients which are falling in regions which comparatively safe and good earning zone salary vise
-- Loan defaulter account holder falling under which area which is not safe or recovery is bad 
-- The regions which are untapped by bank and considerably good for doing business 
-- Largest Type of Account CA, Saving A/c or NRI A/c
SELECT DISTRICT.Region, DISTRICT.Average_salary, count(ACCOUNT.account_id) AS ACCOUNT_HOLDERS, ACCOUNT.Account_type  
FROM DISTRICT   
INNER JOIN ACCOUNT
ON DISTRICT.District_Code = ACCOUNT.district_id
GROUP BY DISTRICT.Region
ORDER BY ACCOUNT_HOLDERS DESC;   

-- Region wise Defaulters count
SELECT DISTRICT.Region, DISTRICT.District_Name, count(LOAN.account_id) AS DEFAULTER 
FROM DISTRICT   
INNER JOIN LOAN
ON DISTRICT.District_Code = LOAN.account_id
WHERE status = 'Loan not payed'
GROUP BY DISTRICT.Region
ORDER BY Region;

-- Maximum Age group holding accounts in Bank
-- Age Group of Client
SELECT MIN(AGE), MAX(AGE) FROM CLIENT;

SELECT COUNT(DISTINCT AGE) AS AGE_GROUP FROM CLIENT;

-- Age Group of clients
/*
SELECT
CASE
    WHEN age < 20 THEN 'Under 20'
    WHEN age BETWEEN 20 and 29 THEN '20 - 29'
    WHEN age BETWEEN 30 and 39 THEN '30 - 39'
    WHEN age BETWEEN 40 and 49 THEN '40 - 49'
    WHEN age BETWEEN 50 and 59 THEN '50 - 59'
    WHEN age BETWEEN 60 and 69 THEN '60 - 69'
    WHEN age BETWEEN 70 and 79 THEN '70 - 79'
    WHEN age >= 80 THEN 'Over 80'
    WHEN age IS NULL THEN 'Not Filled In (NULL)'
END as age_range,
COUNT(*) AS count,
 CASE
    WHEN age < 20 THEN 1
    WHEN age BETWEEN 20 and 29 THEN 2
    WHEN age BETWEEN 30 and 39 THEN 3
    WHEN age BETWEEN 40 and 49 THEN 4
    WHEN age BETWEEN 50 and 59 THEN 5
    WHEN age BETWEEN 60 and 69 THEN 6
    WHEN age BETWEEN 70 and 79 THEN 7
    WHEN age >= 80 THEN 8
    WHEN age IS NULL THEN 9
END as ordinal
FROM (SELECT TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age FROM CLIENT) AS AGE_GROUP
GROUP BY age_range
ORDER BY ordinal
*/
SELECT
CASE
    WHEN age < 20 THEN 'Under 20'
    WHEN age BETWEEN 20 and 29 THEN '20 - 29'
    WHEN age BETWEEN 30 and 39 THEN '30 - 39'
    WHEN age BETWEEN 40 and 49 THEN '40 - 49'
    WHEN age BETWEEN 50 and 59 THEN '50 - 59'
    WHEN age BETWEEN 60 and 69 THEN '60 - 69'
    WHEN age BETWEEN 70 and 79 THEN '70 - 79'
    WHEN age >= 80 THEN 'Over 80'
    WHEN age IS NULL THEN 'Not Filled In (NULL)'
END as age_range,
COUNT(*) AS count
FROM CLIENT
GROUP BY age_range
ORDER BY 1
-- The below can be additonally added if Age column not been calculated earlier
-- "(SELECT TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age FROM CLIENT) as derived"

-- Finding Male Female 
SELECT 
SUM(CASE WHEN SEX = 'MALE' THEN 1 ELSE 0 END) AS MALE_CLIENT,
SUM(CASE WHEN SEX = 'FEMALE' THEN 1 ELSE 0 END) AS FEMALE_CLIENT
FROM CLIENT;

-- Finding Male Female PERCENTAGE
SELECT 
SUM(CASE WHEN SEX = 'MALE' THEN 1 ELSE 0 END)/COUNT(*)*100.0 AS MALE_PERC,
SUM(CASE WHEN SEX = 'FEMALE' THEN 1 ELSE 0 END)/COUNT(*)*100.0 AS FEMALE_CLIENT
FROM CLIENT;

-- Finding Male Female Ratio
SELECT ROUND((SUM(CASE WHEN SEX = 'MALE' THEN 1 ELSE 0 END)) /
(SUM(CASE WHEN SEX = 'FEMALE' THEN 1 ELSE 0 END))*100,2) AS MALE_FEMALE_RATIO_PERC
FROM CLIENT;

-- Non performing Assets (NPA) or Bad Debts
-- Finding Bad Debts (Loan not Paid and Clinet in debt)
SELECT YEAR(`Date`), sum(PAYMENTS) AS BAD_DEBTS 
FROM LOAN WHERE STATUS = 'Loan not payed'  
GROUP BY YEAR(`Date`) 
ORDER BY 1 DESC;

SELECT SUM(AMOUNT) AS BAD_DEBTS FROM LOAN 
WHERE STATUS = 'Loan Not payed' AND 'Client in debt';

-- Table for Loan Status with no of debtors with loan amount
SELECT STATUS, 
COUNT(LOAN_ID) AS DEBTORS, 
SUM(AMOUNT) AS LOAN_AMT
FROM LOAN
GROUP BY STATUS
ORDER BY LOAN_AMT;

SELECT STATUS,
(SELECT SUM(AMOUNT) FROM LOAN 
WHERE STATUS = 'Loan Not payed' AND 'Client in debt') AS BAD_DEBTS, 
COUNT(LOAN_ID) AS DEBTORS, 
SUM(AMOUNT) AS LOAN_AMT,
ROUND((BAD_DEBTS/LOAN_AMT)*100,2) AS DEBT_RATIO
FROM LOAN
GROUP BY STATUS
ORDER BY LOAN_AMT;

============================================DASHBOARD PBI KPI TRANSFORMATION==============================================
SELECT*FROM TRANSACTIONS;

DROP TABLE BANKING_TRAN_KPI;

CREATE TABLE BANKING_TRAN_KPI 
AS 
SELECT 
COUNT(CASE WHEN T.TYPE = 'Credit' THEN 1 END) AS TOTAL_DEPOSITORS,
COUNT(CASE WHEN T.TYPE = 'Withdrawal' THEN 1 END) AS TOTAL_WITHDRAWER,
COUNT(DISTINCT T.ACCOUNT_ID) AS TOT_ACCOUNT_HOLDERS,
COUNT(DISTINCT T.TRANS_ID) AS TOT_TRANSACTIONS,
ROUND(SUM(T.BALANCE),0) AS TOT_BALANCE,
ROUND(AVG(T.BALANCE),0) AS AVG_BALANCE
FROM TRANSACTIONS AS T;

SELECT*FROM BANKING_TRAN_KPI; 

DROP TABLE BANKING_ADD_KPI;

CREATE TABLE BANKING_ADD_KPI 
AS 
SELECT 
ROUND((K.TOTAL_DEPOSITORS/K.TOT_TRANSACTIONS)*100,0) AS DEPOSIT_PERC,
ROUND((K.TOTAL_WITHDRAWER/K.TOT_TRANSACTIONS)*100,0) AS WITHDRAWAL_PERC
FROM BANKING_TRAN_KPI AS K;

SELECT * FROM BANKING_ADD_KPI;

-- Cash Reserve with bank – Annual Deposit and Withdrawal and surplus at year end, Average Balance, Total Balance
-- Find Cash Surplus
SELECT
(SELECT SUM(AMOUNT) AS TOTAL_DEPOSITS FROM TRANSACTIONS
WHERE TYPE = 'Credit')-(SELECT SUM(AMOUNT) AS TOTAL_Withdrawal FROM TRANSACTIONS
WHERE TYPE = 'Withdrawal') AS CASH_SURPLUS
FROM TRANSACTIONS
GROUP BY 1;

============ TOPOGRAPHIC DAHSBOARDS KPI ========================================

-- No of account in each region with average salary and account type
-- No of Account holder spread across region and their account type
-- Maximum Account holder from whihc region and whihc account type
-- Top region which had good environment for bank business and no of bank branch or client from this zone. 
-- The maximum clients which are falling in regions which comparatively safe and good earning zone salary vise
-- Loan defaulter account holder falling under which area which is not safe or recovery is bad 
-- The regions which are untapped by bank and considerably good for doing business 
-- Largest Type of Account CA, Saving A/c or NRI A/c

DROP TABLE BANKING_TOPOGRPH_KPI 

CREATE TABLE BANKING_TOPOGRPH_KPI 
AS
SELECT DISTRICT.Region, DISTRICT.Average_salary, count(ACCOUNT.account_id) AS ACCOUNT_HOLDERS, ACCOUNT.Account_type  
FROM DISTRICT   
INNER JOIN ACCOUNT
ON DISTRICT.District_Code = ACCOUNT.district_id
GROUP BY DISTRICT.Region
ORDER BY ACCOUNT_HOLDERS DESC;   

SELECT * FROM BANKING_TOPOGRPH_KPI ;

-- Region wise Defaulters count
DROP TABLE BANKING_DEF_COUNT_KPI ;

CREATE TABLE BANKING_DEF_COUNT_KPI 
AS
SELECT DISTRICT.Region, DISTRICT.District_Name, count(LOAN.account_id) AS DEFAULTER 
FROM DISTRICT   
INNER JOIN LOAN
ON DISTRICT.District_Code = LOAN.account_id
WHERE status = 'Loan not payed'
GROUP BY DISTRICT.Region
ORDER BY Region;

SELECT * FROM BANKING_DEF_COUNT_KPI;

DROP TABLE BANKING_AGE_GROUP_KPI;
 
CREATE TABLE BANKING_AGE_GROUP_KPI 
AS
SELECT
CASE
    WHEN age < 20 THEN 'Under 20'
    WHEN age BETWEEN 20 and 29 THEN '20 - 29'
    WHEN age BETWEEN 30 and 39 THEN '30 - 39'
    WHEN age BETWEEN 40 and 49 THEN '40 - 49'
    WHEN age BETWEEN 50 and 59 THEN '50 - 59'
    WHEN age BETWEEN 60 and 69 THEN '60 - 69'
    WHEN age BETWEEN 70 and 79 THEN '70 - 79'
    WHEN age >= 80 THEN 'Over 80'
    WHEN age IS NULL THEN 'Not Filled In (NULL)'
END as AGE_GROUP,
COUNT(*) AS ACCOUNT_HOLDERS
FROM CLIENT
GROUP BY AGE_GROUP
ORDER BY 1;

SELECT*FROM BANKING_AGE_GROUP_KPI; 

-- Finding Male Female 
DROP TABLE BANK_GENDER_KPI;

CREATE TABLE BANK_GENDER_KPI
AS
SELECT 
SUM(CASE WHEN SEX = 'MALE' THEN 1 ELSE 0 END) AS MALE_CLIENT,
SUM(CASE WHEN SEX = 'FEMALE' THEN 1 ELSE 0 END) AS FEMALE_CLIENT,
SUM(CASE WHEN SEX = 'MALE' THEN 1 ELSE 0 END)/COUNT(*)*100.0 AS MALE_PERC,
SUM(CASE WHEN SEX = 'FEMALE' THEN 1 ELSE 0 END)/COUNT(*)*100.0 AS FEMALE_PERC,
ROUND((SUM(CASE WHEN SEX = 'MALE' THEN 1 ELSE 0 END)) /
(SUM(CASE WHEN SEX = 'FEMALE' THEN 1 ELSE 0 END))*100,2) AS MALE_FEMALE_RATIO_PERC
FROM CLIENT;

SELECT*FROM BANK_GENDER_KPI;

-- Exchange Rate conversation KPI
CREATE TABLE EXCHNAGE_CONVERTION
AS 
SELECT T.AMOUNT, T.BALANCE, L.AMOUNT, L.PAYMENTS, D.AVERAGE_SALARY

   

FROM AS T.TRANSACTIONS, L.LOAN, BGK.BANK_GENDER_KPI, BAK_BANKING_ADD_KPI, 
BDCK.BANKING_DEF_COUNT_KPI, BTKP.BANKING_TOPOGRPH_KPI, BTK.BANKING_TRAN_KPI  
INNER JOIN ACC_LATEST_TXNS_WITH_BALANCE AS ALWB ON T.ACCOUNT_ID = ALWB.ACCOUNT_ID
LEFT OUTER JOIN  ACCOUNT AS A ON T.ACCOUNT_ID = A.ACCOUNT_ID
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4;
/*
mr.currency AS currency,
            case   
               when f.product_sale_price != '0'
               then f.product_sale_price
               else f.product_price
               end feedprice,
            (select feedprice/exchange_rate from currencies where currency_code = currency) AS international_price

SELECT*FROM CLIENT
BAK.DEPOSIT_PERC, 
BAK.WITHDRAWAL_PERC, BTKP.AVERAGE_SALARY, BTK.TOTAL_BALANCE, BTK.AVG_WITHDR
*/

--------------------- THis need to be understand ----------------- 
-- WHAT IS THE DEMOGRAPHIC PROFILE OF THE BANK CLIENT'S AND HOW DOES ITS VARY ACROSS DISTRICT?
SELECT C.DISTRICT_ID, D.DISTRICT_NAME, D.AVERAGE_SALARY,
ROUND(AVG(C.AGE),0) AS AVG_AGE,
SUM(CASE WHEN SEX = 'MALE' THEN 1 ELSE 0 END) AS MALE_CLIENT,
SUM(CASE WHEN SEX = 'FEMALE' THEN 1 ELSE 0 END) AS FEMALE_CLIENT,
ROUND((FEMALE_CLIENT/MALE_CLIENT)*100,2) AS MALE_FEMALE_RATIO_PERC,
COUNT(*) AS TOTAL_CLIENT
FROM CLIENT C
INNER JOIN D.DISTRICT ON C.DISTRICT_ID = D.DISTRICT_CODE
GROUP BY 1,2,3
ORDER BY 1;

-- HOW THE BANKS HAVE PERFROMED OVER THE YEARS, GIVE THEIR DETIALS ANALYSIS MONTH WISE
SELECT*FROM ACC_LATEST_TXNS_WITH_BALANCE;

SELECT LATEST_TXN_DATE, COUNT(*) AS TOT_TXNS
FROM ACC_LATEST_TXNS_WITH_BALANCE
GROUP BY 1
ORDER BY 2 DESC;

-- Assuming that every last month customer account is getting transacted 
CREATE OR REPLACE TABLE ACC_LATEST_TXNS_WITH_BALANCE
AS 
SELECT LTD.*,TXN.BALANCE
FROM TRANSACTIONS AS TXN
INNER JOIN
(
SELECT ACCOUNT_ID, YEAR(`DATE`) AS TXN_YEAR,
MONTH(`DATE`) AS TXN_MONTH,
MAX(`DATE`) AS LATEST_TXN_DATE
FROM TRANSACTIONS
GROUP BY 1,2,3
ORDER BY 1,2,3

) AS LTD ON TXN.ACCOUNT_ID = LTD.ACCOIUNT_ID AND TXN.DATE= LTD.LATEST_TXN_DATE
WHERE TXN.TYPE = 'CREDIT'
ORDER BY TXN.ACCOUNT_ID,LTD.TXN_YEAR,LTD.TXN_MONTH;

-- CREATING BANKING KPI FOR POWER BI VISUALIZATION 
CREATE TABLE BANKING_KPI 
AS 
SELECT ALWB.TXN_YEAR, AWB.TXN_MONTH, T.BANK, A.ACCOUNT_TYPE,
COUNT(DISTINCT ALWB.ACCOUNT_ID) AS TOT_ACCOUNT,
COUNT(DISTINCT T.TRANS_ID) AS TOT_TXNS,
COUNT(CASE WHEN T.TYPE = 'Credit' THEN 1 END) AS DEPOSIT_COUNT,
COUNT(CASE WHEN T.TYPE = 'Withdrawal' THEN 1 END) AS WITHDRAWAL_COUNT,
SUM(ALWB.BALANCE) AS TOT_BALANCE,
ROUND((DEPOSIT_COUNT/TOT_TXNS)*100,2) AS DEPOSIT_PERC,
ROUND((WITHDRAWAL_COUNT/TOT_TXNS)*100,2) AS WITHDRAWAL_PERC,
NVL(TOT_BALANCE/TOT_ACCOUNT,0) AS AVG AVG_BALANCE,
ROUND(TOT_TXNS/TOT_ACCOUNT,0) AS TPA
FROM TRANSACTIONS AS T
INNER JOIN ACC_LATEST_TXNS_WITH_BALANCE AS ALWB ON T.ACCOUNT_ID = ALWB.ACCOUNT_ID
LEFT OUTER JOIN  ACCOUNT AS A ON T.ACCOUNT_ID = A.ACCOUNT_ID
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4;

SELECT * FROM BANKING_KPI



SELECT TXN_YEAR, COUNT(*) AS TOTAL
FROM BANKING_KPI
GROUP BY 1
ORDER BY 2 DESC;

SELECT * FROM BANKING_KPI
ORDER BY TXN_YEAR, BANK;

--------------------- THis need to be understand ----------------- 

-- ROUGH WORKING


ROUND((SELECT SUM(T.AMOUNT) FROM T WHERE T.TYPE = 'Withdrawal'),2) AS TOTAL_WITHDRAWAL_AMOUNT,
ROUND((SELECT SUM(T.AMOUNT) FROM T WHERE T.TYPE = 'Credit'),2) AS TOTAL_DEPOSITS_AMOUNT,
COUNT((TOTAL_DEPOSITORS/TOT_TRANSACTIONS)*100) AS DEPOSIT_PERC
ROUND(TOT_TRANSACTIONS DIV TOT_ACCOUNT_HOLDERS,0) AS TPA
ROUND((TOTAL_DEPOSITORS DIV TOT_TRANSACTIONS)*100,2) AS DEPOSIT_PERC,
ROUND((TOTAL_WITHDRAWER/TOT_TRANSACTIONS)*100,2) AS WITHDRAWAL_PERC,

SUM(T.AMOUNT) AS TOTAL_DEPOSITS_AMOUNT WHERE T.TYPE = 'Credit'
ROUND((SELECT SUM(T.AMOUNT) FROM T WHERE T.TYPE = 'Withdrawal'),2) AS TOTAL_WITHDRAWAL_AMOUNT
SUM(T.AMOUNT) AS TOTAL_WITHDRAWAL_AMOUNT WHERE T.TYPE = 'Withdrawal'
ROUND((SELECT SUM(T.AMOUNT) FROM T WHERE T.TYPE = 'Credit'),2) AS TOTAL_DEPOSITS_AMOUNT,





CREATE TABLE BANKING_TRAN_KPI 
AS 
SELECT T.YEAR(`DATE`), T.TYPE, T.ACCOUNT_ID, A.ACCOUNT_ID, T.BALANCE,
COUNT(CASE WHEN T.TYPE = 'Credit' THEN 1 END) AS TOTAL_DEPOSITORS,
COUNT(CASE WHEN T.TYPE = 'Withdrawal' THEN 1 END) AS TOTAL_WITHDRAWER,
SUM(T.BALANCE) AS TOT_BALANCE,
COUNT(DISTINCT A.ACCOUNT_ID) AS TOT_ACCOUNT_HOLDERS,
COUNT(DISTINCT T.TRANS_ID) AS TOT_TRANSACTIONS,
ROUND((SELECT SUM(T.AMOUNT) FROM T WHERE T.TYPE = 'Withdrawal'),2) AS TOTAL_WITHDRAWAL_AMOUNT,
ROUND((SELECT SUM(T.AMOUNT) FROM T WHERE T.TYPE = 'Credit'),2) AS TOTAL_DEPOSITS_AMOUNT,
ROUND((TOTAL_DEPOSITORS/TOT_TRANSACTIONS)*100,2) AS DEPOSIT_PERC,
ROUND((TOTAL_WITHDRAWER/TOT_TRANSACTIONS)*100,2) AS WITHDRAWAL_PERC,
ROUND(TOT_TRANSACTIONS/TOT_ACCOUNT_HOLDERS,0) AS TPA
FROM TRANSACTIONS AS T
INNER JOIN  ACCOUNT AS A ON T.ACCOUNT_ID = A.ACCOUNT_ID
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4;

NVL(TOT_BALANCE/TOT_ACCOUNT_HOLDERS,0) AS AVG AVG_BALANCE,
SUM((T.AMOUNT) WHERE TYPE = 'Withdrawal') AS TOTAL_WITHDRAWAL_AMOUNT,
SUM(CASE WHEN T.AMOUNT = 'Credit' THEN 1 ELSE 0 END) AS TOTAL_DEPOSITS_AMOUNT,
ROUND(TOTAL_DEPOSITS_AMOUNT-TOTAL_WITHDRAWAL_AMOUNT,2) AS CASH_SURPLUS,

ROUND(SUM(T.AMOUNT) WHERE T.TYPE = 'Credit',2) AS TOTAL_DEPOSITS_AMOUNT,
ROUND(SUM(T.AMOUNT) WHERE T.TYPE = 'Withdrawal',2) AS TOTAL_WITHDRAWAL_AMOUNT,



SELECT DISTINCT YEAR(`DATE`), COUNT(*)
FROM ACCOUNT
GROUP BY 1
ORDER BY 1 DESC;


SELECT BANK, REPLACE(BANK,'','ADB Bank') 
FROM TRANSACTIONS 
WHERE YEAR(`DATE`)='2017';

update TRANSACTIONS set BANK = replace(BANK,'J&T Bank','ADB Bank');

SELECT BANK FROM TRANSACTIONS WHERE YEAR(`DATE`)='2017' GROUP BY BANK

SELECT YEAR(`DATE`) AS TXN_YEAR, COUNT(*) AS TOT_TXN
FROM TRANSACTIONS
WHERE BANK IS NULL
GROUP BY 1
ORDER BY 1 DESC;

UPDATE TRANSACTIONS
SET BANK = 'Sky Bank' WHERE BANK IS NULL AND YEAR(DATE) = 2021;






DESC LOAN;


SELECT YEAR(`Date`) AS TXN_YEAR, count(ACCOUNT_ID), MAX(ACCOUNT_ID)
FROM TRANSACTIONS WHERE TYPE = 'Withdrawal'
GROUP BY TXN_YEAR; 

SELECT YEAR(`Date`) AS TXN_YEAR, count(ACCOUNT_ID), MAX(ACCOUNT_ID)
FROM TRANSACTIONS WHERE TYPE = 'Credit'
GROUP BY TXN_YEAR; 

SELECT MAX(ACCOUNT_ID) FROM TRANSACTIONS WHERE TYPE = 'Withdrawal' limit 10;

SELECT city, count(ACCOUNT_ID AS "Maximum Income"   
FROM employees   
GROUP BY city  
HAVING MAX(income) >= 200000; 

SELECT YEAR(`Date`) AS TXN_YEAR, SUM(AMOUNT) AS CR_TXN, SUM(AMOUNT) AS WID_TXN
FROM TRANSACTIONS
GROUP BY 1 
ORDER BY 1 DESC;

SELECT YEAR(`Date`) AS TXN_YEAR, SUM(AMOUNT) AS TXN_AMNT
FROM TRANSACTIONS
GROUP BY TYPE = 'Credit', 'Withdrawal'  
ORDER BY 1 DESC;

SELECT * FROM TRANSACTIONS WHERE ((SELECT YEAR(`Date`) AS TXN_YEAR, SUM(AMOUNT) AS CR_TXN FROM TRANSACTIONS 
WHERE TYPE = 'Credit') AND (SELECT YEAR(`Date`) AS TXN_YEAR, SUM(AMOUNT) AS WID_TXN FROM TRANSACTIONS 
WHERE TYPE = 'Withdrawal'))
GROUP BY 1 
ORDER BY 1 DESC;

-- Find any null transaction year wise
SELECT YEAR(`Date`) AS TXN_YEAR, COUNT(*) AS TOT_TXN
FROM TRANSACTIONS
WHERE BANK IS NULL
GROUP BY 1
ORDER BY 1 DESC;


SELECT emp_age, MAX(income) AS "Maximum Income"   
FROM employees   
GROUP BY emp_age;  

SELECT city, MAX(income) AS "Maximum Income"   
FROM employees   
GROUP BY city  
HAVING MAX(income) >= 200000;  

SELECT * FROM employees WHERE   
emp_age = (SELECT MAX(emp_age) FROM employees); 

 SELECT emp_name, city, COUNT(*) FROM employees GROUP BY city;
 
 SELECT emp_name, emp_age, COUNT(*) FROM employees   
GROUP BY emp_age   
HAVING COUNT(*)>=2   
ORDER BY COUNT(*);  

UPDATE tableA a
INNER JOIN tableB b ON a.name_a = b.name_b
SET validation_check = if(start_dts > end_dts, 'VALID', '');
-- where clause can go here


SELECT officers.officer_name, officers.address, students.course_name  
FROM officers   
INNER JOIN students  
ON officers.officer_id = students.student_id;   


select
      MaxProduced.MostThings,
      F.FarmerName
   from
   ( select
          max( PreQuery.ThingsGrownByFarmer ) MostThings
       from
          ( select
                  S.FarmerID,
                  count(*) as ThingsGrownByFarmer
               from
                  Supplies S
               group by
                  S.FarmerID ) PreQuery ) MaxProduced
             JOIN ( select
                         S.FarmerID,
                         count(*) as ThingsGrownByFarmer
                      from
                         Supplies S
                      group by
                         S.FarmerID ) AllFarmersCounts
               on MaxProduced.MostThings = AllFarmersCounts.ThingsGrownByFarmer
               JOIN Farmer F
                  on AllFarmersCounts.FarmerID = F.FarmerID

SELECT country,pub_city,MAX(no_of_branch)              
FROM publisher           
GROUP BY country,pub_city           
ORDER BY country;



select distinct date('YEAR',date) from ACCOUNT;

SELECT DATE_TRUNC('YEAR',date) from ACCOUNT AS YR_FROM_DATE;

SELECT date, EXTRACT(YEAR FROM date) from account group by date;

SELECT *,YEAR(date)
FROM account_clean
WHERE YEAR(date)=1995; 


SELECT * REPLACE(date,'1995','2015') FROM publisher WHERE date = 1995;

insert into ChangeYear(ArrivalTime) values('2015-4-24');

set ArrivalTime = DATE_FORMAT(ArrivalTime,'2019-%m-%d');

UPDATE table_name SET date_col=DATE_FORMAT(date_col,'2013-%m-%d');

UPDATE calldata
SET date = CONCAT('2014-01-01 ', TIME(date))
WHERE DATE(date) = '2014-01-08'

UPDATE table_name
SET date_col=DATE_FORMAT(date_col,'2013-%m-%d %T');

UPDATE table_name SET date_col=DATE_FORMAT('2013-05-06',YEAR(CURRENT_DATE)-%m-%d);


UPDATE account_clean
SET date=DATE_FORMAT(date,'2013-%m-%d')
WHERE date=('1995-%m-%d')

UPDATE account_clean 
SET YEAR(date)=2013
WHERE YEAR(date)=1995;

-- 1Convert the Date attribute into a yyyy-mm-dd by adding 24 in year format in Excel or SQL 
●	1993 -> 2017
●	1994 -> 2018
●	1995 -> 2019
●	1996 -> 2020
●	1997 -> 2021



select *from account_clean

select * ,
case 
	when length(course_name) = 4  then "len 4"
    when length(course_name)= 2  then "len 2"
    else "other lenght"
end as statement 
from ineuron_course

update ineuron_course set course_name = case 
when course_name = 'RL' then 'reinforcement learing'
when course_name = 'dl' then 'deep learning'
end 

update account_clean set frequency = case 
when frequency = 'POPLATEK MESICNE' then 'Monthly Issuance'
when frequency = 'POPLATEKTYDNE' then 'Weekly Issuance'
when frequency = 'POPLATEK POBRATU' then 'Issuance After a Transaction'
end 

select *from account_clean

ALTER TABLE account_clean   
ADD COLUMN card_assigned VARCHAR(50) AFTER Account_type;  



insert into account_clean(card_assigned) values where frequency = 'Monthly Issuance' as 'Silever'   

ALTER TABLE person
ADD salary int(20);
UPDATE persons SET salary = '145000' where Emp_Id=12;

drop table card_clean

select * from card_clean

UPDATE card_clean SET issued = TO_DATE(issued,'yyyy-mm-dd');

UPDATE card_clean SET issued =str_to_date(date_format(issued,'%Y-%m-%d'));

SELECT TO_CHAR(TO_DATE('1993-08-17'),'DD-MM-YYYY') AS DATE_DD_MM_YYYY;

UPDATE my_table SET new_col=TO_DATE(old_col,'MM/DD/YYYY');

select issued (str_to_date(issued,'yyyy-mm-dd')) as issued_Date from card_clean;

select date_format(str_to_date('12/31/2011', '%m/%d/%Y'), '%Y%m');

alter table card_clean modify issued datetime;

alter table card_clean change issued issued_date varchar(30);

select* from card_clean

alter table card_clean
modify issued int;

select format(issued,'yy-mm-dd') from card_clean

select issued convert(datetime,(left(issued,11)+' '+right(issued,8))) from card_clean

SELECT * FROM bank.client;

select birth_number= subdate(birth_number, interval +50 year) from client

select*from client

desc loan_clean



select * from loan_clean;






"C:\card.csv"
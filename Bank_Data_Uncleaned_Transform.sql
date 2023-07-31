CREATE DATABASE BANK_Uncleaned;
use BANK_Uncleaned;

CREATE TABLE IF NOT EXISTS account (
account_id int,	
district_id	int,
frequency varchar(100),	
date date,	
Account_type varchar(100));

SELECT * FROM ACCOUNT

desc account

LOAD DATA INFILE 'C:/account.csv'
into table account
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

drop table card

CREATE TABLE IF NOT EXISTS card (
card_id INT,
disp_id INT,
type varchar(100),
issued varchar(100));

SELECT * FROM card
DESC CARD

-- I have getting error here 1265 becuase of some of in my column "membertype" obviously has one or more values which are longer than 3 chars. 
-- That's why you get this message from the server.
-- not sure if running MySQL in strict mode. Need to Turn it off and the above message should not appear. so chechked with below syntax
SHOW VARIABLES LIKE 'sql_mode'

-- Appeared below message sql_mode	"STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION" its means its running under strict mode.
-- In this case you have to run an UPDATE on your data and truncate them manually. Then, change the column definition and the error should not pop up.
-- Alternatively, remove STRICT_TRANS_TABLES from the global(!) sql_mode variable (Host > Variables) with a doubleclick, 
-- reconnect to the server and apply your changes.

LOAD DATA INFILE 'C:/card.csv'
into table card
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

DROP TABLE CLIENT

CREATE TABLE IF NOT EXISTS client (
client_id int,
birth_number int,
district_id int);

SELECT * FROM client

LOAD DATA INFILE 'C:/client.csv'
into table client
FIELDS TERMINATED by ';'
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS disp (
disp_id int,
client_id int,	
account_id int,
type varchar(50));

SELECT * FROM disp

LOAD DATA INFILE 'C:/disp.csv'
into table disp
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

drop table district

CREATE TABLE district (
A1 int,	
A2 varchar(100),	
A3 varchar(100),	
A4 int,	
A5 int,	
A6 int,	
A7 int,	
A8 int,	
A9 int,	
A10 int,	
A11 int,	
A12 int,	
A13 int,	
A14 int,	
A15	int,
A16 int);

CREATE TABLE district (
district_code int,	
district_name varchar(100),
region varchar(100),
no_of_inhabitants int,	
`no_of_municipalties_with_inhabitants<499` int,
`no_of_municipalties_with_inhabitants_500-1999` int,
`no_of_municipalties_with_inhabitants_2000-9999` int,
`no_of_municipalties_with_inhabitants>10000` int,
no_of_cities int,
ratio_of_urban_inhabitants int,
average_salary int,
unemployment_rate_95 decimal(4,2), -- when data vlaues are in decimal please make sure you put this data type(error no 1366)	
unemployment_rate_96 decimal(4,2), -- when data vlaues are in decimal please make sure you put this data type
no_of_entrpreneurs_per_1000_inhabitants int,	
no_of_committed_crimes_95 int,
no_of_committed_crimes_96 int);

-- After an erroe of 1366 for wrong decimal value I tried to change datatye int to decimal(4,2) but it shows still an error
-- Then I clear the strict SQL Mode using below syntex, If strict mode is not in effect, 
-- MySQL inserts adjusted values for invalid or missing values and produces warnings (see Section 13.7.5.40, “SHOW WARNINGS Syntax”). 
-- In strict mode, you can produce this behavior by using INSERT IGNORE or UPDATE IGNORE.

SET SQL_MODE = ""

SELECT * FROM district

LOAD DATA INFILE 'C:/district.csv'
into table district
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS loan (
loan_id int,
account_id int,
date varchar(50),
amount int,
duration int,
payments int,
status varchar(50));

SELECT * FROM loan

LOAD DATA INFILE 'C:/loan.csv'
into table loan
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

-- This is somthing new instead of \'\\n\' i put here \'\\r\\n\' to terminate error 1406 "Data too long for column \'status\' at row 1
LOAD DATA INFILE 'C:/loan.csv'
into table loan
FIELDS TERMINATED by ';'
ENCLOSED by '"'
lines terminated by '\r\n' 
IGNORE 1 ROWS;


CREATE TABLE IF NOT EXISTS orders (
order_id int,
account_id int,
Bank_to varchar(50),
account_to int,
amount int);

SELECT * FROM orders;

LOAD DATA INFILE 'C:/order.csv'
into table orders
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS tranx_16 (
trans_id int,
account_id int,	
Date date,	
Type varchar(100),	
operation varchar(100),	
amount int,	
balance int,	
Purpose varchar(50),	
bank varchar(100),	
account_partern_id int);

SELECT * FROM tranx_16;

LOAD DATA INFILE 'C:/tranx_16.csv'
into table tranx_16
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

-- Transformation on each table for Table account:-
-- 1. Convert the Date attribute into a yyyy-mm-dd by adding 24 in year format in Excel or SQL 
●	1993 -> 2017
●	1994 -> 2018
●	1995 -> 2019
●	1996 -> 2020
●	1997 -> 2021

update account
set date = subdate(date, interval -24 year)

select * from account

-- 2.	Replace in frequency attribute “POPLATEK MESICNE” AS Monthly Issuance, “POPLATEKTYDNE” AS Weekly Issuance, 
-- and “POPLATEK POBRATU” AS Issuance After a Transaction in Excel or create a case statement in SQL

update account set frequency = case 
when frequency = 'POPLATEK MESICNE' then 'Monthly Issuance'
when frequency = 'POPLATEKTYDNE' then 'Weekly Issuance'
when frequency = 'POPLATEK POBRATU' then 'Issuance After a Transaction'
end 

select *from account
desc account

-- 3.	Create a Custom Column Card_Assigned and assign below : 
●	Silver -> Monthly issuance
●	Diamond - weekly issuance
●	Gold - Issuance after a transaction

ALTER TABLE account 
ADD COLUMN card_assigned VARCHAR(50) AFTER Account_type;

update account set card_assigned = case 
when frequency = 'Monthly Issuance' then 'Silver'
when frequency = 'Weekly Issuance' then 'Diamond'
when frequency = 'Issuance After a Transaction' then 'Gold'
end 

alter table account modify column date date;

-- Transformation on each table for Table card:-

-- 1.	Replace type attribute value “junior” as Sliver, “Classic” as Gold,
-- And “Gold” as Diamond by using replace in Excel or by using update in SQL

update card set type = case 
when type = 'classic' then 'Gold'
when type = 'junior' then 'Silver'
when type = 'gold' then 'Diamond'
end 

select * from card

-- 2.	Convert issued attribute into yyyy-mm-dd adding 24 in year. (

 -- Changed the colum name 
alter table card change issued issued_date varchar(30);

-- Check first if split the colum into two parts 970615 and 00:00:00 (https://www.youtube.com/watch?v=ix8-VnotLuI)
select substring_index(issued_date,' ',1) from card

-- after checking result ok updated the colum with spilt and extract only date parts

update card
set issued_date = substring_index(issued_date,' ',1);

-- Check here if to put '-' in date to separate year, monht and date part and create date in mormat of YYYY-MM-DD format

select cast(replace(issued_date, '-','')as date) from card
-- (https://www.youtube.com/watch?v=Q8x--bZn0_o)
-- After chechking result ok updated the same things and formated the column in YYYY-MM-DD but still in varchar datatype need to change as date

update card
set issued_date = cast(replace(issued_date, '-','')as date);

-- Now change the varchar data structure into specific date format
UPDATE card
SET issued_date = date_format(str_to_date(issued_date, '%Y-%m-%d'),'%Y-%m-%d');

-- alter the datatype varchar into date
alter table card modify column issued_date date;

-- can chechk with below command
desc card

-- Convert issued attribute into yyyy-mm-dd adding 24 in year (insyntax its actually need to put -24)
update card
set issued_date = subdate(issued_date, interval -24 year)

-- Transformation on each table for Table client:-
-- 1.	Convert bith_number attribute to yyyy-mm-dd format and also create another column named sex by applying in 
-- bith_number 0 for females and 1 for males.

ALTER TABLE client 
ADD COLUMN sex VARCHAR(50) AFTER client_id;

ALTER TABLE client 
ADD COLUMN birth_date date AFTER sex;

update client set sex = case 
when birth_number mod 2 = 1 then 'Male'
else 'Female'
end 

select from_unixtime(birth_number,'%Y-%m-%d') as DateDemo from client;

SELECT LEFT(birth_number,2)+24 as year, MId(birth_number,3,2) as month, right(birth_number,2) as Date FROM client;

SELECT date(LEFT(birth_number,2)+24, MId(birth_number,3,2), right(birth_number,2)) FROM client;

=YEAR(E2)&"-"&RIGHT(TRIM(100+MONTH(E2)),2)&"-"&RIGHT(TRIM(100+DAY(E2)),2)

SELECT from_unixtime((LEFT(birth_number,2)+24, MId(birth_number,3,2),right(birth_number,2)),'%Y-%m-%d') AS DateDemo FROM client;

select birth_number = subdate(birth_number, interval -24 year) from client

update client set birth_date = 
when sex = 'Male' then from_unixtime(birth_number,'%Y-%m-%d')
else from_unixtime(birth_number,'%Y-%m-%d')

ALTER TABLE CLIENT
ADD AGE int(20);
UPDATE CLIENT SET AGE = datediff('YEAR', 'BIRTH_DATE','2022-12-31');

select * from client

desc client

-- Rename the table 
alter table bank.client rename Client;

-- Transformation on each table for Table district:-
-- 1.	Change all column names and delete the attributes a12 and a13

select * from district

-- Rename the column

alter table district rename column A1 to district_code	
alter table district rename column A2 to district_name	
alter table district rename column A3 to region	
alter table district rename column A4 to no_of_inhabitants	
alter table district rename column A5 to `no_of_municipalties_with_inhabitants<499`	
alter table district rename column A6 to `no_of_municipalties_with_inhabitants_500-1999`	
alter table district rename column A7 to `no_of_municipalties_with_inhabitants_2000-9999`	
alter table district rename column A8 to `no_of_municipalties_with_inhabitants>10000`	
alter table district rename column A9 to no_of_cities	
alter table district rename column A10 to ratio_of_urban_inhabitants	
alter table district rename column A11 to average_salary	
alter table district rename column A12 to unemployment_rate_95	
alter table district rename column A13 to unemployment_rate_96	
alter table district rename column A14 to no_of_entrpreneurs_per_1000_inhabitants	
alter table district rename column A15 to no_of_committed_crimes_95	
alter table district rename column A16 to no_of_committed_crimes_96 

alter table district rename column no_of_committed_crimes_95 to no_of_committed_crimes_2017	
alter table district rename column no_of_committed_crimes_96 to no_of_committed_crimes_2018 

-- Transformation on each table for Table loan:-
1.	Convert the Date Attribute into yyyy-mm-dd format adding 23 in year.
2.	Convert Status Attribute value “A” as Contract Finished, “B” as Loan Not Paid, “C” as Running Contract, and “D” Client in debt.

select * from loan

desc loan
select subdate(date, interval -24 year) from loan;
alter table loan modify column date date;

update loan
set date = subdate(date, interval -24 year)

alter table loan modify column status varchar(50);

update loan set status = case 
when status = 'A' then 'Contract Finished'
when status = 'B' then 'Loan Not Paid'
when status = 'C' then 'Running Contract'
when status = 'D' then 'Client in debt'
end 



ALTER TABLE dbo.doc_exa 
ADD column_b VARCHAR(20) NULL, column_c INT NULL ;



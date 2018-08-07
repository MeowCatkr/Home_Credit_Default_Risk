show databases;

use  DF1803;
show tables;
select * from application_train limit 100;
select * from bureau;
select * from bureau_balance;

select * from application_train a  
join  bureau b on (a.SK_ID_CURR=b.SK_ID_CURR) 
join bureau_balance bb on (b.SK_ID_BUREAU=bb.SK_ID_BUREAU);


desc application_train;
# ----- 
ALTER TABLE application_train ADD INDEX (SK_ID_CURR);
ALTER TABLE bureau ADD INDEX (SK_ID_CURR);
ALTER TABLE bureau ADD INDEX (SK_ID_BUREAU);
ALTER TABLE bureau_balance ADD INDEX (SK_ID_BUREAU);
SHOW INDEX FROM application_train;
SHOW INDEX FROM bureau;
SHOW INDEX FROM bureau_balance;


ALTER TABLE bureau_balance DROP INDEX SK_ID_BUREAU_3;

    
select CREDIT_ACTIVE, count(CREDIT_ACTIVE) c from bureau where credit_active in ('Sold','Bad debt') group by CREDIT_ACTIVE order by c desc;
select distinct (credit_currency) from bureau;
select credit_currency, count(credit_currency) c from bureau group by credit_currency order by c desc;

select distinct (credit_type) from bureau;
select credit_type, count(credit_type) c from bureau group by credit_type order by c desc;



# credit beauro - 215354 - GOOD CUSTOMER
select * from application_train  where SK_ID_CURR='215354';
select * from bureau where SK_ID_CURR='215354' order by CREDIT_ACTIVE desc,DAYS_CREDIT;
select * from bureau_balance bb join bureau b on (bb.SK_ID_BUREAU=b.SK_ID_BUREAU) where b.SK_ID_CURR='215354';

# credit beauro - 100002 -  BAD CUSTOMER
select * from application_train  where SK_ID_CURR='100002';
select * from bureau where SK_ID_CURR='100002' order by CREDIT_ACTIVE desc, DAYS_CREDIT;
select bb.* from bureau_balance bb join bureau b on (bb.SK_ID_BUREAU=b.SK_ID_BUREAU) where b.SK_ID_CURR='100002';
select b.*,'-------------',bb.* from bureau_balance bb right join bureau b on (bb.SK_ID_BUREAU=b.SK_ID_BUREAU) where b.SK_ID_CURR='100002';


# credit beauro - 100031 -  BAD CUSTOMER
select * from application_train  where SK_ID_CURR='100031';
select * from bureau where SK_ID_CURR='100031' order by CREDIT_ACTIVE desc, DAYS_CREDIT;
select b.*,'-------------',bb.* from bureau_balance bb right join bureau b on (bb.SK_ID_BUREAU=b.SK_ID_BUREAU) where b.SK_ID_CURR='100031';


select * from previous_application;

select 
	SK_ID_CURR
	, count(sk_id_bureau) as 'Total_CB' 
    , sum(case when CREDIT_ACTIVE = 'Closed' then 1 else 0  end) as 'Credit_Closed'
    , sum(case when CREDIT_ACTIVE = 'Active' then 1 else 0  end) as 'Credit_active'
    , sum(case when CREDIT_ACTIVE = 'Sold' then 1 else 0  end) as 'Credit_Sold'
    , sum(case when CREDIT_ACTIVE = 'Bad debt' then 1 else 0  end) as 'Credit_BadDebt'
    , count( distinct credit_currency) as 'How_Many_Currency'
    , sum(CNT_CREDIT_PROLONG) as 'Total_Credit_Prolong' # Question -  take avg or sum ?
    
    , sum(case when CREDIT_TYPE = 'Consumer credit' then 1 else 0  end) as 'CreditType_ConsumerCredit'
    , sum(case when CREDIT_TYPE = 'Credit card' then 1 else 0  end) as 'CreditType_CreditCard'
    , sum(case when CREDIT_TYPE = 'Mortgage' then 1 else 0  end) as 'CreditType_Mortgage'
    , sum(case when CREDIT_TYPE = 'Car loan' then 1 else 0  end) as 'CreditType_CarLoan'
    , sum(case when CREDIT_TYPE = 'Microloan' then 1 else 0  end) as 'CreditType_Microloan'
    
    , sum(case when CREDIT_TYPE = 'Loan for working capital replenishment' then 1 else 0  end) as 'CreditType_WorkingCapitalReplenishment'
    , sum(case when CREDIT_TYPE = 'Loan for business development' then 1 else 0  end) as 'CreditType_BusinessDevelopment'
	, sum(case when CREDIT_TYPE = 'Real estate loan' then 1 else 0  end) as 'CreditType_RealEstateLoan'
    , sum(case when CREDIT_TYPE in ('Unknown type of loan','Another type of loan') then 1 else 0  end) as 'CreditType_Other'
    , sum(case when CREDIT_TYPE = 'Cash loan (non-earmarked)' then 1 else 0  end) as 'CreditType_CashLoan'
    
    , sum(case when CREDIT_TYPE = 'Loan for the purchase of equipment' then 1 else 0  end) as 'CreditType_PurchaseOfEquipment'
    , sum(case when CREDIT_TYPE = 'Mobile operator loan' then 1 else 0  end) as 'CreditType_MobileOperatorLoan'
    , sum(case when CREDIT_TYPE = 'Interbank credit' then 1 else 0  end) as 'CreditType_InterbankCredit'
    , sum(case when CREDIT_TYPE = 'Loan for purchase of shares (margin lending)' then 1 else 0  end) as 'CreditType_PurchaseOfShares'
    from bureau 
    #where sk_id_curr='100031'
    group by SK_ID_CURR limit 100;
    
select * from Bureau_Grouped;
    



### --- Application data and bureau data join
select a.TARGET,a.sk_id_curr,bg.* from application_train a inner join
 (
 
 
 select 
	SK_ID_CURR
	, count(sk_id_bureau) as 'Total_CB' 
    , sum(case when CREDIT_ACTIVE = 'Closed' then 1 else 0  end) as 'Credit_Closed'
    , sum(case when CREDIT_ACTIVE = 'Active' then 1 else 0  end) as 'Credit_active'
    , sum(case when CREDIT_ACTIVE = 'Sold' then 1 else 0  end) as 'Credit_Sold'
    , sum(case when CREDIT_ACTIVE = 'Bad debt' then 1 else 0  end) as 'Credit_BadDebt'
    , count( distinct credit_currency) as 'How_Many_Currency'
    , sum(CNT_CREDIT_PROLONG) as 'Total_Credit_Prolong' # Question -  take avg or sum ?
    
    ########## CREDIT TYPE #########
    , sum(case when CREDIT_TYPE = 'Consumer credit' then 1 else 0  end) as 'CreditType_ConsumerCredit'
    , sum(case when CREDIT_TYPE = 'Credit card' then 1 else 0  end) as 'CreditType_CreditCard'
    , sum(case when CREDIT_TYPE = 'Mortgage' then 1 else 0  end) as 'CreditType_Mortgage'
    , sum(case when CREDIT_TYPE = 'Car loan' then 1 else 0  end) as 'CreditType_CarLoan'
    , sum(case when CREDIT_TYPE = 'Microloan' then 1 else 0  end) as 'CreditType_Microloan'
    
    , sum(case when CREDIT_TYPE = 'Loan for working capital replenishment' then 1 else 0  end) as 'CreditType_WorkingCapitalReplenishment'
    , sum(case when CREDIT_TYPE = 'Loan for business development' then 1 else 0  end) as 'CreditType_BusinessDevelopment'
	, sum(case when CREDIT_TYPE = 'Real estate loan' then 1 else 0  end) as 'CreditType_RealEstateLoan'
    , sum(case when CREDIT_TYPE in ('Unknown type of loan','Another type of loan') then 1 else 0  end) as 'CreditType_Other'
    , sum(case when CREDIT_TYPE = 'Cash loan (non-earmarked)' then 1 else 0  end) as 'CreditType_CashLoan'
    
    , sum(case when CREDIT_TYPE = 'Loan for the purchase of equipment' then 1 else 0  end) as 'CreditType_PurchaseOfEquipment'
    , sum(case when CREDIT_TYPE = 'Mobile operator loan' then 1 else 0  end) as 'CreditType_MobileOperatorLoan'
    , sum(case when CREDIT_TYPE = 'Interbank credit' then 1 else 0  end) as 'CreditType_InterbankCredit'
    , sum(case when CREDIT_TYPE = 'Loan for purchase of shares (margin lending)' then 1 else 0  end) as 'CreditType_PurchaseOfShares'
    from bureau 
    group by SK_ID_CURR
 
 
 
 ) as bg on (a.SK_ID_CURR = bg.sk_id_curr) ;



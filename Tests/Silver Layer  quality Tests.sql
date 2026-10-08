/*
===================================================================================================================================
Quality Checks
===================================================================================================================================
Script Purpose:
This script performs various quality checks for data consistency, accuracy, and standardization across the 'silver' schemas. It includes checks for: 
 -Null or duplicate primary keys.
 -Unwanted spaces in string fields.
 -Data standardization and consistency.
 -Invalid date ranges and orders.
 -Data consistency between related fields.
Usage Notes:
    -Run these checks after data loading Silver Layer.
    -Investigate and resolve any discrepancies found during the checks.
============================================================================================================================
 */
--=============================================================================================================================
 --silver.crm_Cust_info  quality checking 
--=============================================================================================================================

-- check for nulls or duplicates in primary key 
-- Expectation : No result
select
cst_id,
count(*)
from silver.crm_Cust_info
group by cst_id
having   count(*) > 1 or cst_id is null

--check for unwanted spaces 
select
cst_firstname
from silver.crm_Cust_info
where cst_firstname!=trim(cst_firstname) --the checking is the same for the next columns

--Data Standardization and consistency
select distinct 
cst_gndr
from silver.crm_Cust_info ---the same checking for marital status

--=============================================================================================================================
-- silver.crm_prd_info quality checking 
--=============================================================================================================================


--check the repeated value
--expected result: no repeatition
select
prd_id,
count(1) quant
from silver.crm_prd_info
group by prd_id
having count(1) !=1

--check for nulls or Negative numbers 
-- expected result: no Results
select
prd_cost
from silver.crm_prd_info
where prd_cost is null or prd_cost < 0

--data standardization and consistency

select distinct
prd_line
from silver.crm_prd_info
--check for invalid date order
select*
from bronze.crm_prd_info
where substring(prd_key,7,len(prd_key)) in  ('HL-U509-R','HL-U509-B')

--===================================================================================================================
--silver.crm_sales_details quality checking 
--===================================================================================================================
--check for invalid Dates
select
sls_order_dt
from silver.crm_sales_details
where sls_order_dt <= 0 or len(sls_order_dt)!=8 
 or sls_order_dt <19000101
or sls_order_dt > 20500101
--checking for invalid date orders
select
*
from silver.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt

--check for wrong calculations
select
sls_sales,
sls_quantity,
sls_price
from silver.crm_sales_details
where sls_sales <=0 or sls_sales is null
or sls_quantity <=0 or sls_quantity is null
or sls_price <=0 or sls_price is null

--====================================================================================================================================
--silver.erp_CUST_AZ12  quality checking 
--====================================================================================================================================

--filtering wrong dates 
select
 bdate
from silver.erp_CUST_AZ12
where  bdate> getdate()

--Data standardization and consistency
select distinct
gen
from silver.erp_CUST_AZ12


--====================================================================================================================================
 --silver.erp_LOC_A101 quality checking 
--====================================================================================================================================

--data stnadardization check consistency
select  distinct 
CNTRY
from silver.erp_LOC_A101


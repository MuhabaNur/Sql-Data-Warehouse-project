/*
================================================================================================================
DDL Script: Create Gold Views
================================================================================================================
Script Purpose:
This script creates views for the Gold layer in the data warehouse. The Gold layer represents the final dimension and fact tables (Star Schema).
Each view performs transformations and combines data from the Silver layer to produce a clean, enriched, and business-ready dataset.
Usage:
     -These views can be queried directly for analytics and reporting.
=================================================================================================================
*/

If object_id('gold.dim_customers','v') is not null 
    Drop view gold.dim_customers ;
    GO 
--==============================================================================================================
  --create Dimension : gold.dim_customers
--==============================================================================================================
create view gold.dim_customers as 
select
row_number() over(order by cst_id ) customer_key,
ci.cst_id as customer_id,
ci.cst_key customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname last_name,
sa.CNTRY country,
ci.cst_marital_status marital_status,
case when ci.cst_gndr !='n/a'then ci.cst_gndr--crm_cst_gndr is master column
     else coalesce(ca.GEN,'n/a')
     end Gender,
ci.cst_create_date create_date,
ca.BDATE birth_date
from silver.crm_cust_info ci
left join   silver.erp_LOC_A101 sa
on ci.cst_key=sa.CID
left join silver.erp_cust_AZ12 ca
on ci.cst_key=ca.CID

--==============================================================================================================
  --create Dimension : gold.dim_Products
--==============================================================================================================

If object_id('gold.dim_products','v') is not null 
    Drop view  gold.dim_products ;
    GO 

create view gold.dim_products as
select
Row_number() over( order by prd_start_dt,prd_key ) product_key,--surrogate key
pn.prd_id  as product_id,
pn.prd_key as product_number,
pn.prd_nm  as product_name,
pn.cat_key as category_key,
ep.Category ,
ep.SUBCAT  as  subcategory,
pn.prd_cost as cost,
ep.Maintainance,
pn.prd_line as product_line,
pn.prd_end_dt as product_end_date
from silver.crm_prd_info pn
left join silver.erp_PX_CAT_G1V2 ep
on pn.cat_key=ep.ID
where prd_end_dt is null  --fitering out historical data

--==============================================================================================================
  --create Fact : gold.Fact_sales
--==============================================================================================================
  
 If object_id('gold.fact_sales','v') is not null 
    Drop view gold.fact_sales ;
    GO 

create view gold.fact_sales as
SELECT  
       sd.sls_ord_num as order_number
      ,dp.product_key
      ,dc.customer_key
      ,sls_order_dt order_date
      ,sls_ship_dt as ship_date
      ,sls_due_dt as due_date
      ,sls_sales sales_amount
      ,sls_quantity quantity
      ,sls_price  price 
  FROM silver.crm_sales_details sd
  left join gold.dim_customers dc
  on sd.sls_cust_id =dc.customer_id
  Left join gold.dim_products dp
  on sd.sls_prd_key=dp.product_number

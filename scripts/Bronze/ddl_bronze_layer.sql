/*
DDL Script:
create Bronze Tables
===================================================================================================
Script Purpose:
 This script creates tables in the 'bronze' schema, dropping existing tables if they already exist.
Run this script to re-define the DDL structure of 'bronze' Tables
====================================================================================================
=
*/
if object_id ('bronze.Crm_Cust_info ' ,'u') is not null 
  DROP table bronze.Crm_Cust_info 
Create Table bronze.crm_Cust_info (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date Date,
);

if object_id ('bronze.crm_prd_info ' ,'u') is not null 
  DROP table bronze.crm_prd_info
create table bronze.crm_prd_info(
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost int,
prd_line NVARCHAR (50),
prd_start_dt Date,
prd_end_dt Date
);

if object_id ('bronze.crm_sales_details' ,'u') is not null 
  DROP table bronze.crm_sales_details
create table bronze.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int
);

if object_id ('bronze.erp_cust_AZ12' ,'u') is not null 
  DROP table bronze.erp_cust_AZ12
Create Table bronze.erp_cust_AZ12
(
CID NVARCHAR(50),
BDATE Date,
GEN NVARCHaR(50)
) ;

if object_id ('bronze.erp_LOC_A101' ,'u') is not null 
  DROP table bronze.erp_LOC_A101
Create Table bronze.erp_LOC_A101
( CID NVARCHAR(50),
 CNTRY NVARCHAR(50) 
) ;

if object_id ('bronze.erp_PX_CAT_G1V2' ,'u') is not null 
  DROP table bronze.erp_PX_CAT_G1V2
Create Table bronze.erp_PX_CAT_G1V2
(
ID  NVARCHAR(50),
Category nvarchar(50),
SUBCAT NVARCHAR(50),
Maintainance NVARCHAR(50)
) ;





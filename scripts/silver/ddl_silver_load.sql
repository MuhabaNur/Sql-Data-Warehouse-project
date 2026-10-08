/*
==================================================================================================
DDL Script: Create Silver Tables
==================================================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables if they already exist.
    Run this script to re-define the DDL structure of 'bronze Tables
==================================================================================================
                                                                                                   */
if object_id ('silver.Crm_Cust_info ' ,'u') is not null 
  DROP table silver.Crm_Cust_info 
Create Table silver.crm_Cust_info (
cst_id INT,
cst_key NVARCHAR(50),
cst_firtsname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_material_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date Date,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

if object_id ('silver.crm_prd_info ' ,'u') is not null 
  DROP table silver.crm_prd_info
create table silver.crm_prd_info(
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost int,
prd_line NVARCHAR (50),
prd_start_dt Date,
prd_end_dt Date,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

if object_id ('silver.crm_sales_details' ,'u') is not null 
  DROP table silver.crm_sales_details
create table silver.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt Date,
sls_due_dt Date,
sls_sales int,
sls_quantity int,
sls_price int,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

if object_id ('silver.erp_cust_AZ12' ,'u') is not null 
  DROP table silver.erp_cust_AZ12
Create Table silver.erp_cust_AZ12
(
CID NVARCHAR(50),
BDATE Date,
GEN NVARCHaR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
) ;

if object_id ('silver.erp_LOC_A101' ,'u') is not null 
  DROP table silver.erp_LOC_A101
Create Table silver.erp_LOC_A101
( CID NVARCHAR(50),
 CNTRY NVARCHAR(50),
 dwh_create_date DATETIME2 DEFAULT GETDATE()
) ;

if object_id ('silver.erp_PX_CAT_G1V2' ,'u') is not null 
  DROP table silver.erp_PX_CAT_G1V2
Create Table silver.erp_PX_CAT_G1V2
(
ID  NVARCHAR(50),
Category nvarchar(50),
SUBCAT NVARCHAR(50),
Maintainance NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
) ;





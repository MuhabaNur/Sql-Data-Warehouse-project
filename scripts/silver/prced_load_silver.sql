/*
==================================================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===================================================================================================================
Script Purpose:
  This stored procedure performs the ETL (Extract, Transform, Load) process to schema tables from the 'bronze' schema.
populate the 'silver' schema table from 'bronze'schema.
Actions Performed:
  -Truncates Silver tables.
  -Inserts transformed and cleansed data from Bronze into Silver tables.
Parameters:
  None.
  This stored procedure does not accept any parameters or return any values.
Usage Example:
           EXEC Silver.load_silver;
*/
create or alter procedure silver.load_silver as 
begin 
begin try
declare @starttime datetime,@endtime datetime, @batchstarttime datetime, @batchendtime datetime

print '========================================================================================================================';
print 'load transformed crm files in to silver layer';
print '========================================================================================================================';
print'--------------------------------------------------------------------------------------------------------------------------';
print 'loading  bronze. crm_Cust_info ';  
print'--------------------------------------------------------------------------------------------------------------------------';
set @batchstarttime=getdate()
set @starttime=getdate()
print '>> truncate table crm_Cust_info>> ';
truncate table silver.crm_Cust_info
print '>> insert  table crm_Cust_info>> ';
insert into silver.crm_Cust_info (
       cst_id
       ,cst_key
      ,cst_firstname
      ,cst_lastname
      ,cst_marital_status
      ,cst_gndr
      ,cst_create_date
      
                      )
select    
 cst_id
,cst_key
,trim(cst_firstname) cst_firstname
,trim(cst_lastname) as cst_lastname
,case when upper(trim(cst_marital_status))='S'then 'Single'
      when upper(trim(cst_marital_status))='M' then 'Married'
      else 'n/a' 
      End cst_marital_status,

case when upper(trim(cst_gndr))='F' then 'Female'
     When upper(trim(cst_gndr))='M' then 'Male'
     else 'n/a'
end cst_gndr
,cst_create_date     
from (
select*
,row_number() over(partition by cst_id order by cst_create_date Desc) flag_date
from bronze.crm_Cust_info
) ek
where flag_date=1
 set @endtime=getdate()
 print 'loading duration:' + cast(datediff(second,@starttime,@endtime) as varchar) +'seconds';

 set @starttime=getdate()
print'--------------------------------------------------------------------------------------------------------------------------';
print 'loading  bronze. crm_prd_info ';  
print'--------------------------------------------------------------------------------------------------------------------------';
print '>> truncate table crm_prd_info>> ';
truncate table silver.crm_prd_info
print '>> insert  table crm_prd_info>> ';
insert into silver.crm_prd_info(
prd_id,
cat_key,
prd_key,
prd_nm,
prd_cost,
prd_line,         
prd_start_dt,
prd_end_dt
)
SELECT 
    prd_id
    ,replace(substring(prd_key,1,5),'-','_') cat_key -- extract category key
    ,substring(prd_key,7,len(prd_key))prd_key -- extract product key
    ,prd_nm
    ,isnull(prd_cost,0) prd_cost
 ,case upper(trim(prd_line))
      when 'M'  then 'Mountain'
      when 'R'  then 'Road'
      when 'S'  then 'Sales'
      when 'T'  then 'Touring'
      else 'n/a'
End prd_line -- map product line codes to descriptive values
    ,prd_start_dt 
  ,dateadd(day,-1,lead(prd_start_dt,1) over(partition by prd_key order by prd_start_dt ))  prd_end_dt /* caculate the end date as one day before 
  the next start date*/
FROM  bronze.crm_prd_info 
set @endtime=getdate()
print 'loading duration:' + cast(datediff(second,@starttime,@endtime) as varchar) +'seconds';

set @starttime=getdate()
print'--------------------------------------------------------------------------------------------------------------------------';
print 'loading  bronze. crm_sales_details ';  
print'--------------------------------------------------------------------------------------------------------------------------'; 
print '>> truncate crm_sales_details>> ';
truncate table silver.crm_sales_details
print '>> insert  crm_sales_details>> ';
insert into silver.crm_sales_details (
sls_ord_num
      ,sls_prd_key
      ,sls_cust_id
      ,sls_order_dt
      ,sls_ship_dt
      ,sls_due_dt
      ,sls_sales
      ,sls_quantity
      ,sls_price)
select 
       sls_ord_num
      ,sls_prd_key
      ,sls_cust_id
      ,case when sls_order_dt <=0 or len( sls_order_dt)!=8 then null
       else cast(cast(sls_order_dt as varchar) as date) 
       end sls_order_dt
      
      ,case when  sls_ship_dt <=0  or len(sls_ship_dt)!=8 then null
       else cast(cast(sls_ship_dt as varchar) as date)
       end sls_ship_dt
      ,Case when sls_due_dt <=0 or len(sls_due_dt) !=8 then null
       else cast(cast(sls_due_dt as varchar) as date)
       end sls_due_dt
      ,
      case when sls_sales <= 0 or sls_sales is null or sls_sales !=sls_quantity*abs(sls_price)
           then sls_price *abs(sls_quantity) --recalculating sales if original value is missing or incorrect
        else sls_sales
        end  sls_sales
      ,sls_quantity
      
      ,case when sls_price <=0 or sls_price is null then sls_sales/nullif(sls_quantity,0)
      else sls_price --derive price if original value is invalid
      end  sls_price
from bronze.crm_sales_details
where sls_price <=0  or sls_price is null 
or sls_sales <= 0 or sls_sales is null

set @endtime=getdate()
set @batchendtime=getdate()
print 'loading duration:' + cast(datediff(second,@starttime,@endtime) as varchar) +'seconds';
print 'batch loading duration:' + cast(datediff(second,@batchstarttime,@batchendtime) as varchar)+'seconds';



print '========================================================================================================================';
print 'load transformed erp files in to silver layer';
print '========================================================================================================================';
print'--------------------------------------------------------------------------------------------------------------------------';
print 'loading  bronze. erp_cust_AZ12 ';  
print'--------------------------------------------------------------------------------------------------------------------------';

set @batchstarttime=getdate() 
set @starttime=getdate()

print '>> truncate erp_cust_AZ12 >> ';
truncate table silver.erp_cust_AZ12
print '>> insert  erp_cust_AZ12 >> ';
insert into silver.erp_cust_AZ12 
(
CID,
BDATE,
GEN
)
select
case When cid like'NAS%' then substring(CID,4,len(CID)) --remove 'NAS' prefix if present
else CID
end CID,
case when BDATE > getdate() then null   --set future birthdates to null 
else BDATE 
end BDATE,

Case  when upper(trim(gen)) in('F' ,'Female') then 'Female'
      when upper(trim(gen)) in('M' ,'Male') then 'Male'
      else 'n/a'
end GEN --Normalize gender values and handle  unknown cases
from bronze.erp_cust_AZ12
set @endtime=getdate()
print 'loading duration:' + cast(datediff(second,@starttime,@endtime) as varchar);

set @starttime=getdate()
print'--------------------------------------------------------------------------------------------------------------------------';
print 'loading  erp_LOC_A101 ';  
print'--------------------------------------------------------------------------------------------------------------------------';
print '>> truncate erp_LOC_A101 >> ';
truncate table silver.erp_LOC_A101
print '>> insert  erp_LOC_A101 >> ';
insert into silver.erp_LOC_A101
(CID,cntry)
SELECT 
  replace(CID,'-','')CID
 ,case 
  when cntry in ('US','USA') then trim('United states' )
  when cntry in ('DE' ,'Germany') then trim('Germany')
  when cntry =' ' or cntry is null  then 'n/a'
  else trim(cntry) end cntry
  FROM bronze.erp_LOC_A101
  set @endtime=getdate()
  print 'loading duration:' + cast(datediff(second,@starttime,@endtime) as varchar) +'seconds';

set @starttime=getdate()
print'--------------------------------------------------------------------------------------------------------------------------';
print 'loading erp_PX_CAT_G1V2 ';  
print'--------------------------------------------------------------------------------------------------------------------------';  
print '>> truncate erp_PX_CAT_G1V2 >> ';
Truncate Table silver.erp_PX_CAT_G1V2 
print '>> insert  erp_PX_CAT_G1V2 >> ';
Insert into silver.erp_PX_CAT_G1V2 
  (
  ID,
  Category,
  SUBCAT,
  Maintainance
  )
select
  ID,
  Category,
  SUBCAT,
  Maintainance
from bronze.erp_PX_CAT_G1V2 
set @endtime=getdate()
set @batchendtime=getdate()
print 'loading duration:' + cast(datediff(second,@starttime,@endtime) as varchar) +'seconds';
print 'batchloading duration:' + cast(datediff(second,@batchstarttime,@batchendtime) as varchar) +'seconds';
end try
begin catch
print'==================================================================================';
print'during silver layer loading error occured :';
print 'error message :'+ error_message();
print 'error message :' + cast(error_number() as varchar) ;
print 'error message:' + cast(error_state () as varchar) ;
end catch
print'==================================================================================';

end





  








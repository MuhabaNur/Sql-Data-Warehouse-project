/*
==================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===================================================================================
Script Purpose:
external sv This stored procedure loads data into the 'bronze' schema from external CSV files.
It performs the following actions:
-Truncates the bronze tables before loading data.
Uses the BULK INSERT` command to load data from csv Files to bronze tables.
Parameters:
None.
This stored procedure does not accept any parameters or return any values.
Usage Example:
EXEC bronze.load_bronze;
=====================================================================================
*/
create or alter procedure bronze.load_bronze as
begin 
	Begin try
	declare @start_time Datetime,@Endtime Datetime,@batchstarttime Datetime,@batchendtime Datetime

	Set @batchstarttime=Getdate();
	print '============================================================================================================';
	print 'load a bronze layer';
	print '============================================================================================================';
	print '------------------------------------------------------------------------------------------------------------';
	print 'load crm file';
	print '------------------------------------------------------------------------------------------------------------';

	set @start_time=getdate();
	print' >>Truncate bronze.crm_cust_info  >>';
	print' >>insert bronze.crm_cust_info  >>' ;
	truncate table bronze.crm_cust_info;
	bulk insert bronze.crm_cust_info
	from 'C:\Users\XPS\OneDrive\Desktop\SQL Projects\source_crm\cust_info.csv'
	with 
	(
	firstrow=2,
	fieldterminator=',',
	tablock);
	set @Endtime= getdate();

	print '>> loading duration :'  + cast(datediff(second,@start_time, @Endtime ) as Nvarchar) + 'seconds';

	set @start_time=getdate();
	print' >>Truncate bronze.crm_prd_info  >>';
	print' >>insert bronze.crm_prd_info  >>';
	truncate table bronze.crm_prd_info;
	Bulk insert bronze.crm_prd_info
	from 'C:\Users\XPS\OneDrive\Desktop\SQL Projects\source_crm\prd_info.csv'
	 with
	 (
	 firstrow=2,
	 fieldterminator=',',
	 tablock
	 )
	 set @Endtime= getdate();
	 print '>> loading duration :'  + cast(datediff(second, @Endtime, @start_time) as Nvarchar) + 'seconds';

	set @start_time=getdate();
	print' >>Truncate bronze.crm_sales_details >>';
	print' >>insert bronze.crm_sales_details  >>';
	truncate table bronze.crm_sales_details;
	Bulk insert bronze.crm_sales_details
	from 'C:\Users\XPS\OneDrive\Desktop\SQL Projects\source_crm\sales_details.csv'
	 with
	 (
	 firstrow=2,
	 fieldterminator=',',
	 tablock
	 )
	 set @Endtime= getdate();
	 set @batchendtime=getdate();
	 print '>> loading duration :'  + cast(datediff(second, @Endtime, @start_time) as Nvarchar) + 'seconds';
	  print '>> Batch loading duration :'  + cast(datediff(second, @batchendtime, @batchstarttime) as Nvarchar) + 'seconds';

	set @batchstarttime=Getdate();
	print '------------------------------------------------------------------------------------------------------------';
	print 'load erp file';
	print '------------------------------------------------------------------------------------------------------------';

	set @start_time=getdate();
	print' >>Truncate bronze.erp_CUST_AZ12 >>';
	print' >>insert bronze.erp_CUST_AZ12  >>';
	truncate table bronze.erp_CUST_AZ12;
	Bulk insert bronze.erp_CUST_AZ12
	from 'C:\Users\XPS\OneDrive\Desktop\SQL Projects\source_erp\CUST_AZ12.csv'
	 with
	 (
	 firstrow=2,
	 fieldterminator=',',
	 tablock
	 ) 
	set @Endtime= getdate();
	print '>> loading duration :'  + cast(datediff(second, @Endtime, @start_time) as Nvarchar) + 'seconds';

	set @start_time=getdate();
	print' >>Truncate bronze.erp_LOC_A101>>';
	print' >>insert  bronze.erp_LOC_A101  >>';
	truncate table bronze.erp_LOC_A101;
	Bulk insert bronze.erp_LOC_A101
	from 'C:\Users\XPS\OneDrive\Desktop\SQL Projects\source_erp\LOC_A101.csv'
	 with
	 (
	 firstrow=2,
	 fieldterminator=',',
	 tablock
	 )

	print' >>Truncate bronze.erp_PX_CAT_G1V2 >>';
	print' >>insert  bronze.erp_PX_CAT_G1V2 >>';
	truncate table bronze.erp_PX_CAT_G1V2;
	Bulk insert bronze.erp_PX_CAT_G1V2
	from 'C:\Users\XPS\OneDrive\Desktop\SQL Projects\source_erp\PX_CAT_G1V2.csv'
	 with
	 (
	 firstrow=2,
	 fieldterminator=',',
	 tablock
	 )
	 set @Endtime= getdate();
	set @batchendtime=getdate();
	print '>> loading duration :'  + cast(datediff(second, @Endtime, @start_time) as Nvarchar) + 'seconds';
	print '>> Batch loading duration :'  + cast(datediff(second, @Batchendtime, @batchstarttime) as Nvarchar) + 'seconds';
	Print '>> bronze layer loading ended';
	 end try
	 Begin Catch
	 print '=============================================================================';
	 Print 'Error Occured during loading bronze layer'
	 print 'error Message:' + error_message() ;
	 print 'error Message :' + cast(error_number()  as nvarchar);
	 print 'error message :' + cast(error_state() as varchar);
	 print '=============================================================================';
	 End catch
 
 End
 
 execute bronze.load_bronze
